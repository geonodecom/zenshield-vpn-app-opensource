import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';

sealed class SplashSideEffect {
  const SplashSideEffect();
}

class NavigateToHome extends SplashSideEffect {}

class NavigateToOnboarding extends SplashSideEffect {
  NavigateToOnboarding({required this.agreementsResponse});
  final AgreementsResponse agreementsResponse;
}

class NavigateToAppUpdate extends SplashSideEffect {
  const NavigateToAppUpdate();
}

class NavigateToGeonodeKeySetup extends SplashSideEffect {
  const NavigateToGeonodeKeySetup();
}

class NavigateToAuth extends SplashSideEffect {}

class ShowErrorDialog extends SplashSideEffect {
  const ShowErrorDialog();
}
