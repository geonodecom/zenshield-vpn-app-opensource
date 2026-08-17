// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingPage1Title => 'A Free VPN Built on Trust';

  @override
  String get onboardingPage1Text =>
      'Zenshield protects your privacy and stays free by securely sharing a small portion of unused bandwidth, never your personal data.';

  @override
  String get onboardingPage1TextIos =>
      'Zenshield protects your privacy and keeps your online activity private. No subscription required.';

  @override
  String get onboardingPage2Title => 'Privacy and Transparency';

  @override
  String onboardingPage2Text(String eula, String privacyPolicy) {
    return 'Before continuing, please review and agree to our $eula, $privacyPolicy. Zenshield collects limited account information, such as your email address, to provide and secure the service.';
  }

  @override
  String get onboardingPage2Eula => 'End User License Agreement (EULA)';

  @override
  String get onboardingPage2PrivacyPolicy => 'Privacy Policy';

  @override
  String get onboardingPage2BandwidthSharingPolicy =>
      'Bandwidth Sharing Policy';

  @override
  String onboardingPage2TextAndroid(
    String eula,
    String privacyPolicy,
    String bandwidthSharingPolicy,
  ) {
    return 'Before continuing, please review and agree to our $eula, $privacyPolicy and $bandwidthSharingPolicy. Zenshield collects limited account information, such as your email address, to provide and secure the service.';
  }

  @override
  String get onboardingPage3Title => 'Why Zenshield is Free';

  @override
  String get onboardingPage3Text =>
      'Zenshield stays free because users share a small, encrypted portion of their unused internet connection. This shared bandwidth helps trusted businesses perform legitimate online tasks such as web indexing and data verification.\n\nYour personal data and browsing activity are never collected or exposed';

  @override
  String get onboardingPage3BandwidthSharing => 'Bandwidth Sharing Policy';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get buttonAgreeAndContinue => 'Agree & Continue';

  @override
  String get buttonIDisagree => 'I Disagree';

  @override
  String get bandwidthSharingModalTitle => 'Help Keep Zenshield Free';

  @override
  String get bandwidthSharingModalText1 =>
      'Bandwidth sharing is optional. You can use Zenshield without it — you can turn it on or off any time.';

  @override
  String get bandwidthSharingModalText2 =>
      'Zenshield stays free because users share a small, encrypted portion of their unused internet connection.';

  @override
  String get bandwidthSharingModalText3 =>
      'This shared bandwidth helps trusted businesses perform legitimate online tasks such as web indexing and data verification.';

  @override
  String get bandwidthSharingModalText4 =>
      'Your personal data and browsing activity are never collected or exposed. Learn more in our';

  @override
  String get bandwidthSharingModalButtonAgree => 'I Agree';

  @override
  String get bandwidthSharingModalButtonSubtext =>
      'Allow app to use idle resources for network boost';

  @override
  String get bandwidthSharingModalButtonNotNow => 'Not now';

  @override
  String get emailHint => 'Enter your Gmail';

  @override
  String get buttonLogin => 'Login';

  @override
  String get buttonSignUp => 'Sign Up';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Sign in to continue to Zenshield';

  @override
  String get authSignUpTitle => 'Create your account';

  @override
  String get authSignUpSubtitle => 'Sign up to get started with Zenshield';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get authHaveAccountPrompt => 'Already have an account? ';

  @override
  String get emailAddressLabel => 'Gmail';

  @override
  String get passwordHintEnter => 'Enter your password';

  @override
  String get passwordHintCreate => 'Create your password';

  @override
  String get passwordLabel => 'Password';

  @override
  String get authPasswordOnlyLatinHint =>
      'Only Latin characters (A-Z, a-z, 0-9, and special characters)';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get termsAgreement =>
      'I agree to the End User License Agreement (EULA), Privacy Policy and Bandwidth Sharing Policy.';

  @override
  String get termsAgreementIos =>
      'I agree to the End User License Agreement (EULA),\nPrivacy Policy.';

  @override
  String get orContinueWith => 'Or continue with:';

  @override
  String get checkInboxTitle => 'Check your inbox';

  @override
  String checkInboxMessage(String email) {
    return 'We\'ve sent a confirmation link to $email';
  }

  @override
  String get checkInboxSubtext =>
      'Please verify your email to continue using Zenshield.';

  @override
  String get buttonOpenEmailApp => 'Open email app';

  @override
  String get checkInboxErrorUnableToOpenEmailApp => 'Unable to open email app';

  @override
  String get checkInboxErrorSessionDataMissing =>
      'Session data is missing. Please register again.';

  @override
  String get checkInboxErrorUnknownAction => 'Unknown action in deep link';

  @override
  String get checkInboxErrorMissingCodeParameter =>
      'Missing code parameter in deep link';

  @override
  String get checkInboxErrorVerificationFailed =>
      'Verification failed. Please try again.';

  @override
  String get homeTapAndHoldToDisconnect => 'Tap and hold to\ndisconnect';

  @override
  String get homePause => 'Disconnect';

  @override
  String get homeDisconnectConfirmTitle => 'Turn off VPN?';

  @override
  String get homeDisconnectConfirmMessage =>
      'You\'ll lose protection and your traffic won\'t be secured until you reconnect.';

  @override
  String get homeDisconnectConfirmKeepVpn => 'Keep VPN on';

  @override
  String get homeDisconnectConfirmTurnOff => 'Turn off';

  @override
  String get homeConnect => 'Connect';

  @override
  String get homeZenSdkIsActive => 'ZenSDK is active';

  @override
  String get homeZenSdkIsDisabled => 'ZenSDK is disabled';

  @override
  String get homeConnected => 'Connected';

  @override
  String get homeConnectionFailed => 'Not Connected — Connection failed';

  @override
  String get homeConnectionIssue => 'Connection issue';

  @override
  String get homeConnecting => 'Connecting';

  @override
  String get homeDisconnecting => 'Disconnecting';

  @override
  String get homeNotConnected => 'Not connected';

  @override
  String get serversSearchLocation => 'Search location';

  @override
  String get serversAutoSelect => 'Auto select';

  @override
  String get serversAutoSelectEnabled => 'Auto select enabled';

  @override
  String get serversAutoSelectSubtitle => 'Best available server';

  @override
  String get serversAutoSelectFinding => 'Finding best server...';

  @override
  String get serversAutoSelectUnavailable => 'Server unavailable';

  @override
  String get serversClose => 'Close';

  @override
  String get protocolsSearchProtocol => 'Search Protocol';

  @override
  String get protocolsClose => 'Close';

  @override
  String get protocolsRecommended => '(Recommended)';

  @override
  String settingsSecuredSince(String date) {
    return 'Secured since $date';
  }

  @override
  String get settingsMain => 'Main';

  @override
  String get settingsZenSDK => 'ZenSDK';

  @override
  String get settingsZenSDKDescription => 'Allow secure resource sharing';

  @override
  String get settingsVPNProtocolSelection => 'VPN Protocol Selection';

  @override
  String get settingsVPNProtocolAutomatic => 'Automatic';

  @override
  String get settingsLaunchOnStartup => 'Launch on startup';

  @override
  String get settingsLaunchOnStartupDescription => '';

  @override
  String get settingsLaunchOnStartupFailed =>
      'Failed to activate, please try again';

  @override
  String get settingsSocialMedia => 'Zensheild on social media';

  @override
  String get settingsLogOut => 'Log out';

  @override
  String get aboutTitle => 'About Zenshield';

  @override
  String get aboutWhatIsZenshield => 'What is Zenshield?';

  @override
  String get aboutWhatIsZenshieldDescription =>
      'Zenshield is a free VPN that lets you access geo-restricted content, browse securely on public Wi-Fi, and keep your online activity private. No subscription required.';

  @override
  String get aboutBandwidthSharingTitle => 'Bandwidth Sharing Policy';

  @override
  String get aboutBandwidthSharingDescription =>
      'Zenshield is free because users contribute a small slice of their unused internet bandwidth to the Geonode data network. Your data is never accessed. Only network traffic is routed through your device.';

  @override
  String get aboutLegalAndSupportTitle => 'Legal Policies';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutTermsOfService => 'Terms of Service';

  @override
  String get aboutSupportCenter => 'Support Center';

  @override
  String get aboutBandwidthSharingPolicy => 'Bandwidth Sharing Policy';

  @override
  String get aboutEndUserLicenseAgreement => 'End User License Agreement';

  @override
  String get aboutTroubleshootingTitle => 'Troubleshooting & Feedback';

  @override
  String get aboutEmailCopiedTitle => 'Copied';

  @override
  String get aboutEmailCopiedToClipboard => 'Email address copied to clipboard';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordDescription =>
      'Create your new password for Zenshield VPN and type new password twice.';

  @override
  String get changePasswordNewPasswordLabel => 'New Password';

  @override
  String get changePasswordNewPasswordHint => 'Create your new password';

  @override
  String get changePasswordConfirmPasswordLabel => 'Confirm New Password';

  @override
  String get changePasswordConfirmPasswordHint => 'Confirm your new password';

  @override
  String get changePasswordButton => 'Continue';

  @override
  String get changePasswordPasswordsDontMatch => 'These passwords don\'t match';

  @override
  String get changePasswordSuccess => 'Password changed successfully';

  @override
  String get changePasswordError => 'Failed to change password';

  @override
  String get changePasswordSuccessTitle => 'All set!';

  @override
  String get changePasswordSuccessMessage => 'Your password is now updated';

  @override
  String get changePasswordSuccessButton => 'Got it';

  @override
  String get rateAppPopupTitle => 'Feeling safer with Zenshield?';

  @override
  String get rateAppPopupSubtitle =>
      'Your review helps others stay safe online.';

  @override
  String get rateAppPopupFeedbackPrefix => 'Got feedback? ';

  @override
  String get rateAppPopupFeedbackLink => 'Tap here';

  @override
  String get rateAppPopupFeedbackSuffix => ' to tell us directly.';

  @override
  String get updateRequiredPopupTitle => 'Update Required';

  @override
  String get updateRequiredPopupMessage1 =>
      'Your current version of Zenshield VPN is\nout of date.';

  @override
  String get updateRequiredPopupMessage2 =>
      'Please install the latest version to\ncontinue using the app securely and\nwithout interruptions.';

  @override
  String get updateRequiredPopupButtonDownload => 'Download Update';

  @override
  String get updateRequiredPopupButtonRemindLater => 'Remind Me Later';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDescription =>
      'Enter your e-mail and we will send you magic link for verification.';

  @override
  String get resetPasswordEmailDoesntExist => 'E-Mail doesn\'t exist';

  @override
  String get resetPasswordEmailNotRegisteredTitle => 'Email Not Found';

  @override
  String get resetPasswordEmailNotRegisteredText =>
      'The email address you entered is not registered or not confirmed. Please check your email and try again.';

  @override
  String get loginFailedTitle => 'Login Failed';

  @override
  String get loginErrorText =>
      'Unable to sign in. Please check your internet connection and try again.';

  @override
  String get signUpFailedTitle => 'Sign up Failed';

  @override
  String get signUpErrorText =>
      'Unable to sign up. Please check your internet connection and try again.';

  @override
  String get authenticationFailedTitle => 'Authentication Failed';

  @override
  String get wrongCredentialsText =>
      'The email or password you entered is incorrect. Please try again.';

  @override
  String get invalidPasswordTitle => 'Invalid Password';

  @override
  String get invalidPasswordText =>
      'Password must meet the following requirements:\n\n• At least 8 characters long\n• Only Latin characters (A-Z, a-z, 0-9, and special characters)';

  @override
  String get invalidEmailTitle => 'Invalid Email';

  @override
  String get invalidEmailText => 'Please enter a valid email address.';

  @override
  String get emailEmploymentErrorTitle => 'Email Employment Error';

  @override
  String get emailEmploymentErrorText =>
      'The email you entered is already in use. Please try again.';

  @override
  String get appUpdateChecking => 'Checking for updates…';

  @override
  String get appUpdateDownloading => 'Downloading update';

  @override
  String get appUpdateInstalling => 'Installing';

  @override
  String get appUpdateRestarting => 'Restarting Zenshield';

  @override
  String get appUpdateError => 'Couldn\'t update right now';

  @override
  String get appUpdateRetry => 'Retry';

  @override
  String get appUpdateOpenAppAnyway => 'Open app anyway';

  @override
  String get updateAvailablePopupTitle => 'Update available';

  @override
  String get updateAvailablePopupMessage => 'A new version is available';

  @override
  String get updateAvailablePopupButtonUpdate => 'Update now';

  @override
  String get updateAvailablePopupButtonRemindLater => 'Remind me later';

  @override
  String updateAvailablePopupTimer(String time) {
    return 'Restarting in $time';
  }

  @override
  String homeAppWasUpdated(String version) {
    return 'App was updated to version $version';
  }

  @override
  String get appTitle => 'Zenshield';

  @override
  String get close_dialog_title => 'Close Zenshield?';

  @override
  String get close_dialog_message =>
      'You are currently connected to VPN. Do you want to disconnect and close the app?';

  @override
  String get close_dialog_positive_button => 'Disconnect & Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get splash_error_title => 'Error';

  @override
  String get splash_error_text =>
      'An error occurred while initializing the app. Please try again or contact support.';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get deepLinkErrorTitle => 'Verification Error';

  @override
  String get deepLinkErrorWrongAction => 'Wrong action in deep link';

  @override
  String get ok => 'OK';

  @override
  String get emailNotConfirmedOrRegisteredErrorTitle =>
      'Email Not Confirmed or Registered';

  @override
  String get emailNotConfirmedOrRegisteredErrorText =>
      'The email is not confirmed or registered. Please check your email or sign up.';

  @override
  String get resetPasswordErrorTitle => 'Error';

  @override
  String get resetPasswordErrorText => 'An error occurred. Please try again.';

  @override
  String get registrationErrorTitle => 'Error';

  @override
  String get registrationErrorText =>
      'The email you entered is already in use. Please try again.';

  @override
  String get systemExtensionErrorTitle => 'System Extension Required';

  @override
  String get systemExtensionMessageSequoiaAndLater =>
      'Go to System Settings and open the General tab. In the Login Items & Extensions section, scroll down to Network Extensions and select the\nⓘ icon. Turn on Zenshield Network Extension.';

  @override
  String get systemExtensionMessageSonomaAndEarlier =>
      'Go to System Settings and open the Privacy & Security tab. Scroll down until you see \"System software from application Zenshield was blocked from loading\" and select Allow.';
}
