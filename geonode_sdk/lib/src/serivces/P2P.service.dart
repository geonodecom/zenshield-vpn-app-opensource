// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'package:dart_peer_repo/src/P2P/request_handler_socket.dart';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:eventify/eventify.dart';

import '../P2P/main_socket.dart';

class P2PEvents {
  static String onConnectionEstablished = "onConnectionEstablished";
  static String onSocketConnectionFailed = "onSocketConnectionFailed";
  static String onBeforeStartSocketConnection = "onBeforeStartSocketConnection";
  static String onServerCloseSocketConnection = "onServerCloseSocketConnection";
  static String onSocketConnectionClose = "onSocketConnectionClose";
  static String onConnectionToServerFailed = "onConnectionToServerFailed";
  static String onReceiveData = "onReceiveData";
  static String onSocketClose = "onSocketClose";
  static String onCreateSocketRequestHandler = 'onCreateSocketRequestHandler';
  static String onTargetWebsiteError = 'onTargetWebsiteError';
  static String onCalculateTimers = 'onCalculateTimers';
  static String connected = 'connected';
  static String disconnected = 'disconnected';
  static String connecting = 'connecting';
  static String onTargetSocketEnd = 'onTargetSocketEnd';
  static String onRequestCalculateResponse = 'onRequestCalculateResponse';
}

enum SocketState { connecting, open, closing, closed }

class P2PService {
  final EventEmitter emitter = EventEmitter();
  String _ip = '';
  String _peerId = '';
  String _userId = '';
  String _token = '';
  int _port = 0;
  int _socketReqHandlerPort = 0;
  MainSocket? mainSocket;

  int retriesConnectionCounter = 0;
  static const int MAX_RETRY_PER_HOUR = 30;
  Timer? _retriesInterval;

  get relaysCount => UnmodifiableMapView(_relaysCount);
  final Map<String, int> _relaysCount = {};

  P2PService({ip, port, peerId, userId, token, socketReqHandlerPort}) {
    if (getIsDebug) {
      print('P2P init => $port, $socketReqHandlerPort, $peerId, $ip');
    }
    _ip = ip;
    _port = port;
    _peerId = peerId;
    _userId = userId;
    _token = token;
    _socketReqHandlerPort = socketReqHandlerPort;

    _retriesInterval ??= Timer.periodic(const Duration(hours: 1), (timer) {
      retriesConnectionCounter = 0;
    });
  }

  Future<bool> startSocketConnection() async {
    if (getIsDebug) {
      print('start connection');
    }
    if (retriesConnectionCounter >= MAX_RETRY_PER_HOUR) {
      retriesConnectionCounter = 0;
      if (getIsDebug) {
        print('P2PService -> onConnectionToServerFailed');
      }
      emitter.emit(P2PEvents.onConnectionToServerFailed, null, null);
      return false;
    }
    retriesConnectionCounter++;
    emitter.emit(P2PEvents.onBeforeStartSocketConnection);
    if (getIsDebug) {
      if (getIsDebug) {
        print(
            "P2PService -> STARTING MAIN SOCKET CONNECTION => retries counter $retriesConnectionCounter");
      }
    }

    mainSocket = MainSocket(
      _port,
      _socketReqHandlerPort,
      _ip,
      _peerId,
      _token,
      _userId,
    );

    mainSocket!.emitter.on(P2PEvents.onConnectionEstablished, null, (e, o) {
      emitter.emit(P2PEvents.onConnectionEstablished, null, _peerId);
    });

    mainSocket!.emitter.on(P2PEvents.onCalculateTimers, null, (e, o) {
      emitter.emit(P2PEvents.onCalculateTimers, null, e.eventData);
    });

    mainSocket!.emitter.on(P2PEvents.onSocketConnectionFailed, null, (e, o) {
      emitter.emit(P2PEvents.onSocketConnectionFailed, null, o);
    });

    mainSocket!.emitter.on(P2PEvents.onSocketConnectionClose, null, (e, o) {
      emitter.emit(P2PEvents.onSocketConnectionClose, null, null);
    });

    mainSocket!.emitter.on(P2PEvents.onRequestCalculateResponse, null, (e, o) {
      emitter.emit(P2PEvents.onRequestCalculateResponse, null, e.eventData);
    });

    mainSocket!.emitter.on(P2PEvents.onCreateSocketRequestHandler, null,
        (e, o) {
      final relay = e.eventData as RequestHandlerSocket;

      final counter = relay.isStandByWaiting
          ? 'standByWaiting'
          : relay.isStandBy
              ? 'standByRegular'
              : 'nonStandBy';

      _relaysCount[counter] = (_relaysCount[counter] ?? 0) + 1;
      relay.emitter.on('closed', null, (_, __) {
        _relaysCount[counter] = (_relaysCount[counter] ?? 0) - 1;
      });
    });

    final bool isConnected = await mainSocket!.connect();

    if (isConnected == true) {
      retriesConnectionCounter = 0;
      return true;
    } else {
      return Future.delayed(const Duration(seconds: 10),
          () async => await startSocketConnection());
    }
  }

