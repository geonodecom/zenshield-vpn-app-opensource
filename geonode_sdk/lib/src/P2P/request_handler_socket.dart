import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_peer_repo/src/P2P/main_socket.dart';
import 'package:dart_peer_repo/src/P2P/socks5/socks5_socket.dart';
import 'package:dart_peer_repo/src/P2P/target_socket.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:dart_peer_repo/src/shared/settings.dart';
import 'package:eventify/eventify.dart';

import '../serivces/P2P.service.dart';
import 'p2p_helper.dart';

const _connectionTimeout = Duration(seconds: 30);

class RequestHandlerSocket {
  final EventEmitter emitter = EventEmitter();
  late String _ip;
  late int _port;
  late String? _reqId;
  late String _peerId;
  late RawSocket _sourceSocket;
  Socks5Handler? sourceSocks5Handler;
  TargetSocket? targetSocket;
  bool isTargetSocketInit = false;
  bool isConnectedToSocketServer = false;

  final List<Uint8List> _writeQueue = [];
  bool _isWriting = false;
  Timer? _retryWriteTimer;

  Settings globalSettings = Settings();
  get _isReusable => globalSettings.settings['is_reusable_socket_mode_on'];

  bool _isStandBy = false;
  get isStandBy => _isStandBy;

  bool _isStandByWaiting = false;
  get isStandByWaiting => _isStandByWaiting;

  get _standByMode {
    if (_isStandByWaiting) return 2;
    if (_isStandBy) return 1;
    return 0;
  }

  RequestHandlerSocket(
    String ip,
    int port,
    String? reqId,
    String peerId, {
    bool standBy = false,
    bool standByWaiting = false,
  }) {
    _ip = ip;
    _port = port;
    _reqId = reqId ?? '';
    _peerId = peerId;
    _isStandBy = standBy;
    _isStandByWaiting = standByWaiting;
  }

  Future connect() async {
    if (_isStandBy && !globalSettings.settings['is_stand_by_socket_mode_on']) {
      return;
    }

    try {
      print(
          '[GeoNode Status] RequestHandler connecting to $_ip:$_port (reqId: $_reqId)');
      _sourceSocket =
          await RawSocket.connect(_ip, _port, timeout: _connectionTimeout);
      print(
          '[GeoNode Status] RequestHandler connected to $_ip:$_port (reqId: $_reqId)');
      debugPrint('RequestHandlerSocket. Connected to $_ip:$_port ($_reqId)');
      isConnectedToSocketServer = true;
    } catch (err) {
      debugPrint(
          'RequestHandlerSocket. Error connecting to $_ip:$_port ($_reqId): $err');
      emitter.emit('error', null, err);
      return;
    }

    _sourceSocket.setOption(SocketOption.tcpNoDelay, true);
    if (_isReusable) {
      P2PService.enableKeepalive(_sourceSocket);
    }

    _sourceSocket.listen(
      (event) {
        switch (event) {
          case RawSocketEvent.read:
            final data = _sourceSocket.read();
            if (data == null) return;
            _handleRead(data).catchError((err) {
              debugPrint('RequestHandlerSocket. Error on _handleRead: $err');
            });
          case RawSocketEvent.write:
            _flushWriteQueue();
            if (isTargetSocketInit && targetSocket != null) {
              targetSocket!.onClientSocketReadyToWrite();
            }
          case RawSocketEvent.closed:
            debugPrint('RequestHandlerSocket. Connection closed');
          case RawSocketEvent.readClosed:
            debugPrint('RequestHandlerSocket. Socket is closed for reading.');
            if (!_isReusable) {
              _sourceSocket.close();
            }
        }
      },
      onError: (err) {
        debugPrint('RequestHandlerSocket. Error: $err');
        _sourceSocket.close();
      },
      onDone: () {
        sourceSocks5Handler?.close();
        emitter.emit('closed');
      },
    );
  }

  _reset() {
    if (isTargetSocketInit && targetSocket != null) {
      targetSocket!.isDead = true;
      targetSocket = null;
      isTargetSocketInit = false;
    }
    if (sourceSocks5Handler != null) {
      sourceSocks5Handler = null;
    }
    isTargetSocketInit = false;
    _flushWriteQueue();
    _markSocketAsFree();
  }

  _markSocketAsFree() {
    if (targetSocket == null) {
      _queueWrite(utf8.encode(peerSocketEvents['PeerSocketFree']!));
    }
  }

  void _queueWrite(Uint8List data) {
    _writeQueue.add(data);
    if (!_isWriting) {
      _flushWriteQueue();
    }
  }

