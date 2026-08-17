import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/singbox/data/command_client/command_type.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_service.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_status/status_message.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class BaseCommandClient<T> {
  BaseCommandClient({
    required this.commandType,
    required this.logger,
    required this.socketType,
  }) {
    eventController = StreamController<T>.broadcast();
  }

  late final StreamController<T> eventController;
  // ignore: cancel_subscriptions
  StreamSubscription<Uint8List>? subscription;
  final AbstractSocketService socketService = getIt();
  final CommandType commandType;
  final Talker logger;
  final SocketType socketType;

  void init();

  Future<void> launch({String? arg}) async {
    try {
      if (!socketService.isConnected) {
        await socketService.connectIfNeeded(socketType);
      }
      socketService.sendCommand(commandType.value);

      if (commandType == CommandType.ping && arg != null) {
        final data = utf8.encode(arg);
        final length = data.length;

        final lengthBytes = Uint8List(4);
        ByteData.view(lengthBytes.buffer).setUint32(0, length, Endian.big);
        socketService
          ..sendData(lengthBytes)
          ..sendData(data);
      }
    } catch (e) {
      logger.warning('Error launching command client', e);
    }
  }

  T parseMessage(Uint8List message) {
    try {
      switch (commandType) {
        case CommandType.log:
          return _parseLogMessage(message);
        case CommandType.status:
          return _parseStatusMessage(message);
        case CommandType.vpnState:
          return _parseVpnStateMessage(message);
        case CommandType.ping:
          return _parsePingMessage(message);
      }
    } catch (e) {
      logger.error(
        'Error parsing message for command type ${commandType.value}',
        e,
      );
      rethrow;
    }
  }

  T _parseLogMessage(Uint8List message) {
    try {
      final jsonString = utf8.decode(message);
      logger.debug('Received logs JSON from core');

      final jsonArray = json.decode(jsonString) as List<dynamic>;
      return jsonArray.map((e) => e as String).toList() as T;
    } catch (e) {
      logger.error('Error parsing log message', e);
      rethrow;
    }
  }

  T _parseStatusMessage(Uint8List message) {
    try {
      final jsonString = utf8.decode(message);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return StatusMessage.fromJson(jsonMap) as T;
    } catch (e) {
      logger.error('Error parsing status message', e);
      rethrow;
    }
  }

  T _parseVpnStateMessage(Uint8List message) {
    try {
      return utf8.decode(message) as T;
    } catch (e) {
      logger.error('[VPN] Error parsing VPN state message', e);
      rethrow;
    }
  }

  T _parsePingMessage(Uint8List message) {
    try {
      return utf8.decode(message) as T;
    } catch (e) {
      logger.error('Error parsing ping message', e);
      rethrow;
    }
  }

  void stop() {
    try {
      socketService.closeSocket();
    } catch (e) {
      logger.error('Error stopping command client', e);
    }
  }
}
