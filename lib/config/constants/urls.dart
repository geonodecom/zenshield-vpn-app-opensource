class Urls {
  static Uri termsOfUse({required String languageCode}) => Uri.parse(
        'https://www.zenshield.com/terms-of-service',
      );
  static Uri privacyPolicy({required String languageCode}) => Uri.parse(
        'https://www.zenshield.com/privacy-policy',
      );

  static Uri endUserLicenseAgreement({required String languageCode}) =>
      Uri.parse(
        'https://www.zenshield.com/end-user-license-agreement',
      );

  static const String telegramUrl = 'https://t.me/ZenshieldVPN';

  static const String xUrl = 'https://x.com/ZenshieldVPN';

  static const String supportEmail = 'hello@zenshield.com';
}
