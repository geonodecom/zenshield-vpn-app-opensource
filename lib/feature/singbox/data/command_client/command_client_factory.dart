import 'package:injectable/injectable.dart';
import 'package:zenshield/feature/singbox/data/command_client/command_type.dart';
import 'package:zenshield/feature/singbox/data/command_client/one_time_command_client.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:zenshield/feature/singbox/data/command_client/stream_command_client.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_status/status_message.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class AbstractCommandClientFactory {
  StreamCommandClient<List<String>> createLogsStream({
    required SocketType socketType,
  });

  StreamCommandClient<StatusMessage> createStatusStream({
    required SocketType socketType,
  });

  StreamCommandClient<String> createVpnStateStream({
    required SocketType socketType,
  });

  OneTimeCommandClient<List<String>> createLogsOneTime({
    required SocketType socketType,
  });

  Future<List<String>> getLogs({
    required SocketType socketType,
  });

  OneTimeCommandClient<String> createPingOneTime({
    required SocketType socketType,
  });

  Future<String> getPing({
    required SocketType socketType,
    required String arg,
  });
}

// ignore: unused-code
@Injectable(as: AbstractCommandClientFactory)
class CommandClientFactory implements AbstractCommandClientFactory {
  CommandClientFactory({
    required Talker logger,
  }) : _logger = logger;

  final Talker _logger;

  @override
  StreamCommandClient<List<String>> createLogsStream({
    required SocketType socketType,
  }) {
    return StreamCommandClient<List<String>>(
      commandType: CommandType.log,
      logger: _logger,
      socketType: socketType,
    );
  }

  @override
  StreamCommandClient<StatusMessage> createStatusStream({
    required SocketType socketType,
  }) {
    return StreamCommandClient<StatusMessage>(
      commandType: CommandType.status,
      logger: _logger,
      socketType: socketType,
    );
  }

  @override
  StreamCommandClient<String> createVpnStateStream({
    required SocketType socketType,
  }) {
    return StreamCommandClient<String>(
      commandType: CommandType.vpnState,
      logger: _logger,
      socketType: socketType,
    );
  }

  @override
  OneTimeCommandClient<List<String>> createLogsOneTime({
    required SocketType socketType,
  }) {
    return OneTimeCommandClient<List<String>>(
      commandType: CommandType.log,
      logger: _logger,
      socketType: socketType,
    );
  }

  @override
  Future<List<String>> getLogs({
    required SocketType socketType,
  }) async {
    final client = createLogsOneTime(
      socketType: socketType,
    );
    try {
      client.init();
      await client.launch();
      return await client.result;
    } finally {}
  }

  @override
  OneTimeCommandClient<String> createPingOneTime({
    required SocketType socketType,
  }) {
    return OneTimeCommandClient<String>(
      commandType: CommandType.ping,
      logger: _logger,
      socketType: socketType,
    );
  }

  @override
  Future<String> getPing({
    required SocketType socketType,
    required String arg,
  }) async {
    final client = createPingOneTime(
      socketType: socketType,
    );
    try {
      client.init();
      await client.launch(arg: arg);
      return await client.result;
    } finally {}
  }
}
