// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dart_peer_repo/src/P2P/request_handler_socket.dart';
import 'package:dart_peer_repo/src/classes/singbox_monitor.dart';
import 'package:dart_peer_repo/src/classes/socks5_client.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:dart_peer_repo/src/shared/settings.dart';
import 'package:eventify/eventify.dart';

import '../serivces/P2P.service.dart';
import 'p2p_helper.dart';

const peerSocketEvents = {
  'PeerSocketFree': '1',
  'RemoteSocketClosed': '2',
  'ConnectionCompleted': '3',
  'Authentication': '4',
  'TargetWebsiteError': '5',
  'Ping': '6',
  'Pong': '7',
  'SocketHandlerConnectionFailed': '8',
  'AuthenticationFailed': '9',
  'GetSettings': '10',
};

class MainSocket {
  int port;
  int socketReqHandlerPort;
  String ip;
  String peerId;
  String token;
  String userId;
  final EventEmitter emitter = EventEmitter();
  late RawSocket mainSocket;
  static const int MAX_SOCKET_RETRIES = 10;
  late String socketType;
  late int uid;
  late bool isBusy;
  late int retryConnectionCounter;
  late StreamSubscription subscription;
  bool peerCloseWithError = false;
  bool isReconnecting = false;
  bool onConnectionEstablishedEventFired = false;
  Timer? resetConnectionDebounce;
  List<RequestHandlerSocket> standByHandlerSockets = [];

  Settings globalSettings = Settings();

  MainSocket(
    this.port,
    this.socketReqHandlerPort,
    this.ip,
    this.peerId,
    this.token,
    this.userId,
  );

  _onMainSocketCloseWithError() {
    peerCloseWithError = true;
    mainSocket.close();

    for (var reqHandlerSocket in standByHandlerSockets) {
      reqHandlerSocket.close();
    }

    standByHandlerSockets = [];
  }

  end() {
    if (getIsDebug) {
      print('main socket destroy');
    }
    _onMainSocketCloseWithError();
  }

  Future<bool> connect() async {
    print('[GeoNode Status] MainSocket.connect() called');
    print('[GeoNode Status] Attempting to connect to $ip:$port');
    try {
      bool useSingbox = await SingboxMonitor().forceCheck();

      if (getIsDebug) {
        logPrint('🔌 MainSocket connecting to $ip:$port');
        logPrint(
            '   Singbox: ${useSingbox ? "ENABLED → SOCKS5" : "DISABLED → Direct"}');
      }

      if (useSingbox) {
        await _connectThroughSingbox(ip, port);
      } else {
        await _connectDirect(ip, port);
      }

      print('[GeoNode Status] Raw socket connected successfully');
      peerCloseWithError = false;
      retryConnectionCounter = 0;
      socketType = 'main';
      uid = math.Random().nextInt(1000000000);
      isBusy = false;
      mainSocket.setOption(SocketOption.tcpNoDelay, true);
      P2PService.enableKeepalive(mainSocket);
      print('[GeoNode Status] Socket options set (TCP_NODELAY, keepalive)');

      subscription = mainSocket.listen(
        (event) async {
          switch (event) {
            case RawSocketEvent.read:
              // Read incoming data
              final data = mainSocket.read();
              if (data != null) {
                await _handleRead(data);
              }
              break;

            case RawSocketEvent.write:
              // Socket is ready to send more data
              if (getIsDebug) {
                print('MAIN -> Ready to write more data if needed.');
              }
              break;

            case RawSocketEvent.closed:
              if (getIsDebug) {
                print('MAIN -> Connection closed by the server.');
              }
              break;

            case RawSocketEvent.readClosed:
              if (getIsDebug) {
                print('MAIN -> Socket is closed for reading.');
              }
              mainSocket.close();
              break;
          }
        },
        onError: (dynamic error) {
          if (getIsDebug) {
            print('error on main socket listen : $error');
          }
          peerCloseWithError = true;

          onError(error);
        },
        onDone: () {
          if (getIsDebug) {
            print('main socket onDone');
          }
          onClose();
        },
      );
      print('[GeoNode Status] Socket setup completed successfully');
      return true;
    } catch (e) {
      print('[GeoNode Status] Socket connection failed: $e');
      if (getIsDebug) {
        print('error on main socket connect : $e');
      }

      return false;
    }
  }