  void _flushWriteQueue() {
    if (_isWriting || _writeQueue.isEmpty) return;

    _isWriting = true;
    _retryWriteTimer?.cancel();

    while (_writeQueue.isNotEmpty) {
      final data = _writeQueue.first;

      _logSocketData('SEND', 'ReqHandler-${_reqId}', data);

      if (getIsDebug) {
        debugPrint('writing to ReqHandlerSocket, data count ${data.length}');
      }

      try {
        final written = _sourceSocket.write(data);

        if (written == data.length) {
          _writeQueue.removeAt(0);
        } else if (written > 0) {
          _writeQueue[0] = data.sublist(written);
          _isWriting = false;
          _scheduleRetryWrite();
          return;
        } else {
          if (getIsDebug) {
            debugPrint(
                'ReqHandlerSocket buffer full, will retry. Queue size: ${_writeQueue.length}');
          }
          _isWriting = false;
          _scheduleRetryWrite();
          return;
        }
      } catch (e) {
        if (getIsDebug) {
          debugPrint('error writing to ReqHandlerSocket: $e');
        }
        _writeQueue.removeAt(0);
      }
    }

    _isWriting = false;
  }

  void _scheduleRetryWrite() {
    _retryWriteTimer?.cancel();
    _retryWriteTimer = Timer(const Duration(milliseconds: 50), () {
      if (_writeQueue.isNotEmpty && !_isWriting) {
        if (getIsDebug) {
          debugPrint(
              'Retrying write to ReqHandlerSocket. Queue size: ${_writeQueue.length}');
        }
        _flushWriteQueue();
      }
    });
  }

  void _logSocketData(String direction, String socketName, Uint8List data) {
    try {
      String textData;
      try {
        textData = String.fromCharCodes(data);
        textData = textData
            .replaceAll('\x00', '\\0')
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r')
            .replaceAll('\t', '\\t');

        if (textData.length > 200) {
          textData = textData.substring(0, 200) + '...';
        }
      } catch (e) {
        textData = '<binary data: ${data.length} bytes>';
      }

      print(
          '[GeoNode Status] $direction $socketName: "$textData" (${data.length} bytes)');
    } catch (e) {
      print(
          '[GeoNode Status] $direction $socketName: <error logging data> (${data.length} bytes)');
    }
  }

  close() {
    _retryWriteTimer?.cancel();
    _writeQueue.clear();
    _sourceSocket.close();
  }

  int writeToClient(Uint8List data) {
    _queueWrite(data);
    return data.length;
  }

  /// Logs the current connection status and checks if socket is still connected
  void logConnectionStatus() {
    try {
      bool isSocketAlive = _isSocketConnected();
      String timestamp = DateTime.now().toIso8601String();
      String status = isSocketAlive ? 'CONNECTED' : 'DISCONNECTED';
      String socketInfo = 'ReqID: $_reqId | PeerID: $_peerId | IP: $_ip:$_port';

      debugPrint(
          '[$timestamp] RequestHandlerSocket Status: $status | $socketInfo');
    } catch (e) {
      debugPrint('ReqHandler -> Error in connection monitoring: $e');
    }
  }

