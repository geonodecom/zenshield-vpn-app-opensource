import 'dart:async';

import 'package:zenshield/feature/singbox/data/command_client/base_command_client.dart';

class StreamCommandClient<T> extends BaseCommandClient<T> {
  StreamCommandClient({
    required super.commandType,
    required super.logger,
    required super.socketType,
  });

  Stream<T> get stream => eventController.stream;

  void addCustomEvent(T event) {
    eventController.add(event);
  }

  @override
  void init() {
    subscription ??= socketService.listenForData(
      (data) {
        try {
          final result = parseMessage(data);
          eventController.add(result);
        } catch (e, stack) {
          logger.error('Error parsing message', e, stack);
        }
      },
      onError: (Object error, StackTrace? stackTrace) {
        logger.error('Stream error', error, stackTrace);
        eventController.addError(error, stackTrace);
      },
      onDone: () {
        logger.info('Socket data stream closed');
      },
    );
  }
}
