import "dart:convert";
import "dart:io";

import "package:cryptography_plus/cryptography_plus.dart";
import "package:desktop_updater/src/app_archive.dart";
import "package:path/path.dart" as path;

import "helper/copy.dart";

String? _tryMacOsAppNameFromXcconfig() {
  final xcconfigPaths = [
    path.join("macos", "Runner", "Configs", "AppInfo.xcconfig"),
    path.join("Runner", "Configs", "AppInfo.xcconfig"),
  ];
  for (final xcconfigPath in xcconfigPaths) {
    final file = File(xcconfigPath);
    if (file.existsSync()) {
      final productName = _parseProductNameFromXcconfig(file);
      if (productName != null && productName.isNotEmpty) {
        return productName;
      }
    }
  }
  return null;
}

String? _parseProductNameFromXcconfig(File file) {
  final content = file.readAsStringSync();
  for (final line in content.split("\n")) {
    final trimmed = line.trim();
    if (trimmed.startsWith("//")) continue;
    if (trimmed.startsWith("PRODUCT_NAME")) {
      final eq = trimmed.indexOf("=");
      if (eq != -1) {
        return trimmed.substring(eq + 1).trim();
      }
    }
  }
  return null;
}

Future<String> getFileHash(File file) async {
  try {
    // Dosya içeriğini okuyun
    final List<int> fileBytes = await file.readAsBytes();

    // blake2s algoritmasıyla hash hesaplayın

    final hash = await Blake2b().hash(fileBytes);

    // Hash'i utf-8 base64'e dönüştürün ve geri döndürün
    return base64.encode(hash.bytes);
  } catch (e) {
    print("Error reading file ${file.path}: $e");
    return "";
  }
}

Future<String?> genFileHashes({required String? path}) async {
  print("Generating file hashes for $path");

  if (path == null) {
    throw Exception("Desktop Updater: Executable path is null");
  }

  final dir = Directory(path);

  print("Directory path: ${dir.path}");

  // Eğer belirtilen yol bir dizinse
  if (await dir.exists()) {
    // temp dizinindeki dosyaları kopyala
    // dir + output.txt dosyası oluşturulur
    final outputFile = File("${dir.path}${Platform.pathSeparator}hashes.json");

    // Çıktı dosyasını açıyoruz
    final sink = outputFile.openWrite();

    // ignore: prefer_final_locals
    var hashList = <FileHashModel>[];

    // Dizin içindeki tüm dosyaları döngüyle okuyoruz
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          !entity.path.endsWith("hashes.json") &&
          !entity.path.endsWith(".DS_Store")) {
        // Dosyanın hash'ini al
        final hash = await getFileHash(entity);
        final foundPath = entity.path.substring(dir.path.length + 1);

        // Dosya yolunu ve hash değerini yaz
        if (hash.isNotEmpty) {
          final hashObj = FileHashModel(
            filePath: foundPath,
            calculatedHash: hash,
            length: entity.lengthSync(),
          );
          hashList.add(hashObj);
        }
      }
    }

    // Dosya hash'lerini json formatına çevir
    final jsonStr = jsonEncode(hashList);

    // Çıktı dosyasına yaz
    sink.write(jsonStr);

    // Çıktıyı kaydediyoruz
    await sink.close();
    return outputFile.path;
  } else {
    throw Exception("Desktop Updater: Directory does not exist");
  }
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print("PLATFORM must be specified: macos, windows, linux");
    exit(1);
  }

  final platform = args[0];

  if (platform != "macos" && platform != "windows" && platform != "linux") {
    print("PLATFORM must be specified: macos, windows, linux");
    exit(1);
  }

  // Get app name from pubspec (needed for macos candidate selection)
  final pubspec = File("pubspec.yaml");
  final pubspecContent = await pubspec.readAsString();
  final appNamePubspec =
      RegExp(r"name: (.+)").firstMatch(pubspecContent)!.group(1)!.trim();

  // Go to dist directory and get all folder names
  final distDir = Directory("dist");

  if (!await distDir.exists()) {
    print("dist folder could not be found");
    exit(1);
  }

  /// Sort folders by name, it will be the build number,
  /// and get the last one, biggest build number
  final folders = await distDir.list().toList();
  folders.sort((a, b) => a.path.compareTo(b.path));

  final lastBuildNumberFolder = folders.last;

  // Get all files in the last folder path
  final files = await Directory(lastBuildNumberFolder.path).list().toList();

  var platformFound = false;
  String? foundDirectory;
  String? foundVersion;
  String? foundBuildNumber;

  final candidates = <String, ({String version, String buildNumber})>{};
  for (final file in files) {
    if (file is! Directory) continue;
    final name = path.basename(file.path);
    final parts = name.split("-");
    if (parts.length < 2) continue;
    final foundPlatform = parts.last.split(".").first;
    if (foundPlatform != platform) continue;
    final versionBuild = parts.length >= 3 ? parts[parts.length - 2] : parts[0];
    final vp = versionBuild.split("+");
    if (vp.length < 2) continue;
    final version = vp.first;
    final buildNumber = vp.last.split("-").first;
    candidates[file.path] = (version: version, buildNumber: buildNumber);
  }

  if (candidates.isEmpty) {
    print("File not found for platform: $platform");
    exit(1);
  }

  if (platform == "macos") {
    for (final entry in candidates.entries) {
      final appName = _tryMacOsAppNameFromXcconfig() ?? appNamePubspec;
      final contentsPath = "${entry.key}/$appName.app/Contents";
      if (Directory(contentsPath).existsSync()) {
        foundDirectory = entry.key;
        foundVersion = entry.value.version;
        foundBuildNumber = entry.value.buildNumber;
        platformFound = true;
        break;
      }
    }
  }
  if (!platformFound || foundDirectory == null) {
    final first = candidates.entries.first;
    foundDirectory = first.key;
    foundVersion = first.value.version;
    foundBuildNumber = first.value.buildNumber;
    platformFound = true;
  }



  if (platform == "windows") {
    await copyDirectory(
      Directory(
        foundDirectory,
      ),
      Directory(
        "${lastBuildNumberFolder.path}${Platform.pathSeparator}$foundVersion+$foundBuildNumber-$platform",
      ),
    );
  } else if (platform == "macos") {
    final macosAppName = _tryMacOsAppNameFromXcconfig() ?? appNamePubspec;

    final contentsPath = "$foundDirectory/$macosAppName.app/Contents";
    if (!await Directory(contentsPath).exists()) {
      exit(1);
    }
    await copyDirectory(
      Directory(contentsPath),
      Directory(
        "${lastBuildNumberFolder.path}${Platform.pathSeparator}$foundVersion+$foundBuildNumber-$platform",
      ),
    );
  } else if (platform == "linux") {
    await copyDirectory(
      Directory(foundDirectory),
      Directory(
        "${lastBuildNumberFolder.path}/$foundVersion+$foundBuildNumber-$platform",
      ),
    );
  }

  await genFileHashes(
    path:
        "${lastBuildNumberFolder.path}${Platform.pathSeparator}$foundVersion+$foundBuildNumber-$platform",
  );

  return;
}
