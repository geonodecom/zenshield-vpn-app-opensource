import 'dart:async';

import 'package:zenshield/feature/singbox/data/command_client/base_command_client.dart';

class OneTimeCommandClient<T> extends BaseCommandClient<T> {
  OneTimeCommandClient({
    required super.commandType,
    required super.logger,
    required super.socketType,
  }) {
    _completer = Completer<T>();
  }

  late final Completer<T> _completer;

  Future<T> get result => _completer.future;

  @override
  void init() {
    subscription = socketService.listenForData(
      (data) {
        try {
          final result = parseMessage(data);
          _completer.complete(result);
          subscription?.cancel();
          subscription = null;
        } catch (e, stack) {
          logger.error('Error parsing message', e, stack);
          _completer.completeError(e, stack);
          subscription?.cancel();
          subscription = null;
        }
      },
      onError: (Object error, StackTrace? stackTrace) {
        logger.error('Stream error', error, stackTrace);
        if (!_completer.isCompleted) {
          _completer.completeError(error, stackTrace);
        }
        subscription?.cancel();
        subscription = null;
      },
      onDone: () {
        if (!_completer.isCompleted) {
          _completer.completeError(
            Exception(
              'Stream closed before receiving result',
            ),
          );
        }
        subscription?.cancel();
        subscription = null;
      },
    );
  }
}
