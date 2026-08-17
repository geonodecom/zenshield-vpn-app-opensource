import 'dart:io';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:yaml/yaml.dart';
import '../serivces/http_service.dart';

Future<bool> connectivityCheck() async {
  return HttpService.hasInternetConnection();
}

Future<String?> getAppVersion() async {
  try {
    final pubspec = await File('pubspec.yaml').readAsString();
    final yamlMap = loadYaml(pubspec);
    return yamlMap['version'];
  } catch (e) {
    if (getIsDebug) {
      logPrint('Error reading version from pubspec.yaml: $e');
    }
    return null;
  }
}
