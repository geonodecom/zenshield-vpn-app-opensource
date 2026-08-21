import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_vpn_state/singbox_status.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';
import 'package:zenshield/gen/zenshield_generated_bindings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zenshield/core/utils/singbox_monitor.dart';

class FFISingboxService extends SingboxService {
  FFISingboxService({
    required super.commandClientFactory,
    required super.logger,
  });

  @override
  TcpSocketType get socketType =>
      const TcpSocketType(host: '127.0.0.1', port: 8965);
  ZenshieldNativeLibrary? zenshieldCore;

  @override
  Future<void> init() async {
    final os = Platform.operatingSystem;
    final DynamicLibrary nativeLibrary;
    switch (os) {
      case 'windows':
        nativeLibrary = DynamicLibrary.open(
          'zenshield_core.dll',
        );
      case 'linux':
        nativeLibrary = DynamicLibrary.open(
          'zenshield_core.so',
        );
      case 'macos':
        nativeLibrary = DynamicLibrary.open(
          'zenshield_core.dylib',
        );
      default:
        throw UnimplementedError();
    }

    zenshieldCore = ZenshieldNativeLibrary(nativeLibrary);

    final baseDir = await getApplicationSupportDirectory();
    final executablePath = Platform.resolvedExecutable;
    final executableDir = File(executablePath).parent;
    final workingDir = executableDir;
    final tempDir = await getTemporaryDirectory();

    if (!baseDir.existsSync()) {
      await baseDir.create(recursive: true);
    }
    if (!workingDir.existsSync()) {
      await workingDir.create(recursive: true);
    }

    final tunnelExeSource = File(
        '${executableDir.path}${Platform.pathSeparator}singbox-tunnel.exe');
    final tunnelExeInWorkingDir = File(
        '${Directory.current.path}${Platform.pathSeparator}singbox-tunnel.exe');

    logger.info('Executable directory: ${executableDir.path}');
    logger.info('Current working directory: ${Directory.current.path}');
    logger
        .info('Tunnel exe in executable dir: ${tunnelExeSource.existsSync()}');
    logger.info(
        'Tunnel exe in working dir: ${tunnelExeInWorkingDir.existsSync()}');

    if (tunnelExeSource.existsSync() &&
        !tunnelExeInWorkingDir.existsSync() &&
        Directory.current.path != executableDir.path) {
      logger.info('Copying singbox-tunnel.exe to working directory...');
      await tunnelExeSource.copy(tunnelExeInWorkingDir.path);
      logger
          .info('Copied singbox-tunnel.exe to: ${tunnelExeInWorkingDir.path}');
    }

    Pointer<ffi.Char>? baseDirPtr;
    Pointer<ffi.Char>? workingDirPtr;
    Pointer<ffi.Char>? tempDirPtr;

    try {
      baseDirPtr = baseDir.path.toNativeUtf8().cast<ffi.Char>();
      workingDirPtr = workingDir.path.toNativeUtf8().cast<ffi.Char>();
      tempDirPtr = tempDir.path.toNativeUtf8().cast<ffi.Char>();

      final err = zenshieldCore?.setup(
        baseDirPtr,
        workingDirPtr,
        tempDirPtr,
      );

      final errorMessage = _safeToString(err);
      _safeRelease(err);
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }
    } catch (e) {
      logger.error('[VPN] Failed to setup: $e');
      rethrow;
    } finally {
      _safeRelease(baseDirPtr);
      _safeRelease(workingDirPtr);
      _safeRelease(tempDirPtr);
    }

