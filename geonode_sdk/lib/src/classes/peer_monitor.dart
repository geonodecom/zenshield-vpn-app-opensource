import 'dart:async';
import 'package:dart_peer_repo/src/serivces/peer.service.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import '../serivces/http_service.dart';
import '../shared/constants.dart';

class PeerMonitor {
  static final PeerMonitor _instance = PeerMonitor._internal();
  static const int _second = 15;
  Timer? _interval;
  String? _peerId;
  String? _userId;
  String? _configVersionToken;
  bool isRunning = false;
  bool isPeerActive = false;
  final Duration _duration = const Duration(seconds: _second);
  Function? onPeerDeactivate;

  factory PeerMonitor() => _instance;

  PeerMonitor._internal();

  init({peerId, userId, configVersionToken}) {
    if (getIsDebug) {
      logPrint('PeerMonitor -> onInit');
    }
    _peerId = peerId;
    _userId = userId;
    _configVersionToken = configVersionToken;
  }

  start(
      {onPeerDeactivate,
      onCredentialsMissing,
      onPeerActive,
      currentSdkApiKey,
      onTokenExpired,
      required currentPeerUrl}) {
// runs every 7 seconds
    if (_interval == null) {
      if (getIsDebug) {
        logPrint('Peer Connection DB Monitor -> start');
      }

      isRunning = true;
      _interval = Timer.periodic(_duration, (timer) {
        _monitorHandler(
          onPeerDeactivate: () async {
            await onPeerDeactivate();
          },
          onCredentialsMissing: () async {
            await onCredentialsMissing();
          },
          onPeerActive: () async {
            await onPeerActive();
          },
          onTokenExpired: () async {
            await onTokenExpired();
          },
          currentSdkApiKey: currentSdkApiKey,
          currentPeerUrl: currentPeerUrl,
        );
      });
    }
  }

  stop() {
    if (_interval != null) {
      isRunning = false;
      _interval?.cancel();
      _interval = null;
      if (getIsDebug) {
        logPrint('PeerMonitor -> Monitor Stopped.');
      }
    }
  }

  _monitorHandler(
      {onPeerDeactivate,
      onCredentialsMissing,
      onPeerActive,
      currentSdkApiKey,
      onTokenExpired,
      required currentPeerUrl}) async {
    try {
      if (getIsDebug) {
        logPrint('peer monitor is running $_userId / $_peerId');
      }
      String currentToken = PeerService.currentFirebaseToken;
      // get credentials
      final token = {
        AppConstants.LOGIN_TOKEN: currentToken,
        AppConstants.SDK_API_KEY: currentSdkApiKey,
      };

      if (token[AppConstants.LOGIN_TOKEN] == null &&
          token[AppConstants.SDK_API_KEY] == null) {
        if (getIsDebug) {
          logPrint('User credentials missing, disconnecting');
        }
        await onCredentialsMissing();
        return;
      }

      var data = await HttpService.getPeerMonitorData(
        currentToken,
        currentSdkApiKey,
        userId: _userId,
        peerId: _peerId,
        onTokenExpired: onTokenExpired,
        configVersionToken: _configVersionToken,
        currentPeerMonitorUrl: currentPeerUrl,
      );
      if (getIsDebug) {
        logPrint('peer monitor data: $data');
      }

      if (data != null) {
        isPeerActive = data['active'];
        if (!isPeerActive) {
          await onPeerDeactivate();
          stop();
        } else {
          await onPeerActive();
        }
      }
    } on Exception catch (e) {
      if (getIsDebug) {
        logPrint('Peer monitor error: $e');
      }
    }
  }
}
