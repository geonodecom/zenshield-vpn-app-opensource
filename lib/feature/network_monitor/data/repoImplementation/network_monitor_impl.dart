import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/feature/network_monitor/domain/repositories/network_monitor.dart';

// ignore: unused-code
@LazySingleton(as: AbstractNetworkMonitor)
class NetworkMonitor implements AbstractNetworkMonitor {
  NetworkMonitor(this._connectivity) {
    _init();
  }

  final Connectivity _connectivity;
  final StreamController<NetworkType> _networkController =
      StreamController.broadcast();

  NetworkType? _lastNetworkType;

  void _init() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final networkType = _mapResultsToNetworkType(results);

      final isIOS = Platform.isIOS;
      final hasChanged = networkType != _lastNetworkType;

      if (isIOS || hasChanged) {
        _lastNetworkType = networkType;
        _networkController.add(networkType);
      }
    });
  }

  NetworkType _mapResultsToNetworkType(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.other)) {
      return NetworkType.other;
    } else if (results.contains(ConnectivityResult.vpn)) {
      return NetworkType.vpn;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return NetworkType.mobile;
    } else if (results.contains(ConnectivityResult.wifi)) {
      return NetworkType.wifi;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return NetworkType.ethernet;
    } else {
      return NetworkType.other;
    }
  }

  @override
  Stream<NetworkType> get onNetworkChanged => _networkController.stream;

  @override
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  void dispose() {
    _networkController.close();
  }
}
