sealed class AboutSideEffect {}

class ShowBandwidthSharingPolicyPage extends AboutSideEffect {
  ShowBandwidthSharingPolicyPage({this.htmlContent, this.fallbackUrl});

  final String? htmlContent;
  final Uri? fallbackUrl;
}

class NavigateToLogsSideEffect extends AboutSideEffect {
  NavigateToLogsSideEffect();
}
