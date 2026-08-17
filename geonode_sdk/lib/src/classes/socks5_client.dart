import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_peer_repo/src/shared/global.dart';
import '../P2P/p2p_helper.dart';

class Socks5Client {
  final String host;
  final int port;
  final String? username;
  final String? password;

  Socks5Client({
    required this.host,
    required this.port,
    this.username,
    this.password,
  });

  Future<RawSocket> connectToTarget(String targetHost, int targetPort) async {
    RawSocket? socksSocket;
    try {
      socksSocket = await RawSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 10),
      );

      if (getIsDebug) {
        logPrint('Socks5Client -> Connected to SOCKS5 server $host:$port');
      }

      await _performHandshake(socksSocket);

      await _sendSocks5Connect(socksSocket, targetHost, targetPort);

      if (getIsDebug) {
        logPrint(
          'Socks5Client -> SOCKS5 tunnel established to $targetHost:$targetPort',
        );
      }

      return socksSocket;
    } catch (e) {
      debugPrint('Socks5Client -> Error connecting: $e');
      socksSocket?.close();
      rethrow;
    }
  }

  Future<void> _performHandshake(RawSocket socket) async {
    final handshake = Uint8List.fromList([0x05, 0x01, 0x00]);

    P2PHelper().writeToSocket(socket, handshake, 'SOCKS5-HANDSHAKE');

    final response = await _readResponseWithTimeout(socket, 2);

    if (response.length < 2) {
      throw Exception('Socks5Client -> Handshake: short response');
    }

    final ver = response[0];
    final method = response[1];

    if (ver != 0x05) {
      throw Exception('Socks5Client -> Handshake: bad version $ver');
    }

    if (method != 0x00) {
      throw Exception(
        'Socks5Client -> Handshake: server requires unsupported auth method 0x${method.toRadixString(16)}',
      );
    }

    if (getIsDebug) {
      logPrint('Socks5Client -> Handshake OK (no auth)');
    }
  }


  Future<void> _sendSocks5Connect(
      RawSocket socket,
      String targetHost,
      int targetPort,
      ) async {

    final hostBytes = utf8.encode(targetHost);
    if (hostBytes.length > 255) {
      throw Exception('Socks5Client -> Hostname too long for SOCKS5');
    }

    final requestBytes = <int>[
      0x05,
      0x01,
      0x00,
      0x03,
      hostBytes.length,
      ...hostBytes,
      (targetPort >> 8) & 0xFF,
      targetPort & 0xFF,
    ];

    P2PHelper().writeToSocket(
      socket,
      Uint8List.fromList(requestBytes),
      'SOCKS5-CONNECT',
    );

    final head = await _readResponseWithTimeout(socket, 4);
    if (head.length < 4) {
      throw Exception('Socks5Client -> CONNECT: short header');
    }

    final ver = head[0];
    final rep = head[1];
    final atyp = head[3];

    if (ver != 0x05) {
      throw Exception('Socks5Client -> CONNECT: bad version $ver');
    }
    
    if (rep != 0x00) {
      final repMsg = _repToMessage(rep);
      throw Exception('Socks5Client -> CONNECT failed: $repMsg');
    }

    Uint8List addrBytes;
    if (atyp == 0x01) {
      final rest = await _readResponseWithTimeout(socket, 4 + 2);
      addrBytes = rest;
    } else if (atyp == 0x03) {
      final lenBytes = await _readResponseWithTimeout(socket, 1);
      final len = lenBytes[0];
      final domainPlusPort = await _readResponseWithTimeout(socket, len + 2);
      addrBytes = Uint8List.fromList([...lenBytes, ...domainPlusPort]);
    } else if (atyp == 0x04) {
      final rest = await _readResponseWithTimeout(socket, 16 + 2);
      addrBytes = rest;
    } else {
      throw Exception('Socks5Client -> CONNECT: unknown ATYP $atyp');
    }

    if (getIsDebug) {
      logPrint(
        'Socks5Client -> CONNECT OK, proxy bound info len=${addrBytes.length}',
      );
    }
  }

  Future<Uint8List> _readResponseWithTimeout(RawSocket socket, int count, {Duration timeout = const Duration(seconds: 5)}) async {
    final buffer = BytesBuilder();
    final startTime = DateTime.now();

    while (buffer.length < count) {
      if (DateTime.now().difference(startTime) > timeout) {
        throw Exception('Socks5Client -> Timeout reading response');
      }

      final data = socket.read(count - buffer.length);
      if (data != null && data.isNotEmpty) {
        buffer.add(data);
      } else {
        await Future.delayed(Duration(milliseconds: 10));
      }
    }
    
    return buffer.toBytes().sublist(0, count);
  }

  String _repToMessage(int rep) {
    switch (rep) {
      case 0x00:
        return 'succeeded';
      case 0x01:
        return 'general SOCKS server failure';
      case 0x02:
        return 'connection not allowed by ruleset';
      case 0x03:
        return 'network unreachable';
      case 0x04:
        return 'host unreachable';
      case 0x05:
        return 'connection refused by destination';
      case 0x06:
        return 'TTL expired';
      case 0x07:
        return 'command not supported';
      case 0x08:
        return 'address type not supported';
      default:
        return 'unknown error code 0x${rep.toRadixString(16)}';
    }
  }

  static Future<bool> testConnection(String host, int port) async {
    try {
      RawSocket? socket;
      try {
        socket = await RawSocket.connect(
          host,
          port,
          timeout: const Duration(seconds: 3),
        );
        return true;
      } catch (_) {
        return false;
      } finally {
        socket?.close();
      }
    } catch (_) {
      return false;
    }
  }
}
