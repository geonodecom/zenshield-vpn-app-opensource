import 'dart:ui';

sealed class AppSideEffect {
  const AppSideEffect();
}

class ShowSystemExtensionErrorDialog extends AppSideEffect {
  const ShowSystemExtensionErrorDialog({
    required this.message,
    this.errorType,
  });

  final String message;
  final String? errorType;
}

class ShowVpnErrorDialog extends AppSideEffect {
  const ShowVpnErrorDialog({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}

class ShowAutoSelectEnabledToast extends AppSideEffect {
  const ShowAutoSelectEnabledToast();
}

class PromptBatteryOptimizations extends AppSideEffect {
  const PromptBatteryOptimizations({
    required this.onAgreed,
    required this.onSkipped,
  });

  final VoidCallback onAgreed;
  final VoidCallback onSkipped;
}
