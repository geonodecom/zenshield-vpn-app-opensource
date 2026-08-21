import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Probes whether the sing-box tunnel's local SOCKS5 inbound at
/// 127.0.0.1:10801 is reachable. Used to confirm the native tunnel actually
/// came up after starting it, and to gate VPN connect/disconnect transitions
/// against a tunnel that isn't really listening yet.
class SingboxMonitor {
  static final SingboxMonitor _instance = SingboxMonitor._internal();
  factory SingboxMonitor() => _instance;
  SingboxMonitor._internal();

  Timer? _monitorTimer;
  bool _isSingboxEnabled = false;
  bool _isMonitoring = false;
  bool _forceCheckMode = false;

  final String _singboxHost = '127.0.0.1';
  final int _singboxPort = 10801;
  final Duration _checkInterval = const Duration(seconds: 5);
  final Duration _connectionTimeout = const Duration(milliseconds: 50);

  bool get isSingboxEnabled => _isSingboxEnabled;
  bool get isMonitoring => _isMonitoring;
  bool get forceCheckMode => _forceCheckMode;

  void enableForceCheckMode() {
    _forceCheckMode = true;
    debugPrint('SingboxMonitor -> Force check mode ENABLED');
  }

  void disableForceCheckMode() {
    if (!_forceCheckMode) return;
    _forceCheckMode = false;
    debugPrint('SingboxMonitor -> Force check mode DISABLED');
  }

  Future<bool> getSingboxEnabled() async {
    if (_forceCheckMode) {
      return forceCheck();
    }
    return _isSingboxEnabled;
  }

  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    debugPrint(
        'SingboxMonitor -> Starting monitoring every ${_checkInterval.inSeconds}s');

    _monitorTimer = Timer.periodic(_checkInterval, (timer) async {
      await _checkSingboxStatus();
    });

    _checkSingboxStatus();
  }

  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
    debugPrint('SingboxMonitor -> Monitoring stopped');
  }

  Future<void> _checkSingboxStatus() async {
    try {
      final isRunning = await _testSingboxConnection();

      if (isRunning != _isSingboxEnabled) {
        _isSingboxEnabled = isRunning;
        final status = isRunning ? 'ENABLED' : 'DISABLED';
        debugPrint('SingboxMonitor -> Singbox status changed: $status');
      }
    } catch (e) {
      debugPrint('SingboxMonitor -> Error checking status: $e');
    }
  }

  Future<bool> _testSingboxConnection() async {
    RawSocket? socket;
    try {
      socket = await RawSocket.connect(_singboxHost, _singboxPort,
          timeout: _connectionTimeout);
      return true;
    } catch (e) {
      return false;
    } finally {
      socket?.close();
    }
  }

  Future<bool> forceCheck() async {
    await _checkSingboxStatus();
    return _isSingboxEnabled;
  }

  Future<bool> isSocks5Ready({
    Duration timeout = const Duration(seconds: 5),
    Duration checkInterval = const Duration(milliseconds: 500),
  }) async {
    debugPrint('SingboxMonitor -> waitForSocks5Ready() called '
        '(timeout: ${timeout.inSeconds}s, check interval: ${checkInterval.inMilliseconds}ms)');

    final startTime = DateTime.now();
    var attempt = 0;

    while (DateTime.now().difference(startTime) < timeout) {
      attempt++;
      final isReady = await _testSingboxConnection();

      if (isReady) {
        _isSingboxEnabled = true;
        debugPrint('SingboxMonitor -> SOCKS5 is ready (attempt $attempt)');
        return true;
      }

      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < timeout) {
        final remaining = timeout - elapsed;
        final delay = remaining > checkInterval ? checkInterval : remaining;
        await Future.delayed(delay);
      }
    }

    _isSingboxEnabled = false;
    debugPrint(
        'SingboxMonitor -> SOCKS5 not ready after timeout (${timeout.inSeconds}s, $attempt attempts)');
    return false;
  }

  Map<String, dynamic> getInfo() {
    return {
      'isEnabled': _isSingboxEnabled,
      'isMonitoring': _isMonitoring,
      'host': _singboxHost,
      'port': _singboxPort,
      'checkInterval': _checkInterval.inSeconds,
    };
  }

  void dispose() {
    stopMonitoring();
  }
}
