import 'dart:convert';
import 'dart:typed_data';

import 'package:zenshield/core/models/protocols.dart';

class Utils {
  static bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    return !hasInvalidPasswordCharacters(password);
  }

  static bool hasInvalidPasswordCharacters(String password) {
    if (password.isEmpty) return false;
    return RegExp(r'[^\x00-\x7F]').hasMatch(password);
  }

  static String getProtocolPrefix(Protocols? protocol) {
    String protocolPrefix;
    switch (protocol) {
      case Protocols.vmess:
        protocolPrefix = 'vmess://';
      case Protocols.trojan:
        protocolPrefix = 'trojan://';
      case Protocols.shadowsocks:
        protocolPrefix = 'ss://';
      case Protocols.wireguard:
        protocolPrefix = 'wg://';
      case Protocols.auto:
      case Protocols.vless:
      case null:
        protocolPrefix = 'vless://';
    }
    return protocolPrefix;
  }

  static String parseStringFromBytes(Uint8List data, [int offset = 0]) {
    if (data.length < offset + 4) {
      throw Exception('data too short for string length');
    }
    final buffer = ByteData.sublistView(data, offset, offset + 4);
    final strLen = buffer.getInt32(0, Endian.big);
    if (data.length < offset + 4 + strLen) {
      throw Exception('data length mismatch for string');
    }
    return utf8.decode(data.sublist(offset + 4, offset + 4 + strLen));
  }
}
