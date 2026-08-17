// globals.dart
bool _isDebug = true;
Function(String)? _curlLogCallback;
Function(String)? _logCallback;

bool get getIsDebug => _isDebug;

void debugPrint(String message) {
  if (getIsDebug) {
    print(message);
  }
  if (_logCallback != null) {
    try {
      _logCallback!(message);
    } catch (e) {}
  }
}

void logPrint(String message) {
  if (getIsDebug) {
    print(message);
  }
  if (_logCallback != null) {
    try {
      _logCallback!(message);
    } catch (e) {}
  }
}

void setDebugMode({required bool debugMode}) {
  _isDebug = debugMode;
}

void setCurlLogCallback(Function(String)? callback) {
  _curlLogCallback = callback;
}

void saveCurlLog(String curlLog) {
  if (_curlLogCallback != null) {
    try {
      _curlLogCallback!(curlLog);
    } catch (e) {}
  }
}

void setLogCallback(Function(String)? callback) {
  _logCallback = callback;
}
