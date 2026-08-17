// ignore_for_file: non_constant_identifier_names, implementation_imports

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eventify/eventify.dart';
import '../classes/classes_helper.dart';
import '../classes/connection_monitor.dart';
import '../classes/peer_monitor.dart';
import '../shared/constants.dart';
import '../shared/global.dart';
import 'P2P.service.dart';
import 'environment.dart';
import 'http_service.dart';

class PeerController {
  PeerService? _peerService;

  void init(String sdk, bool debugMode) {
    _peerService = PeerService(sdkApiKey: sdk);
    setDebugMode(debugMode: debugMode);
    logPrint('debug mode is set to $getIsDebug');
  }

  void initWithToken(String firebaseToken, String userId,
      Map<String, dynamic> userDeviceInfo, bool debugMode) {
    _peerService = PeerService(
        firebaseLoginToken: firebaseToken,
        userId: userId,
        userDeviceInfo: userDeviceInfo);
    setDebugMode(debugMode: debugMode);
    logPrint('debug mode is set to $getIsDebug');
  }

  Future<String?> start() async {
    String? peerId = await connectPeer(_peerService);
    if (getIsDebug) {
      logPrint('dart_sdk -> start: PeerId: $peerId');
    }
    return peerId;
  }

  Future<dynamic> stop() async {
    if (getIsDebug) {
      logPrint('deleting peer..');
    }
    return await _peerService?.deletePeer(isForceStop: true);
  }

  void refreshToken(String token) {
    _peerService?.refreshToken(token);
  }

  Future<EventEmitter> getEventEmitter() async {
    if (_peerService == null) throw Exception('PeerService is not initialized');
    return _peerService!.emitter;
  }

  Future<String?> connectPeer(PeerService? service) async {
    var min_to_wait = 15;
    var max_to_wait = 90;

    try {
      service?.emitter.on(
          service.event_names['refresh_token'] ?? 'refresh_token',
          null,
          (e, o) {});
      service?.emitter
          .on(service.event_names['connected'] ?? 'connected', null, (e, o) {});
      service?.emitter.on(
          service.event_names['connecting'] ?? 'connecting', null, (e, o) {});
      service?.emitter.on(service.event_names['disconnected'] ?? 'disconnected',
          null, (e, o) {});
      service?.emitter.on(
          service.event_names['peer_server_error'] ?? 'peer_server_error', null,
          (e, o) {
        logPrint(
            'peer_server_error, reconnecting in $min_to_wait-$max_to_wait seconds...');
      });

      String? peerId = await service?.createPeer();
      if (peerId != null && peerId.isNotEmpty) {
        if (getIsDebug) {
          logPrint('connectPeer: connected');
        }
        return peerId;
      } else {
        if (getIsDebug) {
          logPrint('connectPeer: peerConnected: false');
        }
        return null;
      }
    } catch (error) {
      if (getIsDebug) {
        logPrint('connectPeer: exception: $error');
      }
      Timer(Duration(seconds: getRandomSeconds()), () {
        connectPeer(service);
      });
      return null;
    }
  }

  int getRandomSeconds() {
    return 10; // Modify this function to generate random seconds
  }

  Map<String, int> getRelaySocketsCount() {
    return _peerService?.P2PServiceInstance?.relaysCount ?? {};
  }
}

class PeerService {
  static String currentFirebaseToken = '';
  String currentMonitorPeerUrl = '';
  String currentUserId = '';
  String currentSdkApiKey = '';
  String currentConfigVersionToken = '';
  String currentPeerUrl = '';
  Map<String, dynamic>? userDeviceInfo;

  static final PeerService instance = PeerService._privateConstructor();

  PeerService._privateConstructor();
  EventEmitter emitter = EventEmitter();
  // static final PeerService _instance = PeerService._internal();
  bool isUserActivatedThePeer = true; // peer should be active by default
  bool isPeerActive = false;
  bool isResettingPeer = false;
  bool isCreatingPeer = false;
  bool isConnectivityChanged = false;
  bool shouldResetConnection = false;
  Timer? connectivityNoneTimer;
  bool vpnStatus = false;
  String? peerId;
  int? peerMonitorSettings;
  P2PService? P2PServiceInstance;
  PeerMonitor peerMonitor = PeerMonitor();
  ConnectionMonitor connectionMonitor = ConnectionMonitor();

  dynamic tcpServerInfo;
  dynamic connectivitySubscription;
  var auth = {"username": "test", "password": "test"};
  int? localId;

  bool enabledLocalMonitor = false;

