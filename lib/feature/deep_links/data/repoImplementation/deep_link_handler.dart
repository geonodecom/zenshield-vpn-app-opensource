import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/event_bus_events/on_deep_link_error.dart';
import 'package:zenshield/core/event_bus_events/on_email_verification_code_received.dart';
import 'package:zenshield/core/event_bus_events/on_forgot_password_verification_code_received.dart';
import 'package:zenshield/feature/deep_links/domain/deep_link_error.dart';
import 'package:zenshield/feature/deep_links/data/dataSources/deep_link_service.dart';

@lazySingleton
class DeepLinkHandler {
  DeepLinkHandler(
    this.deepLinkService,
    this.eventBus,
    this.logger,
  );

  final DeepLinkService deepLinkService;
  final EventBus eventBus;
  final Talker logger;

  void handleDeepLink(Uri uri) {
    logger.info('Handling deep link: $uri');
    final queryParams = uri.queryParameters;

    if (queryParams['source'] == 'oauth') {
      logger.info('OAuth web flow callback — no action required');
      return;
    }

    final action = queryParams['action'];

    switch (action) {
      case 'forgot_password_verification':
        logger.info('Handling forgot password verification');
        _handleForgotPassword(queryParams);
        break;
      case 'email_signup_verification':
        logger.info('Handling email signup verification');
        _handleEmailVerification(queryParams);
        break;
      default:
        {
          logger.info('Unknown action: $action');
          eventBus
              .fire(const OnDeepLinkError(error: DeepLinkError.unknownAction));
        }
    }
  }

  void _handleForgotPassword(Map<String, String> params) {
    final code = params['code'];
    if (code == null || code.isEmpty) {
      eventBus.fire(
          const OnDeepLinkError(error: DeepLinkError.missingCodeParameter));
      return;
    }

    eventBus.fire(OnForgotPasswordCodeReceived(code: code));
  }

  void _handleEmailVerification(Map<String, String> queryParams) {
    final code = queryParams['code'];
    if (code == null || code.isEmpty) {
      eventBus.fire(
          const OnDeepLinkError(error: DeepLinkError.missingCodeParameter));
      return;
    }

    eventBus.fire(OnEmailVerificationCodeReceived(code: code));
  }
}
