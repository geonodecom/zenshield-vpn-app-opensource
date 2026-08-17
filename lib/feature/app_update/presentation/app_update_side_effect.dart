sealed class AppUpdateSideEffect {
  const AppUpdateSideEffect();
}

class NavigateToSplash extends AppUpdateSideEffect {
  const NavigateToSplash();
}

class NavigateToHome extends AppUpdateSideEffect {
  const NavigateToHome();
}

class NavigateToAuth extends AppUpdateSideEffect {
  const NavigateToAuth();
}

class NavigateToOnboarding extends AppUpdateSideEffect {
  const NavigateToOnboarding();
}
