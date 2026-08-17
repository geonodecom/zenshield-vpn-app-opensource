import 'dart:async';
import 'dart:io';

import 'package:dart_peer_repo/src/shared/global.dart';

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException {
    // Handle no internet connectivity
    return false;
  } catch (e) {
    // Handle other potential errors
    return false;
  }
  return false; // Default to false if any error occurs
}

class ConnectionMonitor {
  static final ConnectionMonitor _instance = ConnectionMonitor._internal();
  static const int _second = 60;
  Timer? _interval;

  bool isRunning = false;
  bool isPeerActive = false;
  Duration duration = const Duration(seconds: _second);
  Function? onPeerDeactivate;

  factory ConnectionMonitor() => _instance;

  ConnectionMonitor._internal();

  init() {
    if (getIsDebug) {
      logPrint('ConnectionMonitor -> onInit');
    }
  }

  start({onConnectionDeactivate, onConnectionActive}) {
    if (_interval == null) {
      isRunning = true;
      _interval = Timer.periodic(duration, (timer) {
        _monitorHandler(
          onConnectionDeactivate: () async {
            if (getIsDebug) {
              logPrint("Internet connection is absent");
            }
            await onConnectionDeactivate();
          },
          onConnectionActive: () async {
            if (getIsDebug) {
              logPrint("Internet connection is present");
            }
            await onConnectionActive();
          },
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
        logPrint('ConnectionMonitor -> Monitor Stopped.');
      }
    }
  }

  _monitorHandler({onConnectionDeactivate, onConnectionActive}) async {
    if (getIsDebug) {
      logPrint('Connection monitor is running');
    }

    {
      checkInternet().then((isConnected) {
        if (getIsDebug) {
          logPrint('Internet is $isConnected');
        }
        if (isConnected) {
          onConnectionActive();
        } else {
          onConnectionDeactivate();
        }
      });
    }
  }
}
