library dart_sdk;

import 'dart:async';
import 'dart:developer';
import 'package:dart_peer_repo/src/serivces/peer.service.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:eventify/eventify.dart';

class SDKPeerClient {
  static PeerController? _peerController;

  static init({
    required String sdkApiKey,
    bool isDebug = true,
  }) {
    runZonedGuarded(() {
      _peerController ??= PeerController();
      if (_peerController != null) {
        _peerController!.init(sdkApiKey, isDebug);
        if (isDebug) {
          logPrint("SDKPeerClient init");
        }
      } else {
        throw Exception("Failed to initialize SDKPeerClient with SDK key");
      }
    }, (error, stackTrace) {
      if (isDebug) {
        logPrint('dart_sdk -> init: Unhandled exception: $error');
        logPrint(stackTrace as String);
      }
    });
  }

  static initWithToken({
    required String firebaseToken,
    required String userId,
    required Map<String, dynamic> userDeviceInfo,
    bool isDebug = true,
  }) {
    runZonedGuarded(() {
      _peerController ??= PeerController();

      if (_peerController == null) {
        throw Exception("Failed to initialize SDKPeerClient with Token");
      }
      _peerController!
          .initWithToken(firebaseToken, userId, userDeviceInfo, isDebug);
      if (isDebug) {
        logPrint("SDKPeerClient init");
      }
    }, (error, stackTrace) {
      if (isDebug) {
        log('initWithToken -> Unhandled exception: $error');
        log(stackTrace as String);
      }
    });
  }

  static Future<String?> start() async {
    String? peerId;
    await runZonedGuarded(() async {
      if (_peerController == null) {
        throw Exception("Please initialize SDKPeerClient");
      }
      peerId = await _peerController!.start();
      return peerId;
    }, (error, stackTrace) {
      log('dart_sdk -> start: Unhandled exception: $error');
      log(stackTrace.toString());
      return;
    });
    return peerId;
  }

  static Map<String, int> getRelaySocketsCount() {
    return _peerController!.getRelaySocketsCount();
  }

  static Future stop() async {
    runZonedGuarded(() async {
      if (_peerController == null) {
        throw Exception("Please initialize SDKPeerClient");
      }
      await _peerController!.stop();
    }, (error, stackTrace) {
      log('dart_sdk -> stop: Unhandled exception: $error');
      log(stackTrace as String);
    });
  }

  static Future<EventEmitter> getEventEmitter() async {
    if (_peerController == null) {
      throw Exception("Please initialize SDKPeerClient");
    }
    return _peerController!.getEventEmitter();
  }

  static Future refreshToken(String token) async {
    runZonedGuarded(() async {
      if (_peerController == null) {
        throw Exception("Please initialize SDKPeerClient");
      }
      _peerController!.refreshToken(token);
    }, (error, stackTrace) {
      log('dart_sdk -> refreshToken: Unhandled exception: $error');
      log(stackTrace as String);
    });
  }
}
