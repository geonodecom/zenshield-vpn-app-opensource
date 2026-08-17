import 'dart:async';

import 'package:geonode_sdk/geonode_sdk.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/config/constants/common_constants.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';

abstract class AbstractGeonodeSdkManager {
  /// Initializes and connects the native Geonode SDK for an authenticated user.
  Future<void> connectForUser(String userId);

  /// Fully tears down the SDK instance. Call on logout.
  Future<void> disconnect();

  /// Enables or disables bandwidth sharing without disposing the SDK handle.
  Future<void> setSharingEnabled(bool enabled);

  /// Checks SDK connection when the app returns to foreground and logs status.
  Future<void> onAppResumed();

  /// Whether the native SDK is connected ([GeonodeSdk.isRunning]).
  bool get isSdkRunning;
}

@LazySingleton(as: AbstractGeonodeSdkManager)
class GeonodeSdkManager implements AbstractGeonodeSdkManager {
  GeonodeSdkManager(
    this._packageInfo,
    this._logger,
    this._preferences,
    this._authUserUseCase,
  );

  final PackageInfo _packageInfo;
  final Talker _logger;
  final Preferences _preferences;
  final AbstractAuthUserUseCase _authUserUseCase;

  GeonodeSdk? _sdk;
  String? _connectedUserId;

  static const _sdkOperationTimeout = Duration(seconds: 30);

  @override
  bool get isSdkRunning {
    final sdk = _sdk;
    if (sdk == null || sdk.isDisposed) return false;
    return sdk.isRunning;
  }

  bool _readIsRunning() {
    try {
      return isSdkRunning;
    } catch (e, stackTrace) {
      _logger.warning('[GeonodeSdk] Failed to read isRunning', e, stackTrace);
      return false;
    }
  }

  @override
  Future<void> connectForUser(String userId) async {
    if (userId.isEmpty) return;

    if (_sdk != null && _connectedUserId == userId && !_sdk!.isDisposed) {
      final zenEnabled = await _preferences.zenSdkEnabled;
      await setSharingEnabled(zenEnabled);
      _logger.info(
        '[GeonodeSdk] Reused SDK for user $userId | isRunning=${_readIsRunning()}',
      );
      return;
    }

    await disconnect();

    final apiKey = await _resolveApiKey();
    if (apiKey.isEmpty) return;

    try {
      _sdk = GeonodeSdk.initialize(
        apiKey,
        GeonodeAppInfo(
          id: await _appIdForPlatform(),
          userId: userId,
          version: _packageInfo.version,
          buildNumber: _packageInfo.buildNumber,
        ),
      );
      _connectedUserId = userId;
      _logger.info('[GeonodeSdk] Initialized for user $userId');

      final zenEnabled = await _preferences.zenSdkEnabled;
      if (zenEnabled) {
        await _connect(_sdk!);
        _logger.info(
          '[GeonodeSdk] connect() done for user $userId | isRunning=${_readIsRunning()}',
        );
      } else {
        _logger.info(
          '[GeonodeSdk] Initialized for user $userId | isRunning=${_readIsRunning()} (zen SDK off)',
        );
      }
    } catch (e, stackTrace) {
      _logger.error(
        '[GeonodeSdk] Failed to initialize for user $userId',
        e,
        stackTrace,
      );
      await disconnect();
    }
  }

  @override
  Future<void> setSharingEnabled(bool enabled) async {
    final sdk = _sdk;
    if (sdk == null || sdk.isDisposed) {
      if (enabled) {
        _logger.warning('[GeonodeSdk] Cannot enable sharing before SDK init');
      }
      return;
    }

    try {
      if (enabled && !sdk.isRunning) {
        await _connect(sdk);
        _logger.info(
          '[GeonodeSdk] connect() done | isRunning=${sdk.isRunning}',
        );
      } else if (!enabled && sdk.isRunning) {
        await _disconnect(sdk);
        _logger.info(
          '[GeonodeSdk] disconnect() done | isRunning=${sdk.isRunning}',
        );
      } else {
        _logger.info(
          '[GeonodeSdk] No sharing change | isRunning=${sdk.isRunning}',
        );
      }
    } catch (e, stackTrace) {
      _logger.error('[GeonodeSdk] Failed to toggle sharing', e, stackTrace);
    }
  }

  @override
  Future<void> onAppResumed() async {
    final authorized = await _authUserUseCase.isAuthorized();
    final userId = authorized ? await _authUserUseCase.getUserId() : null;
    final zenEnabled = await _preferences.zenSdkEnabled;
    final isInitialized = _sdk != null && !_sdk!.isDisposed;
    final isRunning = _readIsRunning();

    _logger.info(
      '[GeonodeSdk] App resumed | authorized=$authorized | '
      'userId=${userId ?? 'none'} | sdkInitialized=$isInitialized | '
      'isRunning=$isRunning | zenSdkEnabled=$zenEnabled',
    );

    if (!authorized || userId == null || userId.isEmpty) {
      if (isInitialized) {
        _logger.info('[GeonodeSdk] User not authorized — disconnecting SDK');
        await disconnect();
      }
      return;
    }

    if (!isInitialized || _connectedUserId != userId) {
      _logger.info('[GeonodeSdk] SDK needs init — connecting for user $userId');
      await connectForUser(userId);
      _logConnectionStatus('after connectForUser');
      return;
    }

    if (zenEnabled && !isRunning) {
      _logger.warning(
        '[GeonodeSdk] zenSdkEnabled=true but isRunning=false — calling connect()',
      );
      await setSharingEnabled(true);
      _logConnectionStatus('after reconnect');
      return;
    }

    if (!zenEnabled && isRunning) {
      _logger.info('[GeonodeSdk] Sharing disabled in settings — disconnecting');
      await setSharingEnabled(false);
      _logConnectionStatus('after disable');
      return;
    }

    _logger.info(
      '[GeonodeSdk] Connection state OK | isRunning=$isRunning — no action needed',
    );
  }

  void _logConnectionStatus(String context) {
    _logger.info(
      '[GeonodeSdk] $context | isRunning=${_readIsRunning()} | '
      'userId=${_connectedUserId ?? 'none'}',
    );
  }

  @override
  Future<void> disconnect() async {
    final sdk = _sdk;
    if (sdk == null) return;

    _sdk = null;
    _connectedUserId = null;

    try {
      if (!sdk.isDisposed && sdk.isRunning) {
        await _disconnect(sdk);
      }
    } catch (e, stackTrace) {
      _logger.warning('[GeonodeSdk] Error disconnecting SDK', e, stackTrace);
    } finally {
      sdk.dispose();
    }
  }

  Future<void> _connect(GeonodeSdk sdk) async {
    await sdk.connect().timeout(
      _sdkOperationTimeout,
      onTimeout: () {
        throw TimeoutException('GeonodeSdk.connect timed out');
      },
    );
    _logger.info('[GeonodeSdk] connect() done | isRunning=${sdk.isRunning}');
  }

  Future<void> _disconnect(GeonodeSdk sdk) async {
    await sdk.disconnect().timeout(
      _sdkOperationTimeout,
      onTimeout: () {
        throw TimeoutException('GeonodeSdk.disconnect timed out');
      },
    );
  }

  Future<String> _resolveApiKey() async {
    final override = await _preferences.geonodeApiKeyOverride;
    if (override != null && override.isNotEmpty) return override;
    return CommonConstants.geonodeApiKey;
  }

  Future<String> _appIdForPlatform() async {
    final override = await _preferences.geonodeAppIdOverride;
    if (override != null && override.isNotEmpty) return override;
    return CommonConstants.geonodeAppIdForCurrentPlatform;
  }
}
