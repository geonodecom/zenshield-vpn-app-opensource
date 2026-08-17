import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:zenshield/feature/singbox/data/command_client/message_buffer.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class AbstractSocketService {
  bool get isConnected;

  Future<void> connectIfNeeded(
    SocketType socketType, {
    int maxAttempts = 1,
  });

  void closeSocket();

  void sendCommand(int commandByte);

  void sendData(Uint8List data);

  StreamSubscription<Uint8List> listenForData(
    void Function(Uint8List) onData, {
    Function? onError,
    void Function()? onDone,
  });
}

// ignore: unused-code
@Injectable(as: AbstractSocketService)
class SocketService implements AbstractSocketService {
  SocketService(this._logger, this._messageBuffer);

  final Talker _logger;
  final _dataController = StreamController<Uint8List>.broadcast();
  final MessageBuffer _messageBuffer;
  Socket? _socket;
  StreamSubscription<Uint8List>? _socketDataSubscription;

  @override
  bool get isConnected => _socket != null;

  @override
  Future<void> connectIfNeeded(
    SocketType socketType, {
    int maxAttempts = 1,
  }) async {
    if (_socket != null) {
      return;
    }

    await _createSocket(socketType, maxAttempts: maxAttempts);
  }

  Future<void> _createSocket(
    SocketType socketType, {
    int maxAttempts = 1,
  }) async {
    Exception? lastException;
    const retryDelay = Duration(milliseconds: 100);

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        Socket socket;

        switch (socketType) {
          case UnixSocketType():
            final socketFile = File(socketType.path);
            // ignore: avoid_slow_async_io
            final isSocketFileExists = await socketFile.exists();
            if (!isSocketFileExists) {
              throw Exception('Socket file does not exist: ${socketType.path}');
            }

            final host = InternetAddress(
              socketType.path,
              type: InternetAddressType.unix,
            );
            socket = await Socket.connect(host, 0);
            _logger.info('Connected to Unix socket: ${socketType.path}');

          case TcpSocketType():
            socket = await Socket.connect(socketType.host, socketType.port);
            _logger.info(
              'Connected to TCP socket: ${socketType.host}:${socketType.port}',
            );
        }

        _socket = socket;
        _setupSocketListener(socket);
        return;
      } catch (e) {
        lastException = Exception('Connection error on attempt $attempt: $e');
        _logger.warning('Socket connection attempt $attempt failed: $e');

        if (attempt == maxAttempts) break;

        await Future<void>.delayed(retryDelay);
      }
    }

    throw lastException ??
        Exception(
          'Failed to connect after $maxAttempts attempts',
        );
  }

  void _setupSocketListener(Socket socket) {
    _socketDataSubscription ??= socket.listen(
      _handleRawData,
      onError: (Object e) {
        _logger.error('Socket error: $e');
        _dataController.addError(e);
      },
      onDone: closeSocket,
    );
  }

  void _handleRawData(Uint8List data) {
    try {
      _messageBuffer.addData(data, _dataController.add);
    } catch (e) {
      _logger.error('Error processing socket data: $e');
      _dataController.addError(e);
    }
  }

  @override
  void closeSocket() {
    if (_socket != null) {
      try {
        _socketDataSubscription?.cancel();
        _socketDataSubscription = null;
        _socket!.destroy();
        _socket = null;
        _messageBuffer.clear();
        _logger.info('Socket connection closed');
      } catch (e) {
        _logger.error('Error closing socket: $e');
      }
    }
  }

  @override
  void sendCommand(int commandByte) {
    if (_socket == null) {
      throw Exception('Cannot send data: socket is not connected');
    }

    try {
      final data = [commandByte];
      _socket!.add(data);
    } catch (e) {
      _logger.error('Error sending data through socket: $e');
      throw Exception('Failed to send data: $e');
    }
  }

  @override
  void sendData(Uint8List data) {
    if (_socket == null) {
      throw Exception('Cannot send data: socket is not connected');
    }

    try {
      _socket!.add(data);
    } catch (e) {
      _logger.error('Error sending data through socket: $e');
      throw Exception('Failed to send data: $e');
    }
  }

  @override
  StreamSubscription<Uint8List> listenForData(
    void Function(Uint8List) onData, {
    Function? onError,
    void Function()? onDone,
  }) {
    return _dataController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }
}