    try {
      statsCommandClient = commandClientFactory.createStatusStream(
        socketType: socketType,
      );
      vpnStateCommandClient = commandClientFactory.createVpnStateStream(
        socketType: socketType,
      );

      initClients();
    } catch (e) {
      logger.error('[VPN] Failed to init command clients: $e');
    }
  }

  @override
  Future<void> start({
    required String config,
    bool? isPaid,
  }) async {
    try {
      if (vpnStateCommandClient == null) {
        throw Exception(
          'Vpn State client is null',
        );
      }
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.starting().toEvent(),
      );

      // For animation
      await Future<void>.delayed(const Duration(milliseconds: 800));

      final configPtr = config.toNativeUtf8().cast<ffi.Char>();
      final err = zenshieldCore?.start(configPtr, 0);
      _safeRelease(configPtr);
      final errorMessage = _safeToString(err);
      _safeRelease(err);
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }

      logger.info('Waiting for SOCKS5 proxy to be ready...');
      final isSocks5Ready = await SingboxMonitor().isSocks5Ready();

      if (isSocks5Ready) {
        logger.info('SOCKS5 proxy is ready');
      } else {
        logger.warning(
            'SOCKS5 proxy not ready after timeout, but VPN may still work');
      }
    } catch (e) {
      logger.error('[VPN] Failed to start: $e');
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopped().toEvent(),
      );
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (vpnStateCommandClient == null) {
        throw Exception(
          'Vpn State client is null',
        );
      }
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopping().toEvent(),
      );
      final err = zenshieldCore?.stop();
      final errorMessage = _safeToString(err);
      _safeRelease(err);
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }
    } catch (e) {
      logger.error('[VPN] Failed to stop: $e');
    } finally {
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopped().toEvent(),
      );
    }
  }

  @override
  Future<void> changeServer(String link, String bearer, int port) async {
    try {
      final linkPtr = link.toNativeUtf8().cast<ffi.Char>();
      final bearerPtr = bearer.toNativeUtf8().cast<ffi.Char>();

      final result = zenshieldCore?.putSelector(linkPtr, bearerPtr, port);
      _safeRelease(linkPtr);
      _safeRelease(bearerPtr);

      if (result != null) {
        final errorMessage = _safeToString(result.r1);

        _safeRelease(result.r0);
        _safeRelease(result.r1);

        if (errorMessage != null && errorMessage.isNotEmpty) {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      logger.error('[VPN] Failed to change server: $e');
      rethrow;
    }
  }

  @override
  Future<String> getActualLogs() async {
    try {
      final currentSocketType = socketType;

      try {
        final socket = await Socket.connect(
          currentSocketType.host,
          currentSocketType.port,
          timeout: const Duration(milliseconds: 500),
        );
        socket.destroy();
      } catch (e) {
        logger.info(
            '[VPN] TCP socket is not available, VPN is likely not running: $e');
        return '';
      }

      final logLines = await commandClientFactory.getLogs(
        socketType: currentSocketType,
      );
      return '${logLines.join('\n')}\n';
    } catch (e) {
      logger.error('[VPN] Failed to get actual logs: $e');
      return '';
    }
  }

  @override
  Future<Map<String, dynamic>> getLinksOutboundsMap(String linksJson) async {
    try {
      final linksJsonPtr = linksJson.toNativeUtf8().cast<ffi.Char>();
      final result = zenshieldCore?.getLinksJson(linksJsonPtr);
      _safeRelease(linksJsonPtr);

      var responseJson = '';
      String? errorMessage;

      if (result != null) {
        responseJson = _safeToString(result.r0) ?? '';
        errorMessage = _safeToString(result.r1);

        _safeRelease(result.r0);
        _safeRelease(result.r1);
      }

      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }

      if (responseJson.isEmpty) {
        return {};
      }

      final map = jsonDecode(responseJson) as Map<String, dynamic>;
      return map;
    } catch (e) {
      logger.error('[VPN] Failed to get links outbounds map: $e');
      return {};
    }
  }

  @override
  Future<Map<String, String>> getPing(String linksJson) async {
    try {
      final currentSocketType = socketType;
      final ping = await commandClientFactory.getPing(
        socketType: currentSocketType,
        arg: linksJson,
      );
      final map = jsonDecode(ping) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      logger.error('[VPN] Failed to get ping: $e');
      return {};
    }
  }

  @override
  Future<void> testLink(String link) async {
    try {
      final linkPtr = link.toNativeUtf8().cast<ffi.Char>();
      final result = zenshieldCore?.testLink(linkPtr);
      _safeRelease(linkPtr);

      var success = false;
      String? errorMessage;

      if (result != null) {
        success = result.r0 == 1;
        errorMessage = _safeToString(result.r1);

        _safeRelease(result.r1);
      }

      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }

      if (!success) {
        throw Exception('Test link failed');
      }
    } catch (e) {
      logger.error('[VPN] Failed to test link: $e');
      rethrow;
    }
  }

  String? _safeToString(Pointer<ffi.Char>? pointer) {
    if (pointer == null || pointer.address == 0) {
      return null;
    }
    try {
      return pointer.cast<Utf8>().toDartString();
    } catch (e) {
      return null;
    }
  }

  void _safeRelease(Pointer? pointer) {
    if (pointer != null && pointer.address != 0) {
      try {
        calloc.free(pointer);
      } catch (e) {
        logger.error('Failed to free pointer: $e');
      }
    }
  }
}