  final event_names = {
    "connected": 'connected',
    "disconnected": 'disconnected',
    "connecting": 'connecting',
    "refresh_token": 'refresh_token',
    "peer_server_error": 'peer_server_error',
    'peer_client_error': 'peer_client_error',
  };

  PeerService(
      {String? firebaseLoginToken,
      String? sdkApiKey,
      String? userId,
      Environment? environment,
      this.userDeviceInfo}) {
    localId = (1000 + math.Random().nextInt(999999999) * 9000).floor();

    environment ??= EnvironmentValue.production;

    if ((firebaseLoginToken == null && sdkApiKey == null) ||
        (firebaseLoginToken == '' && sdkApiKey == '')) {
      throw Exception('firebaseLoginToken or sdkApiKey is required');
    }

    if (firebaseLoginToken != null) {
      currentFirebaseToken = firebaseLoginToken;
    }
    if (sdkApiKey != null) {
      currentSdkApiKey = sdkApiKey;
    }

    if (userId != null) {
      currentUserId = userId;
    }

    currentPeerUrl = environment.peerUrl;
    currentMonitorPeerUrl = environment.peerMonitorUrl;
    if (getIsDebug) {
      logPrint('peer url is set to ${environment.peerUrl}');
    }
  }

  refreshToken(String token) {
    if (getIsDebug) {
      logPrint('new token $token');
    }
    currentFirebaseToken = token;
  }

  Future<String?> createPeer() async {
    logPrint('[GeoNode Status] Starting peer creation...');
    if (isCreatingPeer || isPeerActive) {
      logPrint(
          '[GeoNode Status] Peer creation aborted - already creating or active');
      return null;
    }

    emitter.emit(event_names['connecting'] ?? 'connecting');
    logPrint('[GeoNode Status] Emitted connecting event');

    isCreatingPeer = true;
    int? statusCode = -1;
    String? responseData = "";
    try {
      var deviceInfo = userDeviceInfo ?? await _getDeviceInfo();
      bool isConnectivityCheck = await connectivityCheck();
      logPrint('[GeoNode Status] Connectivity check: $isConnectivityCheck');
      if (getIsDebug) {
        logPrint(
            'isConnectivityCheck $isConnectivityCheck, device info $deviceInfo');
      }

      if (isConnectivityCheck) {
        logPrint('[GeoNode Status] Internet connectivity confirmed');
        String? userId = currentUserId;

        bool isSDK = currentSdkApiKey != '';
        String currentKey =
            isSDK ? 'SDK Key => $currentSdkApiKey' : 'User ID => $userId';
        logPrint('[GeoNode Status] Creating peer with: $currentKey');

        if (getIsDebug) {
          logPrint('Creating peer - $currentKey');
        }

        logPrint('[GeoNode Status] Calling HttpService.createPeer...');
        final response =
            await HttpService.createPeer(currentFirebaseToken, currentSdkApiKey,
                userDeviceInfo: deviceInfo,
                ip: 'ip', // consider removing this
                peerUrl: currentPeerUrl);
        logPrint('[GeoNode Status] HttpService.createPeer completed');

        if (response != null) {
          statusCode = response.statusCode;
          responseData = response.body;
          logPrint('[GeoNode Status] Server response: ${response.statusCode}');
          if (response.statusCode >= 500 && response.statusCode <= 599) {
            logPrint(
                '[GeoNode Status] Server Error (${response.statusCode}): ${response.body}');
            logPrint('PeerService($localId) -> Server Error: ${response.body}');

            isCreatingPeer = false;
            await handleManagerServerError(statusCode);
            return null;
          } else if (response.statusCode >= 400 && response.statusCode <= 499) {
            logPrint(
                '[GeoNode Status] Client Error (${response.statusCode}): ${response.body}');
            logPrint('PeerService($localId) -> Client Error: ${response.body}');
            if (response.statusCode == 403 || response.statusCode == 401) {
              logPrint('[GeoNode Status] Emitting refresh_token event');
              emitter.emit(event_names['refresh_token'] ?? 'refresh_token');
            }

            emitter.emit(
                event_names['peer_client_error'] ?? 'peer_client_error',
                null,
                response.body);

            isCreatingPeer = false;
            return null;
          }
          final res = (json.decode(response.body))["data"];
          peerId = res["_id"];
          var token = res["token"];
          tcpServerInfo = res["tcpServerInfo"];
          log('tcpServerInfo $tcpServerInfo');
          // Build and publish curl command for UI/debugging.
          // The proxy auth password is provided at build time
          // (--dart-define=GEONODE_TCP_AUTH_SECRET=...) rather than
          // hardcoded, since this string gets logged/printed verbatim.
          final builtCurl =
              'curl -x \\${tcpServerInfo["ip"]}:\\${tcpServerInfo["httpPort"]} -U repocket_tcp_socket_server_auth-r_pid-\\$peerId:${BuildConfig.tcpAuthSecret} "https://api.ipify.org?format=json"';

          debugPrint(builtCurl);

          saveCurlLog(builtCurl);
          if (userId.isEmpty) {
            userId = res['userId'];
            if (res['userId'] != null && (res['userId'] as String).isNotEmpty) {
              currentUserId = userId!;
            }
          }

          log('token $token, userId $userId, peerId $peerId');

          P2PServiceInstance = P2PService(
            ip: tcpServerInfo["ip"],
            port: tcpServerInfo["port"],
            peerId: peerId,
            userId: userId,
            token: token,
            socketReqHandlerPort: tcpServerInfo['socketReqHandlerPort'],
          );
          _registerEventListeners();

          logPrint('[GeoNode Status] Starting socket connection...');
          bool? isSocketConnected =
              await P2PServiceInstance?.startSocketConnection();
          logPrint(
              '[GeoNode Status] Socket connection result: $isSocketConnected');

          if (isSocketConnected == true) {
            logPrint(
                '[GeoNode Status] Socket connected successfully, peer is now active');
            isUserActivatedThePeer = true;
            isPeerActive = true;
          } else {
            logPrint('[GeoNode Status] Socket connection failed');
          }

          isCreatingPeer = false;

          if (isSocketConnected == true) {
            return peerId;
          } else {
            return null;
          }
        } else {
          isCreatingPeer = false;
          return null;
        }
      } else {
        logPrint('[GeoNode Status] No internet connectivity');
        isCreatingPeer = false;
        return null;
      }
    } catch (error) {
      logPrint('[GeoNode Status] Exception during peer creation: $error');
      isCreatingPeer = false;
      logPrint('PeerService($localId) -> Exception: ${error.toString()}');
      if (responseData != null) {
        logPrint(
            'PeerService($localId) -> Failed to create connection: $responseData');
      }
      if (statusCode != null) {
        if (statusCode == 403 || statusCode == 401) {
          logPrint(
              '[GeoNode Status] Emitting refresh_token event due to error');
          emitter.emit(event_names['refresh_token'] ?? 'refresh_token');
        }
      }
      await handleManagerServerError(statusCode);
      return null;
    }
  }

