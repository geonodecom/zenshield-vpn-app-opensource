import 'package:freezed_annotation/freezed_annotation.dart';
part 'about_state.freezed.dart';

@freezed
class AboutState with _$AboutState {
  const factory AboutState({
    required String appVersion,
    @Default(0) int versionTapCount,
  }) = _AboutState;

  factory AboutState.initial() => const AboutState(
    appVersion: '1.0.0.',
    versionTapCount: 0,
  );
}