  /// Checks if the socket is still connected
  bool _isSocketConnected() {
    try {
      // Try to get socket properties - this will throw if socket is closed
      _sourceSocket.address;
      _sourceSocket.port;

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> httpProtocolHandler(data, buffer) async {
    var request = parseHttpRequest(data);
    if (request == null) return;
    try {
      targetSocket = TargetSocket(
        requestHandlerSocket: _sourceSocket,
        request: request,
        buffer: buffer,
      );

      targetSocket!.emitter.on(P2PEvents.onTargetWebsiteError, null, (e, o) {
        emitter.emit(P2PEvents.onTargetWebsiteError, null, o);
      });

      targetSocket!.emitter.on(P2PEvents.onTargetSocketEnd, null, (e, o) {
        _reset();
      });

      targetSocket!.emitter.on(P2PEvents.onRequestCalculateResponse, null,
          (e, o) {
        emitter.emit(P2PEvents.onRequestCalculateResponse, null, e.eventData);
      });

      await targetSocket!.connect();
      isTargetSocketInit = true;
    } catch (e) {
      debugPrint('ReqHandler -> error httpProtocolHandler : $e');
      return;
    }
  }

  Future<void> _handleRead(Uint8List data) async {
    _logSocketData('RECV', 'ReqHandler-${_reqId}', data);

    final request = String.fromCharCodes(data);
    bool isAuthPacket = request == peerSocketEvents['Authentication'];
    bool isRemoteSocketClosePacket =
        request == peerSocketEvents['RemoteSocketClosed'];

    if (isAuthPacket) {
      if (getIsDebug) {
        logPrint('RequestHandlerSocket -> Authentication');
      }
      _queueWrite(utf8.encode(
          'authentication $_peerId $_reqId ${_isReusable ? 1 : 0} $_standByMode'));
      return;
    } else if (isRemoteSocketClosePacket) {
      debugPrint('ReqHandler -> received RemoteSocketClosed');

      if (isTargetSocketInit && targetSocket?.targetSocket != null) {
        isRemoteSocketClosePacket = true;
        P2PHelper().closeSocket(targetSocket!.targetSocket, 'TargetSocket');
      }
      sourceSocks5Handler?.close();
      _reset();
      return;
    } else if (isTargetSocketInit && targetSocket?.targetSocket != null) {
      _logSocketData('SEND', 'ReqHandler-${_reqId}-Target', data);
      P2PHelper().writeToSocket(targetSocket!.targetSocket, data, 'Target');
      return;
    } else if (sourceSocks5Handler != null) {
      debugPrint('RequestHandlerSocket -> Socks5 request');
      sourceSocks5Handler!.handleData(data);
      return;
    }

    if (request.toString().startsWith('CONNECT') ||
        request.toString().contains('HTTP/1.1') ||
        request.toString().contains('HTTP/1.0') ||
        _httpFirstLineRegex.hasMatch(request.toString())) {
      debugPrint('ReqHandler -> HTTP request');
      return await httpProtocolHandler(request, data);
    } else if (data.length >= 10 &&
        data[0] == 5 &&
        data[1] == 1 &&
        data[2] == 0) {
      try {
        sourceSocks5Handler = Socks5Handler(_sourceSocket);
        await sourceSocks5Handler?.handle(data);
      } catch (e) {
        debugPrint('ReqHandler -> error creating socks5targetSocket : $e');
      }
    }
  }

  Map<String, dynamic> parseHttpVer10(String data) {
    List<String> splitted = data.split(' ');

    return {
      'method': splitted[0],
      'path': splitted[1].split(':')[0],
      'httpVersion': splitted[2].split('\r')[0],
      'host': splitted[1].split(':')[0],
      'port': splitted[1].split(':')[1],
    };
  }

  static final _httpFirstLineRegex = RegExp(
    r'^(GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|PATCH|CONNECT)\s+(https?:\/\/)?(?:\[((?:[0-9a-fA-F:]+))\]|([\w\.-]+))(?::(\d+))?(\/\S*)?\s+HTTP\/1\.[01]$',
  );

  Map<String, dynamic>? parseHttpRequest(String data) {
    try {
      String? host, port, path, method, httpVersion;
      final List<String> splitted = data.split('\r\n');

      for (var line in splitted) {
        final match = _httpFirstLineRegex.firstMatch(line);
        if (match != null) {
          host = match.group(3) ?? match.group(4);
          method = match.group(1)!;
          port = match.group(5) ?? (match.group(2) == 'http://' ? '80' : '443');
          path = match.group(6) ?? '/';
          break;
        }
      }

      final List<String> firstLine = splitted[0].trim().split(' ');
      method ??= firstLine[0];
      path ??= firstLine[1];
      httpVersion = firstLine[2];

      if (host == null || port == null) {
        return parseHttpRequestByHeaders(data);
      }

      return {
        'method': method,
        'path': path,
        'httpVersion': httpVersion,
        'host': host,
        'port': port.toString(),
      };
    } catch (e) {
      debugPrint('ReqHandler -> e parseHttpRequest: $e');
      return null;
    }
  }

  Map<String, dynamic>? parseHttpRequestByHeaders(String data) {
    try {
      if (data.contains('HTTP/1.0')) {
        return parseHttpVer10(data);
      }

      String getPort(String hostHeader) {
        int? port;
        var parts = hostHeader.split(':');
        if (parts.length > 2) {
          port = int.tryParse(parts[2].trim());
        }
        return (port ?? 80).toString();
      }

      int getHostIndex(List<String> splitted) {
        return splitted.indexWhere((l) =>
            l.toLowerCase().contains('host:') &&
            l.toLowerCase().startsWith('host: '));
      }

      List<String> splitted = data.split('\r\n');
      List<String> firstLine = splitted[0].trim().split(' ');
      String method = firstLine[0];
      String path = firstLine[1];
      String httpVersion = firstLine[2];
      int index = getHostIndex(splitted);
      String host = splitted[index].split(':')[1].trim();
      String port = getPort(splitted[index]);

      return {
        'method': method,
        'path': path,
        'httpVersion': httpVersion,
        'host': host,
        'port': port,
      };
    } catch (e) {
      debugPrint('ReqHandler -> e parseHttpRequest: $e');
      return null;
    }
  }
}
