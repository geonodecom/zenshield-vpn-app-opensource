import 'package:freezed_annotation/freezed_annotation.dart';

part 'paywall_args.freezed.dart';

@freezed
class PaywallArgs with _$PaywallArgs {
  const factory PaywallArgs({
    required bool redirectToHomeOnClose,
  }) = _PaywallArgs;
}