  Future handleManagerServerError(int? statusCode) async {
    if (statusCode == null) return;
    var isServerErrorResponse = statusCode >= 500 && statusCode <= 599;

    if (isServerErrorResponse) {
      await resetPeer(closeService: false);
    }
  }

  _handleConnectionClosed({bool isReconnecting = true}) async {
    EasyDebounce.debounce(
        '_handleConnectionClosed-reset-peer-debouncer',
        // <-- An ID for this particular debouncer
        const Duration(milliseconds: 1000), // <-- The debounce duration
        () async {
      log(
        'PeerService($localId) -> _handleConnectionClosed, isReconnecting -> $isReconnecting',
      );

      if (isReconnecting) {
        Timer(const Duration(seconds: 3), () async {
          await resetPeer(closeService: false);
        });
      } else {
        if (!isUserActivatedThePeer) {
          await deletePeer(fromWhere: 'isUserActivatedThePeer');
        }
        emitter.emit(event_names['disconnected'] ?? 'disconnected');
      }
    });
  }

  _registerEventListeners() {
    P2PServiceInstance?.emitter
        .on(P2PEvents.onBeforeStartSocketConnection, null, (event, data) {
      emitter.emit(event_names['connecting'] ?? 'connecting');

      P2PServiceInstance?.emitter.on(P2PEvents.onSocketConnectionFailed, null,
          (event, object) async {
        //      if connection to socket failed
        bool isReconnecting = object == true;
        if (!isCreatingPeer && !isConnectivityChanged) {
          EasyDebounce.debounce(
              'onSocketConnectionFailed-debouncer', // <-- An ID for this particular debouncer
              const Duration(milliseconds: 1000), // <-- The debounce duration
              () async {
            if (!isCreatingPeer && !isConnectivityChanged) {
              await _handleConnectionClosed(isReconnecting: isReconnecting);
            }
          });
        }
      });

      P2PServiceInstance?.emitter.on(P2PEvents.onReceiveData, null,
          (event, object) async {
        EasyDebounce.debounce(
            'onReceiveData-debouncer', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 1000), // <-- The debounce duration
            () async {
          logPrint('onReceiveData $isUserActivatedThePeer');
          if (!isPeerActive) {
            logPrint(
                '[GeoNode Status] First data received, setting peer as active and emitting connected');
            isPeerActive = true;
            emitter.emit(event_names['connected'] ?? 'connected');
          } else {
            logPrint('[GeoNode Status] Data received while already active');
            emitter.emit(event_names['disconnected'] ?? 'disconnected');
          }
        });
      });
      P2PServiceInstance?.emitter.on(P2PEvents.onRequestCalculateResponse, null,
          (event, object) async {
        emitter.emit(
            P2PEvents.onRequestCalculateResponse, null, event.eventData);
      });

      P2PServiceInstance?.emitter.on(P2PEvents.onConnectionToServerFailed, null,
          (event, object) async {
        if (getIsDebug) {
          logPrint('failed to connect to server');
        }
        EasyDebounce.debounce(
            'onConnectionToServerFailed-debouncer', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 1000), // <-- The debounce duration
            () async {
          if (getIsDebug) {
            logPrint(
                "onConnectionToServerFailed / User activated peer: $isUserActivatedThePeer");
          }
          emitter.emit(event_names['disconnected'] ?? 'disconnected');

          await _stop();
        });
      });

      P2PServiceInstance?.emitter.on(P2PEvents.onSocketConnectionClose, null,
          (event, object) async {
        //      if connection to socket failed
        EasyDebounce.debounce(
            'onSocketConnectionClose-debouncer', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 1000), // <-- The debounce duration
            () async {
          if (getIsDebug) {
            logPrint("onSocketConnectionClose $isUserActivatedThePeer");
          }

          if (!isCreatingPeer) {
            Timer(const Duration(seconds: 1), () async {
              await _handleConnectionClosed();
            });
          }
        });
      });

