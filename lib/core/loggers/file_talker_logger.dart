import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FileTalkerLogger {
  File? _logFile;
  final String _logFileName;
  final bool _enableInRelease;
  StreamSubscription<List<TalkerData>>? _historySubscription;
  int _lastHistoryLength = 0;

  FileTalkerLogger({
    String logFileName = 'app_debug.log',
    bool enableInRelease = true,
  })  : _logFileName = logFileName,
        _enableInRelease = enableInRelease;

  Future<void> _ensureLogFile() async {
    if (_logFile != null) return;

    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final logDirectory =
          Directory('${appSupportDir.path}${Platform.pathSeparator}logs');

      if (!await logDirectory.exists()) {
        await logDirectory.create(recursive: true);
      }

      _logFile =
          File('${logDirectory.path}${Platform.pathSeparator}$_logFileName');

      if (await _logFile!.exists()) {
        final fileSize = await _logFile!.length();
        if (fileSize > 10 * 1024 * 1024) {
          final timestamp =
              DateTime.now().toIso8601String().replaceAll(':', '-');
          _logFile = File(
              '${logDirectory.path}${Platform.pathSeparator}app_debug_$timestamp.log');
        }
      }
    } catch (e) {
      debugPrint('Failed to create log file: $e');
    }
  }

  void startLogging(Talker talker) {
    if (!_enableInRelease && kReleaseMode) return;

    final initialHistory = talker.history;
    if (initialHistory.isNotEmpty) {
      _saveLogs(initialHistory);
      _lastHistoryLength = initialHistory.length;
    }

    _historySubscription = Stream.periodic(
      const Duration(milliseconds: 500),
      (_) => talker.history,
    ).listen((history) {
      if (history.length > _lastHistoryLength) {
        final newLogs = history.sublist(_lastHistoryLength);
        _saveLogs(newLogs);
        _lastHistoryLength = history.length;
      }
    });
  }

  Future<void> _saveLogs(List<TalkerData> logs) async {
    if (logs.isEmpty) return;
    if (!_enableInRelease && kReleaseMode) return;

    await _ensureLogFile();
    if (_logFile == null) return;

    try {
      final buffer = StringBuffer();
      for (final data in logs) {
        buffer.write(_formatLogMessage(data));
        buffer.write('\n');
      }

      _logFile!.writeAsStringSync(
        buffer.toString(),
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('Failed to write log to file: $e');
    }
  }

  String _formatLogMessage(TalkerData data) {
    final buffer = StringBuffer();
    final time = data.time.toIso8601String();
    final level = data.logLevel?.toString() ?? 'INFO';

    buffer.write('[$time] [$level] ${data.message}');

    if (data.exception != null) {
      buffer.write('\nException: ${data.exception}');
    }

    if (data.error != null) {
      buffer.write('\nError: ${data.error}');
    }

    if (data.stackTrace != null) {
      buffer.write('\nStackTrace:\n${data.stackTrace}');
    }

    if (data.title != null) {
      buffer.write('\nTitle: ${data.title}');
    }

    return buffer.toString();
  }

  Future<String?> getLogFilePath() async {
    await _ensureLogFile();
    return _logFile?.path;
  }

  void stop() {
    _historySubscription?.cancel();
    _historySubscription = null;
  }
}
