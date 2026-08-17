import "dart:async";
import "dart:convert";
import "dart:io";

import "package:desktop_updater/desktop_updater.dart";
import "package:desktop_updater/src/file_hash.dart";
import "package:http/http.dart" as http;
import "package:path/path.dart" as path;

const _appArchiveDownloadTimeout = Duration(seconds: 5);
const _hashesDownloadTimeout = Duration(seconds: 5);

Future<ItemModel?> versionCheckFunction({
  required String appArchiveUrl,
}) async {
  final executablePath = Platform.resolvedExecutable;

  final directoryPath = executablePath.substring(
    0,
    executablePath.lastIndexOf(Platform.pathSeparator),
  );

  var dir = Directory(directoryPath);

  if (Platform.isMacOS) {
    dir = dir.parent;
  }

  // Eğer belirtilen yol bir dizinse
  if (await dir.exists()) {
    // temp dizini oluşturulur
    final tempDir = await Directory.systemTemp.createTemp("desktop_updater");

    // Download oldHashFilePath
    final client = http.Client();

    print("Using url: $appArchiveUrl");

    final appArchive = http.Request("GET", Uri.parse(appArchiveUrl));
    final appArchiveResponse = await client.send(appArchive).timeout(
      _appArchiveDownloadTimeout,
      onTimeout: () {
        client.close();
        throw TimeoutException(
          "Download of app-archive.json timed out after ${_appArchiveDownloadTimeout.inSeconds} seconds",
        );
      },
    );
    // temp dizinindeki dosyaları kopyala
    // dir + output.txt dosyası oluşturulur
    final outputFile =
        File("${tempDir.path}${Platform.pathSeparator}app-archive.json");

    // Çıktı dosyasını açıyoruz
    final sink = outputFile.openWrite();

    // Save the file
    await appArchiveResponse.stream.pipe(sink);

    // Close the file
    await sink.close();

    print("app archive file downloaded to ${outputFile.path}");

    if (!outputFile.existsSync()) {
      throw Exception("Desktop Updater: App archive do not exist");
    }

    final appArchiveString = await outputFile.readAsString();

    // Decode as List<FileHashModel?>
    final appArchiveDecoded = AppArchiveModel.fromJson(
      jsonDecode(appArchiveString),
    );

    final versions = appArchiveDecoded.items
        .where(
          (element) => element.platform == Platform.operatingSystem,
        )
        .toList();

    // No entry for this platform (or an empty archive) is not a failure — the
    // backend simply has nothing to offer, so the app should carry on as if it
    // were already up to date instead of showing an update error.
    if (versions.isEmpty) {
      print(
        "No version entry for ${Platform.operatingSystem} — skipping update",
      );
      return null;
    }

    late String? currentVersion;

    if (Platform.isLinux) {
      final exePath = await File("/proc/self/exe").resolveSymbolicLinks();
      final appPath = path.dirname(exePath);
      final assetPath = path.join(appPath, "data", "flutter_assets");
      final versionPath = path.join(assetPath, "version.json");
      final versionJson = jsonDecode(await File(versionPath).readAsString());

      print("Current version: ${versionJson['build_number']}");
      currentVersion = versionJson["build_number"];
    } else {
      await DesktopUpdater().getCurrentVersion().then(
        (value) {
          print("Current version: $value");
          currentVersion = value;
        },
      );
    }

    if (currentVersion == null) {
      throw Exception("Desktop Updater: Current version is null");
    }

    final currentBuild = int.parse(currentVersion!);
    final selection = selectVersionTarget(versions, currentBuild);
    if (selection == null) {
      print("No target version resolved — skipping update");
      return null;
    }
    final latestVersion = selection.item;

    print(
      "Target version: ${latestVersion.shortVersion} "
      "(isLatest: ${latestVersion.isLatest})",
    );

    if (selection.needUpdate) {
      print("New version found: ${latestVersion.version}");

      // calculate totalSize
      final tempDir = await Directory.systemTemp.createTemp("desktop_updater");

      final client = http.Client();

      print("Downloading hashes file");

      final newHashFileUrl = "${latestVersion.url}/hashes.json";
      final outputFile =
          File("${tempDir.path}${Platform.pathSeparator}hashes.json");

      await Future(() async {
        final newHashFileRequest =
            http.Request("GET", Uri.parse(newHashFileUrl));
        final newHashFileResponse = await client.send(newHashFileRequest);

        if (newHashFileResponse.statusCode != 200) {
          client.close();
          throw const HttpException("Failed to download hashes.json");
        }

        final sink = outputFile.openWrite();

        await newHashFileResponse.stream.listen(
          sink.add,
          onDone: () async {
            await sink.close();
            client.close();
          },
          onError: (e) async {
            await sink.close();
            client.close();
            throw e;
          },
          cancelOnError: true,
        ).asFuture();
      }).timeout(
        _hashesDownloadTimeout,
        onTimeout: () {
          client.close();
          throw TimeoutException(
            "Download of hashes.json timed out after ${_hashesDownloadTimeout.inSeconds} seconds",
          );
        },
      );

      final oldHashFilePath = await genFileHashes();
      final newHashFilePath = outputFile.path;

      print("Old hashes file: $oldHashFilePath");

      final changedFiles = await verifyFileHashes(
        oldHashFilePath,
        newHashFilePath,
      );

      // Version numbers differ but every file already matches, so there is
      // nothing to download — reporting an update here would only send
      // downloadUpdate() into "Changed files are not set".
      if (changedFiles.isEmpty) {
        print("No updates required.");
        return null;
      }

      return latestVersion.copyWith(
        changedFiles: changedFiles,
        appName: appArchiveDecoded.appName,
      );
    } else {
      print("No new version found");
    }
  }
  return null;
}
