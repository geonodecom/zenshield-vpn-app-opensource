// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dart_peer_repo/src/classes/buffer_processors/buffer_processor.dart';
import 'package:dart_peer_repo/src/classes/buffer_processors/https_buffer_processor.dart';
import 'package:dart_peer_repo/src/classes/buffer_processors/smtp_buffer_processor.dart';
import 'package:dart_peer_repo/src/classes/singbox_monitor.dart';
import 'package:dart_peer_repo/src/classes/socks5_client.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:eventify/eventify.dart';
import 'package:uuid/uuid.dart';
import '../serivces/P2P.service.dart';
import 'p2p_helper.dart';

class TargetSocket {
  EventEmitter emitter = EventEmitter();
  late RawSocket targetSocket;
  RawSocket requestHandlerSocket;
  var request;
  var buffer;
  int retries = 0;
  bool isRetrying = false;
  bool isDead = false;
  bool remoteSocketClosed = false;
  bool targetWebsiteRespond = false;
  bool _bufferFlushed = false;
  late BufferProcessor remoteBufferProcessor;
  late BufferProcessor targetBufferProcessor;
  bool useBufferProcessor = true;
  String id = const Uuid().v4();

  final List<Uint8List> _clientWriteQueue = [];
  bool _isWritingToClient = false;
  Timer? _retryWriteTimer;

  TargetSocket(
      {required this.requestHandlerSocket, this.request, this.buffer}) {
    _initBufferProcessors();
  }

  _initBufferProcessors() {
    if (isSMTP()) {
      remoteBufferProcessor = SmtpBufferProcessor();
      targetBufferProcessor = SmtpBufferProcessor();
    } else {
      remoteBufferProcessor = HttpsBufferProcessor();
      targetBufferProcessor = HttpsBufferProcessor();
    }
  }

  bool isSMTP() {
    final portStr = request['port'];

    final port = int.tryParse(portStr ?? '');
    return port != null && [25, 587, 465].contains(port);
  }

  bool isHttps() {
    return request['method'].toLowerCase() == 'connect';
  }

  bool shouldUseBufferProcessor() {
    return useBufferProcessor && (isSMTP() || isHttps());
  }

  Future connect() async {
    if (request == null || isDead) return;
    final int port = int.tryParse(request['port']) ?? 80;

    try {
      if (getIsDebug) {
        logPrint('connecting to target socket => ${request['host']}, $port');
      }

      bool useSingbox = await SingboxMonitor().getSingboxEnabled();

      if (getIsDebug) {
        logPrint('🎯 Connecting to ${request['host']}:$port');
        logPrint(
            '   Singbox: ${useSingbox ? "ENABLED → SOCKS5" : "DISABLED → Direct"}');
      }

      if (useSingbox) {
        await _connectThroughSingbox(request['host'], port);
      } else {
        await _connectDirect(request['host'], port);
      }

      targetSocket.setOption(SocketOption.tcpNoDelay, true);

      targetSocket.timeout(const Duration(seconds: 7), onTimeout: (e) async {
        if (isDead || remoteSocketClosed) return;

        onSocketErrorEvent('timeout');
        await P2PHelper().closeSocket(targetSocket, 'TargetSocket');
      });

      if (getIsDebug) {
        logPrint('target socket connected');
      }
      isRetrying = false;
      targetWebsiteRespond = false;

      try {
        targetSocket.listen((event) {
          switch (event) {
            case RawSocketEvent.read:
              // Read incoming data
              final data = targetSocket.read();
              if (data != null) {
                onSocketDataEvent(data);
              }
              break;

            case RawSocketEvent.write:
              // Socket is ready to send more data
              if (getIsDebug) {
                logPrint('Target -> Ready to write more data if needed.');
              }
              break;

            case RawSocketEvent.closed:
              if (getIsDebug) {
                logPrint('Target -> Connection closed');
              }
              break;

            case RawSocketEvent.readClosed:
              if (getIsDebug) {
                logPrint('Target -> Socket is closed for reading.');
              }
              if (shouldUseBufferProcessor()) {
                targetBufferProcessor.flush((record) {
                  _queueWriteToClient(record);
                });
                _bufferFlushed = true;
              }
              break;
          }
        }, onError: (e) async {
          if (getIsDebug) {
            logPrint('target socket error: $e');
          }
          onSocketErrorEvent(e);
        }, onDone: () async {
          onSocketCloseEvent();
        });
      } catch (e) {
        if (getIsDebug) {
          logPrint('Cannot listen to target socket (already listening): $e');
        }
      }

      if (isHttps()) {
        _queueWriteToClient(utf8.encode(
            '${request['httpVersion']} 200 Connection Established\r\n\r\n'));
      }

      if (!isHttps()) {
        try {
          P2PHelper().writeToSocket(targetSocket, buffer, 'Target');
        } catch (e) {
          if (getIsDebug) {
            logPrint('targetSocket.write error: $e');
          }
        }
      }
      return;
    } catch (e) {
      if (getIsDebug) {
        logPrint('error on target socket connection : $e');
      }
      return;
    }
  }

