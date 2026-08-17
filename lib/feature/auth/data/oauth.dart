import 'dart:async';
import 'dart:io';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/auth/data/model/oauth_response.dart';

class OAuth {
  OAuth();

  Future<({int port, Future<OAuthResponse> responseFuture})>
  createLocalServer() async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    final port = server.port;

    final completer = Completer<OAuthResponse>();

    server.listen((HttpRequest request) async {
      try {
        final accessToken = request.uri.queryParameters['token'];

        if (accessToken == null || accessToken.isEmpty) {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
          completer.completeError(
            Exception('No AccessToken parameter received in response'),
          );
          await server.close(force: true);
          return;
        }

        final userId = request.uri.queryParameters['id'];

        if (userId == null || userId.isEmpty) {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
          completer.completeError(
            Exception('No UserId parameter received in response'),
          );
          await server.close(force: true);
          return;
        }

        final authResponse = OAuthResponse(token: accessToken, id: userId);

        final String redirectUrl;
        if (Platform.isAndroid) {
          redirectUrl = '${Api.endpoints.authSuccessRedirect}?deeplink=true';
        } else if (Platform.isIOS) {
          redirectUrl =
              '${Api.endpoints.authSuccessRedirect}?deeplink_ios=true';
        } else {
          redirectUrl = Api.endpoints.authSuccessRedirect;
        }
        request.response.statusCode = HttpStatus.found;
        request.response.headers.set('Location', redirectUrl);
        await request.response.close();

        completer.complete(authResponse);
        await server.close(force: true);
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
        completer.completeError(e);
        await server.close(force: true);
      }
    });

    return (port: port, responseFuture: completer.future);
  }
}
