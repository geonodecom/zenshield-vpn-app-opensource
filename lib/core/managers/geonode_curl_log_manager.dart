import 'dart:async';

import 'package:injectable/injectable.dart';

@LazySingleton()
class GeonodeCurlLogManager {
  GeonodeCurlLogManager();
  String? _lastCurlLog;

  final _curlLogStreamController = StreamController<String>.broadcast();

  Function(String)? _curlLogCallback;

  Stream<String> get curlLogStream async* {
    if (_lastCurlLog != null) {
      yield _lastCurlLog!;
    }
    yield* _curlLogStreamController.stream;
  }

  void setCurlLogCallback(Function(String)? callback) {
    _curlLogCallback = callback;
  }

  void saveCurlLog(String curlLog) {
    _lastCurlLog = curlLog;

    if (_curlLogCallback != null) {
      try {
        _curlLogCallback!(curlLog);
        // ignore: empty_catches
      } catch (e) {}
    }
    if (!_curlLogStreamController.isClosed) {
      _curlLogStreamController.add(curlLog);
    }
  }

  String? get lastCurlLog => _lastCurlLog;

  void dispose() {
    _curlLogStreamController.close();
  }
}
