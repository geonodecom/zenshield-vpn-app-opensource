import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_view_args.freezed.dart';

@freezed
class FeedbackViewArgs with _$FeedbackViewArgs {
  const factory FeedbackViewArgs({
    @Default(false) bool isFromError,
    @Default('') String previousRouteName,
  }) = _FeedbackViewArgs;
}