  Future<void> _connectThroughSingbox(String host, int port) async {
    try {
      Socks5Client socks5Client = Socks5Client(
        host: '127.0.0.1',
        port: 10801,
      );

      logPrint(
          '[GeoNode Status] MainSocket connecting via Singbox to $host:$port');

      mainSocket = await socks5Client.connectToTarget(host, port).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('MainSocket connection timeout via SOCKS5');
        },
      );

      logPrint(
          '[GeoNode Status] MainSocket connected via Singbox to $host:$port');

      if (getIsDebug) {
        logPrint('MainSocket -> Connected through Singbox to $host:$port');
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint(
            'MainSocket -> Singbox connection failed, falling back to direct: $e');
      }
      await _connectDirect(host, port);
    }
  }

  Future<void> _connectDirect(String host, int port) async {
    logPrint('[GeoNode Status] MainSocket connecting directly to $host:$port');

    mainSocket = await RawSocket.connect(
      host,
      port,
      timeout: const Duration(seconds: 10),
    );

    logPrint('[GeoNode Status] MainSocket connected directly to $host:$port');

    if (getIsDebug) {
      logPrint('MainSocket -> Connected directly to $host:$port');
    }
  }

  Future<void> _handleRead(List<int>? data) async {
    if (data == null) return;

    final request = String.fromCharCodes(data);
    final reqAsStr = request.toString();
    final isAuthPacket = reqAsStr == peerSocketEvents['Authentication'];
    final isPingPacket = reqAsStr == peerSocketEvents['Ping'];
    final isConnCompletedPacket = reqAsStr == peerSocketEvents['ConnectionCompleted'];
    final isAuthFailedPacket = reqAsStr == peerSocketEvents['AuthenticationFailed'];
    final isSettingsPacket = reqAsStr.startsWith('settings:');
    if (isAuthPacket) {
      if (getIsDebug) {
        print('P2PS-MainSocket -> Authentication');
      }
      P2PHelper()
          .writeToSocket(mainSocket, utf8.encode('authentication $token $userId $peerId'), 'Main');
      return;
    } else if (isConnCompletedPacket) {
      if (getIsDebug) {
        print('P2PS-MainSocket -> authorization COMPLETED');
      }
      if (onConnectionEstablishedEventFired) return;

      emitter.emit(P2PEvents.onConnectionEstablished, null, peerId);
      onConnectionEstablishedEventFired = true;
      P2PHelper()
          .writeToSocket(mainSocket, utf8.encode(peerSocketEvents['GetSettings']!), 'MainSocket');
      return;
    } else if (isSettingsPacket) {
      if (getIsDebug) {
        print('P2PS-MainSocket -> Settings Packet :  ${reqAsStr.toString()}');
      }
      final settingsList = reqAsStr.toString().split(':')[1].split(',');

      // Destructure the list into variables
      final reusableMode = int.tryParse(settingsList[0]) ?? 0;
      final standByMode = int.tryParse(settingsList[1]) ?? 0;
      final numberOfStandBySockets = int.tryParse(settingsList[2]) ?? 2;
      final launchStandBySocketOnNewRequest = int.tryParse(settingsList[3]) ?? 0;
      globalSettings.set(
          reusableMode: reusableMode,
          standByMode: standByMode,
          numberOfStandBySockets: numberOfStandBySockets,
          launchStandBySocketOnNewRequest: launchStandBySocketOnNewRequest);

      int numOfStandBySockets = int.tryParse(settingsList[2]) ?? 2;

      if (getIsDebug) {
        print(
            'P2PS-MainSocket -> Settings Packet :  ${globalSettings.settings.toString()}, $numOfStandBySockets');
      }

      initStandByRelays(numOfStandBySockets);
      return;
    } else if (isPingPacket) {
      if (getIsDebug) {
        print('MainSocket -> PING');
      }
      P2PHelper().writeToSocket(mainSocket, utf8.encode(peerSocketEvents['Pong']!), 'Main');
      return;
    } else if (isAuthFailedPacket) {
      _onMainSocketCloseWithError();
      return;
    }
    final List<String> requests = reqAsStr.split('reqId:');

    if (requests.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      requests.forEach((reqId) async {
        if (reqId.trim() == '') return;
        if (getIsDebug) {
          print('P2PS-MainSocket -> Request :  ${reqId.toString()}');
        }
        initRelayConnection(reqId: reqId, standBy: false);
        if (globalSettings.shouldOpenStandBySocketOnNewRequest) {
          initRelayConnection(reqId: reqId, standBy: true);
        }
      });
    }
  }

  initStandByRelays(int numberOfStandBySockets) async {
    for (var i = 0; i < numberOfStandBySockets; i++) {
      RequestHandlerSocket handler = initStandByRelayConnection();
      standByHandlerSockets.add(handler);
    }
  }

  RequestHandlerSocket initStandByRelayConnection() {
    final handler = RequestHandlerSocket(
      ip,
      socketReqHandlerPort,
      null,
      peerId,
      standBy: true,
      standByWaiting: true,
    );

    handler.emitter.on(P2PEvents.onSocketConnectionFailed, null, (e, reqId) {
      final msg = utf8.encode('${P2PEvents.onSocketConnectionFailed}:$reqId');
      P2PHelper().writeToSocket(mainSocket, msg, 'MainSocket');
    });

    handler.emitter.on(P2PEvents.onRequestCalculateResponse, null, (e, _) {
      emitter.emit(P2PEvents.onRequestCalculateResponse, null, e.eventData);
    });

    handler.connect();
    emitter.emit(P2PEvents.onCreateSocketRequestHandler, null, handler);
    return handler;
  }

  Future initRelayConnection({
    required String reqId,
    required bool standBy,
  }) async {
    final handler = RequestHandlerSocket(
      ip,
      socketReqHandlerPort,
      reqId,
      peerId,
      standBy: standBy,
    );

    handler.emitter.on(P2PEvents.onSocketConnectionFailed, null, (e, _) {
      final msg = utf8.encode('${P2PEvents.onSocketConnectionFailed}:$reqId');
      P2PHelper().writeToSocket(mainSocket, msg, 'MainSocket');
    });

    handler.emitter.on(P2PEvents.onRequestCalculateResponse, null, (e, _) {
      emitter.emit(P2PEvents.onRequestCalculateResponse, null, e.eventData);
    });

    emitter.emit(P2PEvents.onCreateSocketRequestHandler, null, handler);
    await handler.connect();
  }

  Future<void> onData(List<int>? data) async {
    try {
      await _handleRead(data);
    } catch (e) {
      if (getIsDebug) {
        print('error on main socket onData : $e');
      }
    }
  }

  void onError(dynamic error) {
    if (getIsDebug) {
      print('MainSocket:onError: error when connecting to socket-server: $error');
    }
    peerCloseWithError = true;
    emitter.emit(P2PEvents.onSocketConnectionFailed, null, error);
  }

  void onClose() async {
    if (getIsDebug) {
      print('onClose called');
    }
    // The socket was closed normally
    // reconnect the same socket after half a second
    if (!peerCloseWithError) {
      if (resetConnectionDebounce != null) return;

      resetConnectionDebounce = Timer(const Duration(milliseconds: 500), () async {
        if (retryConnectionCounter < MAX_SOCKET_RETRIES) {
          if (getIsDebug) {
            print('main socket trying to reconnect');
          }
          try {
            retryConnectionCounter++;
            mainSocket = await RawSocket.connect(ip, port);
            isBusy = false;
            retryConnectionCounter--;
            mainSocket.setOption(SocketOption.tcpNoDelay, true);
            peerCloseWithError = false;
          } catch (e) {
            if (getIsDebug) {
              print('error on main socket reconnect : $e');
            }
            peerCloseWithError = true;
            emitter.emit(P2PEvents.onSocketConnectionFailed,
                'End socket M - dont renew connection - had error', null);
            P2PHelper().closeSocket(mainSocket, 'MainSocket');
            emitter.emit(P2PEvents.onSocketConnectionClose, null, null);
          }
        } else {
          // too many retries, destory it
          emitter.emit(P2PEvents.onSocketConnectionFailed,
              'End socket M - dont renew connection - too many sockets', null);
          P2PHelper().closeSocket(mainSocket, 'MainSocket');
          emitter.emit(P2PEvents.onSocketConnectionClose, null, null);
        }
      });
    } else {
      if (getIsDebug) {
        print('Main socket closed with error');
      }
      emitter.emit(P2PEvents.onSocketConnectionFailed,
          'End socket M - dont renew connection - had error', null);
      P2PHelper().closeSocket(mainSocket, 'MainSocket');
      emitter.emit(P2PEvents.onSocketConnectionClose, null, null);
    }
  }
}
