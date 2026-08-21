import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Gmail'**
  String get emailHint;

  /// No description provided for @buttonLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get buttonLogin;

  /// No description provided for @buttonSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get buttonSignUp;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to Zenshield'**
  String get authLoginSubtitle;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started with Zenshield'**
  String get authSignUpSubtitle;

  /// No description provided for @authNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccountPrompt;

  /// No description provided for @authHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccountPrompt;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get emailAddressLabel;

  /// No description provided for @passwordHintEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHintEnter;

  /// No description provided for @passwordHintCreate.
  ///
  /// In en, this message translates to:
  /// **'Create your password'**
  String get passwordHintCreate;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @authPasswordOnlyLatinHint.
  ///
  /// In en, this message translates to:
  /// **'Only Latin characters (A-Z, a-z, 0-9, and special characters)'**
  String get authPasswordOnlyLatinHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'I agree to the End User License Agreement (EULA), Privacy Policy.'**
  String get termsAgreement;

  /// No description provided for @termsAgreementIos.
  ///
  /// In en, this message translates to:
  /// **'I agree to the End User License Agreement (EULA),\nPrivacy Policy.'**
  String get termsAgreementIos;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with:'**
  String get orContinueWith;

  /// No description provided for @checkInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkInboxTitle;

  /// No description provided for @checkInboxMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation link to {email}'**
  String checkInboxMessage(String email);

  /// No description provided for @checkInboxSubtext.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email to continue using Zenshield.'**
  String get checkInboxSubtext;

  /// No description provided for @buttonOpenEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open email app'**
  String get buttonOpenEmailApp;

  /// No description provided for @checkInboxErrorUnableToOpenEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email app'**
  String get checkInboxErrorUnableToOpenEmailApp;

  /// No description provided for @checkInboxErrorSessionDataMissing.
  ///
  /// In en, this message translates to:
  /// **'Session data is missing. Please register again.'**
  String get checkInboxErrorSessionDataMissing;

  /// No description provided for @checkInboxErrorUnknownAction.
  ///
  /// In en, this message translates to:
  /// **'Unknown action in deep link'**
  String get checkInboxErrorUnknownAction;

  /// No description provided for @checkInboxErrorMissingCodeParameter.
  ///
  /// In en, this message translates to:
  /// **'Missing code parameter in deep link'**
  String get checkInboxErrorMissingCodeParameter;

  /// No description provided for @checkInboxErrorVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed. Please try again.'**
  String get checkInboxErrorVerificationFailed;

  /// No description provided for @homeTapAndHoldToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Tap and hold to\ndisconnect'**
  String get homeTapAndHoldToDisconnect;

  /// No description provided for @homePause.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get homePause;

  /// No description provided for @homeDisconnectConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off VPN?'**
  String get homeDisconnectConfirmTitle;

  /// No description provided for @homeDisconnectConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose protection and your traffic won\'t be secured until you reconnect.'**
  String get homeDisconnectConfirmMessage;

  /// No description provided for @homeDisconnectConfirmKeepVpn.
  ///
  /// In en, this message translates to:
  /// **'Keep VPN on'**
  String get homeDisconnectConfirmKeepVpn;

  /// No description provided for @homeDisconnectConfirmTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get homeDisconnectConfirmTurnOff;

  /// No description provided for @homeConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get homeConnect;

  /// No description provided for @homeConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get homeConnected;

  /// No description provided for @homeConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Not Connected — Connection failed'**
  String get homeConnectionFailed;

  /// No description provided for @homeConnectionIssue.
  ///
  /// In en, this message translates to:
  /// **'Connection issue'**
  String get homeConnectionIssue;

  /// No description provided for @homeConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get homeConnecting;

  /// No description provided for @homeDisconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting'**
  String get homeDisconnecting;

  /// No description provided for @homeNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get homeNotConnected;

  /// No description provided for @serversSearchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get serversSearchLocation;

  /// No description provided for @serversAutoSelect.
  ///
  /// In en, this message translates to:
  /// **'Auto select'**
  String get serversAutoSelect;

  /// No description provided for @serversAutoSelectEnabled.
  ///
  /// In en, this message translates to:
  /// **'Auto select enabled'**
  String get serversAutoSelectEnabled;

  /// No description provided for @serversAutoSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Best available server'**
  String get serversAutoSelectSubtitle;

  /// No description provided for @serversAutoSelectFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding best server...'**
  String get serversAutoSelectFinding;

  /// No description provided for @serversAutoSelectUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable'**
  String get serversAutoSelectUnavailable;

  /// No description provided for @serversClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get serversClose;

  /// No description provided for @protocolsSearchProtocol.
  ///
  /// In en, this message translates to:
  /// **'Search Protocol'**
  String get protocolsSearchProtocol;

  /// No description provided for @protocolsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get protocolsClose;

  /// No description provided for @protocolsRecommended.
  ///
  /// In en, this message translates to:
  /// **'(Recommended)'**
  String get protocolsRecommended;

  /// No description provided for @settingsSecuredSince.
  ///
  /// In en, this message translates to:
  /// **'Secured since {date}'**
  String settingsSecuredSince(String date);

  /// No description provided for @settingsMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get settingsMain;

  /// No description provided for @settingsZenSDK.
  ///
  /// In en, this message translates to:
  /// **'ZenSDK'**
  String get settingsZenSDK;

  /// No description provided for @settingsZenSDKDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow secure resource sharing'**
  String get settingsZenSDKDescription;

  /// No description provided for @settingsVPNProtocolSelection.
  ///
  /// In en, this message translates to:
  /// **'VPN Protocol Selection'**
  String get settingsVPNProtocolSelection;

  /// No description provided for @settingsVPNProtocolAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsVPNProtocolAutomatic;

  /// No description provided for @settingsLaunchOnStartup.
  ///
  /// In en, this message translates to:
  /// **'Launch on startup'**
  String get settingsLaunchOnStartup;

  /// No description provided for @settingsLaunchOnStartupDescription.
  ///
  /// In en, this message translates to:
  /// **''**
  String get settingsLaunchOnStartupDescription;

  /// No description provided for @settingsLaunchOnStartupFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to activate, please try again'**
  String get settingsLaunchOnStartupFailed;

  /// No description provided for @settingsSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Zensheild on social media'**
  String get settingsSocialMedia;

  /// No description provided for @settingsLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogOut;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Zenshield'**
  String get aboutTitle;

  /// No description provided for @aboutWhatIsZenshield.
  ///
  /// In en, this message translates to:
  /// **'What is Zenshield?'**
  String get aboutWhatIsZenshield;

  /// No description provided for @aboutWhatIsZenshieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Zenshield is a free VPN that lets you access geo-restricted content, browse securely on public Wi-Fi, and keep your online activity private. No subscription required.'**
  String get aboutWhatIsZenshieldDescription;

  /// No description provided for @aboutLegalAndSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Policies'**
  String get aboutLegalAndSupportTitle;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTermsOfService;

  /// No description provided for @aboutSupportCenter.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get aboutSupportCenter;

  /// No description provided for @aboutEndUserLicenseAgreement.
  ///
  /// In en, this message translates to:
  /// **'End User License Agreement'**
  String get aboutEndUserLicenseAgreement;

  /// No description provided for @aboutTroubleshootingTitle.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting & Feedback'**
  String get aboutTroubleshootingTitle;

  /// No description provided for @aboutEmailCopiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get aboutEmailCopiedTitle;

  /// No description provided for @aboutEmailCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Email address copied to clipboard'**
  String get aboutEmailCopiedToClipboard;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your new password for Zenshield VPN and type new password twice.'**
  String get changePasswordDescription;

  /// No description provided for @changePasswordNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewPasswordLabel;

  /// No description provided for @changePasswordNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create your new password'**
  String get changePasswordNewPasswordHint;

  /// No description provided for @changePasswordConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirmPasswordLabel;

  /// No description provided for @changePasswordConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get changePasswordConfirmPasswordHint;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get changePasswordButton;

  /// No description provided for @changePasswordPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'These passwords don\'t match'**
  String get changePasswordPasswordsDontMatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordError.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get changePasswordError;

  /// No description provided for @changePasswordSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'All set!'**
  String get changePasswordSuccessTitle;

  /// No description provided for @changePasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password is now updated'**
  String get changePasswordSuccessMessage;

  /// No description provided for @changePasswordSuccessButton.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get changePasswordSuccessButton;

  /// No description provided for @rateAppPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeling safer with Zenshield?'**
  String get rateAppPopupTitle;

  /// No description provided for @rateAppPopupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your review helps others stay safe online.'**
  String get rateAppPopupSubtitle;

  /// No description provided for @rateAppPopupFeedbackPrefix.
  ///
  /// In en, this message translates to:
  /// **'Got feedback? '**
  String get rateAppPopupFeedbackPrefix;

  /// No description provided for @rateAppPopupFeedbackLink.
  ///
  /// In en, this message translates to:
  /// **'Tap here'**
  String get rateAppPopupFeedbackLink;

  /// No description provided for @rateAppPopupFeedbackSuffix.
  ///
  /// In en, this message translates to:
  /// **' to tell us directly.'**
  String get rateAppPopupFeedbackSuffix;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail and we will send you magic link for verification.'**
  String get resetPasswordDescription;

  /// No description provided for @resetPasswordEmailDoesntExist.
  ///
  /// In en, this message translates to:
  /// **'E-Mail doesn\'t exist'**
  String get resetPasswordEmailDoesntExist;

  /// No description provided for @resetPasswordEmailNotRegisteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Not Found'**
  String get resetPasswordEmailNotRegisteredTitle;

  /// No description provided for @resetPasswordEmailNotRegisteredText.
  ///
  /// In en, this message translates to:
  /// **'The email address you entered is not registered or not confirmed. Please check your email and try again.'**
  String get resetPasswordEmailNotRegisteredText;

  /// No description provided for @loginFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailedTitle;

  /// No description provided for @loginErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Please check your internet connection and try again.'**
  String get loginErrorText;

  /// No description provided for @signUpFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up Failed'**
  String get signUpFailedTitle;

  /// No description provided for @signUpErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign up. Please check your internet connection and try again.'**
  String get signUpErrorText;

  /// No description provided for @authenticationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Failed'**
  String get authenticationFailedTitle;

  /// No description provided for @wrongCredentialsText.
  ///
  /// In en, this message translates to:
  /// **'The email or password you entered is incorrect. Please try again.'**
  String get wrongCredentialsText;

  /// No description provided for @invalidPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalidPasswordTitle;

  /// No description provided for @invalidPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Password must meet the following requirements:\n\n• At least 8 characters long\n• Only Latin characters (A-Z, a-z, 0-9, and special characters)'**
  String get invalidPasswordText;

  /// No description provided for @invalidEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmailTitle;

  /// No description provided for @invalidEmailText.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmailText;

  /// No description provided for @emailEmploymentErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Employment Error'**
  String get emailEmploymentErrorTitle;

  /// No description provided for @emailEmploymentErrorText.
  ///
  /// In en, this message translates to:
  /// **'The email you entered is already in use. Please try again.'**
  String get emailEmploymentErrorText;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Zenshield'**
  String get appTitle;

  /// No description provided for @close_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Close Zenshield?'**
  String get close_dialog_title;

  /// No description provided for @close_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'You are currently connected to VPN. Do you want to disconnect and close the app?'**
  String get close_dialog_message;

  /// No description provided for @close_dialog_positive_button.
  ///
  /// In en, this message translates to:
  /// **'Disconnect & Close'**
  String get close_dialog_positive_button;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @splash_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get splash_error_title;

  /// No description provided for @splash_error_text.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while initializing the app. Please try again or contact support.'**
  String get splash_error_text;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @deepLinkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Error'**
  String get deepLinkErrorTitle;

  /// No description provided for @deepLinkErrorWrongAction.
  ///
  /// In en, this message translates to:
  /// **'Wrong action in deep link'**
  String get deepLinkErrorWrongAction;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @emailNotConfirmedOrRegisteredErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Not Confirmed or Registered'**
  String get emailNotConfirmedOrRegisteredErrorTitle;

  /// No description provided for @emailNotConfirmedOrRegisteredErrorText.
  ///
  /// In en, this message translates to:
  /// **'The email is not confirmed or registered. Please check your email or sign up.'**
  String get emailNotConfirmedOrRegisteredErrorText;

  /// No description provided for @resetPasswordErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get resetPasswordErrorTitle;

  /// No description provided for @resetPasswordErrorText.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get resetPasswordErrorText;

  /// No description provided for @registrationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get registrationErrorTitle;

  /// No description provided for @registrationErrorText.
  ///
  /// In en, this message translates to:
  /// **'The email you entered is already in use. Please try again.'**
  String get registrationErrorText;

  /// No description provided for @systemExtensionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'System Extension Required'**
  String get systemExtensionErrorTitle;

  /// No description provided for @systemExtensionMessageSequoiaAndLater.
  ///
  /// In en, this message translates to:
  /// **'Go to System Settings and open the General tab. In the Login Items & Extensions section, scroll down to Network Extensions and select the\nⓘ icon. Turn on Zenshield Network Extension.'**
  String get systemExtensionMessageSequoiaAndLater;

  /// No description provided for @systemExtensionMessageSonomaAndEarlier.
  ///
  /// In en, this message translates to:
  /// **'Go to System Settings and open the Privacy & Security tab. Scroll down until you see \"System software from application Zenshield was blocked from loading\" and select Allow.'**
  String get systemExtensionMessageSonomaAndEarlier;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