  end({required bool forceDestroy}) {
    if (getIsDebug) {
      print('P2PService -> END SOCKET CONNECTION, forceDestroy: $forceDestroy');
    }
    mainSocket!.mainSocket.close();
  }

  static enableKeepalive(RawSocket socket) {
    // Enable keepalive probes every 60 seconds with 3 retries each 10 seconds
    const keepaliveEnabled = true;
    const keepaliveInterval = 60;
    const keepaliveSuccessiveInterval = 10;
    const keepaliveSuccessiveCount = 3;
    const SO_KEEPALIVE = 0x0008;
    const TCP_KEEPALIVE = 0x10;

    if (Platform.isIOS || Platform.isMacOS) {
      // SOL_SOCKET
      final enableKeepaliveOption = RawSocketOption.fromBool(
          RawSocketOption.levelSocket, // SOL_SOCKET
          SO_KEEPALIVE, // SO_KEEPALIVE
          keepaliveEnabled);

      // final enableKeepaliveOption = RawSocketOption.fromBool(
      //     0xffff, // SOL_SOCKET
      //     0x0008, // SO_KEEPALIVE
      //     keepaliveEnabled
      // );

      final keepaliveIntervalOption = RawSocketOption.fromInt(
          RawSocketOption.levelTcp, // IPPROTO_TCP
          TCP_KEEPALIVE, // TCP_KEEPALIVE
          keepaliveInterval);

      final keepaliveSuccessiveIntervalOption = RawSocketOption.fromInt(
        RawSocketOption.levelTcp, // IPPROTO_TCP
        0x101, // TCP_KEEPINTVL
        keepaliveSuccessiveInterval,
      );

      final keepaliveusccessiveCountOption = RawSocketOption.fromInt(
          RawSocketOption.levelTcp, // IPPROTO_TCP
          0x102, // TCP_KEEPCNT
          keepaliveSuccessiveCount);

      socket.setRawOption(enableKeepaliveOption);
      socket.setRawOption(keepaliveIntervalOption);
      socket.setRawOption(keepaliveSuccessiveIntervalOption);
      socket.setRawOption(keepaliveusccessiveCountOption);
    } else if (Platform.isAndroid) {
      final enableKeepaliveOption = RawSocketOption.fromBool(
          RawSocketOption.levelSocket, // SOL_SOCKET
          0x0009, // SO_KEEPALIVE
          keepaliveEnabled);
      final keepaliveIntervalOption = RawSocketOption.fromInt(
          RawSocketOption.levelTcp, // IPPROTO_TCP
          4, // TCP_KEEPIDLE
          keepaliveInterval);
      final keepaliveSuccessiveIntervalOption = RawSocketOption.fromInt(
        RawSocketOption.levelTcp, // IPPROTO_TCP
        5, // TCP_KEEPINTVL
        keepaliveSuccessiveInterval,
      );
      final keepaliveusccessiveCountOption = RawSocketOption.fromInt(
          RawSocketOption.levelTcp, // IPPROTO_TCP
          6, // TCP_KEEPCNT
          keepaliveSuccessiveCount);

      socket.setRawOption(enableKeepaliveOption);
      socket.setRawOption(keepaliveIntervalOption);
      socket.setRawOption(keepaliveSuccessiveIntervalOption);
      socket.setRawOption(keepaliveusccessiveCountOption);
    }
  }
}
