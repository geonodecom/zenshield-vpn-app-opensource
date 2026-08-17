enum NetworkType { vpn, wifi, mobile, ethernet, other }

abstract class AbstractNetworkMonitor {
  Stream<NetworkType> get onNetworkChanged;

  Future<bool> isConnected();
}
