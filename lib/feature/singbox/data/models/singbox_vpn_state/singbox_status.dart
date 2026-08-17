import 'package:freezed_annotation/freezed_annotation.dart';

part 'singbox_status.freezed.dart';

@freezed
sealed class SingboxStatus with _$SingboxStatus {
  const SingboxStatus._();

  const factory SingboxStatus.starting() = SingboxStarting;
  const factory SingboxStatus.started() = SingboxStarted;
  const factory SingboxStatus.stopping() = SingboxStopping;
  const factory SingboxStatus.stopped() = SingboxStopped;

  factory SingboxStatus.fromEvent(dynamic event) {
    switch (event) {
      case 'Disconnected':
        return const SingboxStatus.stopped();
      case 'Connecting':
        return const SingboxStatus.starting();
      case 'Connected':
        return const SingboxStatus.started();
      case 'Disconnecting':
        return const SingboxStatus.stopping();
      default:
        throw Exception('unexpected status [$event]');
    }
  }

  String toEvent() {
    return switch (this) {
      SingboxStarting() => 'Connecting',
      SingboxStarted() => 'Connected',
      SingboxStopping() => 'Disconnecting',
      SingboxStopped() => 'Disconnected',
    };
  }
}