      P2PServiceInstance?.emitter.on(P2PEvents.onRequestCalculateResponse, null,
          (event, object) async {
        logPrint(
            'onRequestCalculateResponse data length => ${event.eventData}');
      });

      P2PServiceInstance?.emitter.on(P2PEvents.onConnectionEstablished, null,
          (event, object) async {
        EasyDebounce.debounce(
            'onConnectionEstablished-debouncer', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 1000), // <-- The debounce duration
            () async {
          if (getIsDebug) {
            logPrint('P2PService -> onConnectionEstablished');
          }

          await _markPeerAsAlive();
        });
      });
    });
  }

  Future resetPeer({closeService = true}) async {
    if (isResettingPeer) return;
    isResettingPeer = true;
    EasyDebounce.debounce(
        'reset-peer-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 1000), // <-- The debounce duration
        () async {
      if (getIsDebug) {
        logPrint('resetting peer, closeService: $closeService');
      }

      await _stop(closeService: closeService);
      emitter.emit(event_names['connecting'] ?? 'connecting');

      Timer(const Duration(seconds: 3), () async {
        await createPeer();
      });
      Timer(const Duration(seconds: 5), () async {
        isResettingPeer = false;
      });
    });
  }

  deletePeer({bool isForceStop = false, String? fromWhere}) async {
    if (isResettingPeer && isForceStop == false) return;

    if (isForceStop) {
      await _stop();
    } else {
      EasyDebounce.debounce(
          'delete-peer-debouncer', // <-- An ID for this particular debouncer
          const Duration(milliseconds: 1000), // <-- The debounce duration
          () async {
        await _stop();
      });
    }
  }

  Future _stop({keepConnectionMonitor = false, closeService = true}) async {
    if (getIsDebug) {
      logPrint('peer id => $peerId');
    }
    if (peerId != null) {
      peerMonitor.stop();
      if (!keepConnectionMonitor) {
        connectionMonitor.stop();
      }
      await HttpService.deletePeer(
          peerId, currentFirebaseToken, currentSdkApiKey,
          peerUrl: currentPeerUrl);
    }
    peerId = null;
    P2PServiceInstance?.end(forceDestroy: closeService);
    P2PServiceInstance?.emitter.clear();
    isPeerActive = false;
    if (closeService) {
      emitter.emit(event_names['disconnected'] ?? 'disconnected');
    }
  }

  _markPeerAsAlive() async {
    return EasyDebounce.debounce(
        'markPeerAsAlive-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500), // <-- The debounce duration
        () async {
      bool isPeerAlive = false;
      try {
        logPrint('[GeoNode Status] Checking if peer is alive...');
        if (getIsDebug) {
          logPrint('markPeerAsAlive -> start -  $peerId');
        }

        Map<String, dynamic>? markAliveMap = await HttpService.markPeerAsAlive(
            currentFirebaseToken, currentSdkApiKey,
            peerId: peerId, peerUrl: currentPeerUrl);
        if (markAliveMap == null) {
          logPrint('[GeoNode Status] markPeerAsAlive returned null');
          return;
        }
        isPeerAlive = markAliveMap['isAlive'];
        logPrint('[GeoNode Status] Peer alive status: $isPeerAlive');

        if (isPeerAlive) {
          logPrint('[GeoNode Status] Peer is alive, emitting connected event');
          if (getIsDebug) {
            logPrint('markPeerAsAlive -> isAlive');
          }
          isPeerActive = true;
          isUserActivatedThePeer = true;
          emitter.emit(event_names['connected'] ?? 'connected');
          await startPeerMonitor();
          await startConnectionMonitor();
        } else {
          int statusCode = markAliveMap['statusCode'];
          logPrint(
              '[GeoNode Status] Peer is not alive, status code: $statusCode');
          if (statusCode >= 400 && statusCode <= 499) {
            if (getIsDebug) {
              logPrint('markPeerAsAlive -> Client Error: $statusCode');
            }
            emitter
                .emit(event_names['peer_client_error'] ?? 'peer_client_error');
            return;
          }
          await handleManagerServerError(markAliveMap['statusCode']);
        }
      } catch (error) {
        logPrint('[GeoNode Status] Error in markPeerAsAlive: $error');
        emitter.emit(event_names['disconnected'] ?? 'disconnected');

        if (getIsDebug) {
          logPrint(
              '_markPeerAsAlive -> Error happened: $error - isAlive: $isPeerAlive');
        }
        await resetPeer();
      }
    });
  }

  startPeerMonitor() async {
    peerMonitor.init(
      peerId: peerId,
      userId: currentUserId,
      configVersionToken: currentConfigVersionToken,
    );

    peerMonitor.start(
        onPeerDeactivate: () async {
          await _handleConnectionClosed();
        },
        onPeerActive: () {
          _verifyUIStatus();
        },
        onCredentialsMissing: () async {
          await _stop();
        },
        onTokenExpired: () {
          _invokeTokenRefresh();
        },
        currentSdkApiKey: currentSdkApiKey,
        currentPeerUrl: currentMonitorPeerUrl);
  }

  _verifyUIStatus() {
    logPrint('[GeoNode Status] Verifying UI status - setting peer as active');
    isPeerActive = true;
    emitter.emit(event_names['connected'] ?? 'connected');
  }

  _invokeTokenRefresh() {
    if (getIsDebug) {
      logPrint('invoking token refresh');
    }
    emitter.emit(event_names['refresh_token'] ?? 'refresh_token');
    _verifyUIStatus();
  }

  _getDeviceInfo() async {
    if (Platform.isAndroid) {
      return {
        "cpus": Platform.numberOfProcessors,
        "version": '1.0.0',
        "buildNumber": '1',
        "connectivityType": 'wifi',
        "os": "android",
      };
    } else if (Platform.isIOS) {
      return {
        "cpus": Platform.numberOfProcessors,
        "version": '1.0.0',
        "buildNumber": '1',
        "connectivityType": 'wifi',
        "os": "ios",
      };
    } else if (Platform.isMacOS) {
      return {
        "cpus": Platform.numberOfProcessors,
        "version": '1.0.0',
        "buildNumber": '1',
        "connectivityType": 'wifi',
        "os": "mac",
      };
    } else if (Platform.isWindows) {
      return {
        "cpus": Platform.numberOfProcessors,
        "version": '1.0.0',
        "buildNumber": '1',
        "connectivityType": 'wifi',
        "os": "windows",
      };
    } else if (Platform.isLinux) {
      return {
        "cpus": Platform.numberOfProcessors,
        "version": '1.0.0',
        "buildNumber": '1',
        "connectivityType": 'wifi',
        "os": "linux",
      };
    }
  }

  startConnectionMonitor() async {
    connectionMonitor.init();

    connectionMonitor.start(
      onConnectionDeactivate: () async {
        if (!shouldResetConnection) {
          shouldResetConnection = true;
          await _stop(keepConnectionMonitor: true);
        }
      },
      onConnectionActive: () async {
        if (shouldResetConnection) {
          shouldResetConnection = false;
          await resetPeer();
        }
      },
    );
  }
}