  // write(Uint8List data) {
  //   if (shouldUseBufferProcessor()) {
  //     if (getIsDebug) {
  //       print('write to target website -> ${data.length}');
  //     }
  //     remoteBufferProcessor.concat(data);
  //     remoteBufferProcessor.process((record) {
  //       P2PHelper().writeToSocket(targetSocket, record, 'Target');
  //     });
  //   } else {
  //     P2PHelper().writeToSocket(targetSocket, data, 'Target');
  //   }
  // }

  void onSocketCloseEvent() {
    if (isRetrying || isDead) return;

    if (!_bufferFlushed && shouldUseBufferProcessor()) {
      targetBufferProcessor.flush((record) {
        _queueWriteToClient(record);
      });
      _bufferFlushed = true;
    }

    _waitForQueueFlushBeforeClose();
  }

  void _waitForQueueFlushBeforeClose() {
    if (_clientWriteQueue.isEmpty) {
      _cleanupAndClose();
      return;
    }

    if (getIsDebug) {
      logPrint(
          'Waiting for write queue to flush before closing. Queue size: ${_clientWriteQueue.length}');
    }

    int attempts = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      attempts++;

      if (_clientWriteQueue.isEmpty) {
        timer.cancel();
        _cleanupAndClose();
      } else if (attempts >= 20) {
        if (getIsDebug) {
          logPrint(
              'Write queue flush timeout. Discarding ${_clientWriteQueue.length} items');
        }
        timer.cancel();
        _clientWriteQueue.clear();
        _cleanupAndClose();
      } else if (!_isWritingToClient) {
        _flushClientWriteQueue();
      }
    });
  }

  void _cleanupAndClose() {
    _retryWriteTimer?.cancel();
    emitter.emit(P2PEvents.onTargetSocketEnd);
  }

  void onSocketErrorEvent(error) {
    if (isDead || remoteSocketClosed) return;
    emitter.emit(P2PEvents.onTargetWebsiteError, null, error);
  }

  void onSocketDataEvent(Uint8List buffer) {
    targetWebsiteRespond = true;

    if (getIsDebug) {
      final responseText = String.fromCharCodes(buffer);

      final ipMatch = RegExp(r'"ip"\s*:\s*"([^"]+)"').firstMatch(responseText);
      if (ipMatch != null) {
        logPrint('🌐 IP Response detected!');
        logPrint('   Source: ${request?['host']}');
        logPrint('   IP Address: ${ipMatch.group(1)}');
      }

      final preview = responseText.length > 200
          ? responseText.substring(0, 200)
          : responseText;
      if (getIsDebug && responseText.isNotEmpty) {
        logPrint(
            '📡 Response from ${request?['host']}: ${preview.length} chars');
        if (preview.contains('HTTP/') ||
            preview.contains('{') ||
            preview.contains('"ip"')) {
          logPrint('   Preview: $preview');
        }
      }
    }

    if (shouldUseBufferProcessor()) {
      if (getIsDebug) {
        logPrint('write to target website -> ${buffer.length}');
      }
      targetBufferProcessor.concat(buffer);
      targetBufferProcessor.process((record) async {
        _queueWriteToClient(record);
      });
    } else {
      _queueWriteToClient(buffer);
    }
  }

  Future<void> _connectThroughSingbox(String host, int port) async {
    try {
      Socks5Client socks5Client = Socks5Client(
        host: '127.0.0.1',
        port: 10801,
      );

      print(
          '[GeoNode Status] TargetSocket connecting via Singbox to $host:$port (attempt 2)');
      targetSocket = await socks5Client.connectToTarget(host, port);
      print(
          '[GeoNode Status] TargetSocket connected via Singbox to $host:$port (attempt 2)');

      if (getIsDebug) {
        logPrint('TargetSocket -> Connected through Singbox to $host:$port');
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint(
            'TargetSocket -> Singbox connection failed, falling back to direct: $e');
      }
      await _connectDirect(host, port);
    }
  }

  Future<void> _connectDirect(String host, int port) async {
    print(
        '[GeoNode Status] TargetSocket connecting directly to $host:$port (fallback)');
    targetSocket =
        await RawSocket.connect(host, port, timeout: Duration(seconds: 7));
    print(
        '[GeoNode Status] TargetSocket connected directly to $host:$port (fallback)');

    if (getIsDebug) {
      logPrint('TargetSocket -> Connected directly to $host:$port');
    }
  }

  void _queueWriteToClient(Uint8List data) {
    _clientWriteQueue.add(data);
    if (!_isWritingToClient) {
      _flushClientWriteQueue();
    }
  }

  void onClientSocketReadyToWrite() {
    _flushClientWriteQueue();
  }

  void _flushClientWriteQueue() {
    if (_isWritingToClient || _clientWriteQueue.isEmpty) return;

    _isWritingToClient = true;
    _retryWriteTimer?.cancel();

    while (_clientWriteQueue.isNotEmpty) {
      final data = _clientWriteQueue.first;

      if (getIsDebug) {
        logPrint('writing to RequestHandlerSocket, data count ${data.length}');
      }

      try {
        final written = requestHandlerSocket.write(data);

        if (written == data.length) {
          _clientWriteQueue.removeAt(0);
          emitter.emit(P2PEvents.onRequestCalculateResponse, null, written);
        } else if (written > 0) {
          _clientWriteQueue[0] = data.sublist(written);
          emitter.emit(P2PEvents.onRequestCalculateResponse, null, written);
          _isWritingToClient = false;
          _scheduleRetryWrite();
          return;
        } else {
          if (getIsDebug) {
            logPrint(
                'RequestHandlerSocket buffer full, will retry. Queue size: ${_clientWriteQueue.length}');
          }
          emitter.emit(P2PEvents.onRequestCalculateResponse, null, 0);
          _isWritingToClient = false;
          _scheduleRetryWrite();
          return;
        }
      } catch (e) {
        if (getIsDebug) {
          logPrint('error writing to RequestHandlerSocket: $e');
        }
        _clientWriteQueue.removeAt(0);
        emitter.emit(P2PEvents.onRequestCalculateResponse, null, 0);
      }
    }

    _isWritingToClient = false;
  }

  void _scheduleRetryWrite() {
    _retryWriteTimer?.cancel();
    _retryWriteTimer = Timer(const Duration(milliseconds: 50), () {
      if (_clientWriteQueue.isNotEmpty && !_isWritingToClient && !isDead) {
        if (getIsDebug) {
          logPrint(
              'Retrying write to RequestHandlerSocket. Queue size: ${_clientWriteQueue.length}');
        }
        _flushClientWriteQueue();
      }
    });
  }

  close() {
    _retryWriteTimer?.cancel();
    _clientWriteQueue.clear();
    targetSocket.close();
  }
}
