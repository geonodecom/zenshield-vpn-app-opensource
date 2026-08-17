// ignore_for_file: prefer_typing_uninitialized_variables, body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dart_peer_repo/src/P2P/socks5/utils/ipv6.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import '../../classes/address.dart';
import '../p2p_helper.dart';

class Socks5Handler {
  late RawSocket _sourceSocket;
  Socket? targetSocket;

  Socks5Handler(
    RawSocket socket,
  ) {
    _sourceSocket = socket;
  }

  reply(int rep, {Address? address}) {
    try {
      List<int> data = [0x05, rep, 0x00];
      Uint8List dataList = Uint8List.fromList(data);

      _logSocketData('SEND', 'SOCKS5-Reply', dataList);

      if (address == null) {
        List<int> newData = [0x01, 0, 0, 0, 0, 0, 0];
        // add new data to dataList
        dataList = Uint8List.fromList(data + newData);
        P2PHelper().writeToSocket(_sourceSocket, dataList, 'Socks5');
        return;
      }

      dataList = Uint8List.fromList(data);
      _logSocketData('SEND', 'SOCKS5-Reply', dataList);

      if (checkAddressType(address.address) == 'IPv4') {
        data.add(0x01);
        data.addAll(address.address.split('.').map(int.parse).toList());
      } else if (checkAddressType(address.address) == 'IPv6') {
        data.add(0x04);
        List<int> ipv6BufArr = toBufArr(address.address);
        data.addAll(ipv6BufArr);
      }

      int port = address.port;
      data.add(port >> 8);
      data.add(port & 0xff);
      dataList = Uint8List.fromList(data);
      _logSocketData('SEND', 'SOCKS5-Reply', dataList);
      P2PHelper().writeToSocket(_sourceSocket, dataList, 'Socks5');
    } catch (e) {
      if (getIsDebug) {
        logPrint('reply() error: $e');
      }
    }
  }

  Future<void> handle(List<int> data) async {
    try {
      if (data[0] != 0x05) {
        if (getIsDebug) {
          logPrint('Unsupported SOCKS version => ${data[0]}');
        }
        await _sourceSocket.close();
        return;
      }

      if (data[1] == 0x01) {
        if (data[2] != 0x00) {
          if (getIsDebug) {
            logPrint('RESERVED should be 0x00');
          }
        }
        String dstHost;
        int dstPort;
        switch (data[3]) {
          case 0x01: //ipv4
            dstHost = "${data[4]}.${data[5]}.${data[6]}.${data[7]}";
            dstPort = (data[8] << 8) | data[9];
            break;
          case 0x03:
            int domainLen = data[4];
            String domain = ascii.decode(data.sublist(5, 5 + domainLen));
            try {
              List<InternetAddress> addresses =
                  await InternetAddress.lookup(domain);
              dstHost = addresses.first.address;
            } catch (e) {
              if (InternetAddress(domain).rawAddress.isNotEmpty) {
                dstHost = domain;
              } else {
                if (getIsDebug) {
                  logPrint('Invalid domain: $domain, error: $e');
                }
                reply(0x04);
                await _sourceSocket.close();
                return;
              }
            }
            dstPort = (data[5 + domainLen] << 8) | data[5 + domainLen + 1];
            break;
          case 0x04:
            List<int> addrBuf = data.sublist(4, 20);
            dstHost = toStr(addrBuf);
            dstPort = (data[20] << 8) | data[21];
            break;
          default:
            if (getIsDebug) {
              logPrint('ATYP ${data[3]} not supported');
            }

            reply(0x08);
            _sourceSocket.close();
            return;
        }
        if (getIsDebug) {
          logPrint('creating socks5 connection => $dstHost:$dstPort');
        }
        createConnection(dstHost, dstPort);
      } else if (data[1] == 0x02) {
        reply(0x07);
        await _sourceSocket.close();
      } else if (data[1] == 0x03) {
        reply(0x00, address: Address('0.0.0.0', 'IPv4', 0));
        await _sourceSocket.close();
      } else {
        if (getIsDebug) {
          logPrint('Unsupported method: ${data[1]}');
        }
        reply(0x07);
        await _sourceSocket.close();
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint('socks5 reequest() error: $e');
      }
    }
  }

  Future createConnection(String dstHost, int dstPort,
      {int retries = 3}) async {
    try {
      if (retries <= 0) {
        if (getIsDebug) {
          logPrint(
              'Connection retries exceeded: $dstHost:$dstPort / retries:$retries');
        }
        reply(0x05);
        await _sourceSocket.close();
        return;
      }

      targetSocket = await Socket.connect(
        dstHost,
        dstPort,
      ).catchError((e) async {
        debugPrint('proxy error: $e');
        await createConnection(dstHost, dstPort, retries: retries - 1);
      });

      if (targetSocket == null) {
        return;
      }

      // FIXME: Dead code. This does nothing, because .timeout creates a new stream. It doesnt modify the original stream.
      // targetSocket!.timeout(const Duration(seconds: 15), onTimeout: (event) async {
      //   if (getIsDebug) {
      //     print('proxy timeout');
      //   }
      //   if (!replied) {
      //     reply(0x05);
      //   }
      //   await _sourceSocket.close();
      //   await targetSocket!.close();
      //   return Future.value();
      // });

      // Once the connection is successful
      reply(0x00);

      targetSocket!.listen((data) async {
        _logSocketData('SEND', 'SOCKS5-Data', Uint8List.fromList(data));
        if (getIsDebug) {
          logPrint('socks5 write => ${data.length}');
        }
        P2PHelper().writeToSocket(_sourceSocket, data, 'Socks5');
      });

      await targetSocket!.done.then((value) async {
        if (getIsDebug) {
          logPrint('proxy done');
        }
        Future.delayed(Duration(seconds: 3), () async {
          await _sourceSocket.close();
        });
      }).catchError((e) async {
        if (getIsDebug) {
          logPrint('proxy done error: $e');
        }
        Future.delayed(Duration(seconds: 3), () async {
          await _sourceSocket.close();
        });
      });
    } catch (e) {
      if (getIsDebug) {
        logPrint('createConnection() error: $e');
      }
    }
  }

  handleData(Uint8List data) {
    targetSocket!.add(data);
  }

  void _logSocketData(String direction, String socketName, Uint8List data) {
    try {
      String textData;
      try {
        textData = String.fromCharCodes(data);
        textData = textData
            .replaceAll('\x00', '\\0')
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r')
            .replaceAll('\t', '\\t');

        if (textData.length > 200) {
          textData = textData.substring(0, 200) + '...';
        }
      } catch (e) {
        textData = '<binary data: ${data.length} bytes>';
      }

      print(
          '[GeoNode Status] $direction $socketName: "$textData" (${data.length} bytes)');
    } catch (e) {
      print(
          '[GeoNode Status] $direction $socketName: <error logging data> (${data.length} bytes)');
    }
  }

  String checkAddressType(String address) {
    String type = 'none';
    try {
      final internetAddress = InternetAddress(address);
      if (internetAddress.type == InternetAddressType.IPv4) {
        if (getIsDebug) {
          logPrint('$address is IPv4');
        }
        type = 'IPv4';
      } else if (internetAddress.type == InternetAddressType.IPv6) {
        if (getIsDebug) {
          logPrint('$address is IPv6');
        }
        type = 'IPv6';
      } else {
        if (getIsDebug) {
          logPrint('$address is neither IPv4 nor IPv6');
        }
      }
      return type;
    } catch (e) {
      logPrint('Invalid address: $address');
      return type;
    }
  }

  close() {
    targetSocket?.close();
  }
}
