// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppArchiveModel {
  AppArchiveModel({
    this.appName,
    this.description,
    required this.items,
  });

  factory AppArchiveModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json["versions"] ?? json["items"];
    return AppArchiveModel(
      appName: json["appName"],
      description: json["description"],
      items: List<ItemModel>.from(
        (rawItems as List).map((x) => ItemModel.fromJson(x)),
      ),
    );
  }
  final String? appName;
  final String? description;
  final List<ItemModel> items;

  Map<String, dynamic> toJson() {
    return {
      "appName": appName,
      "description": description,
      "versions": List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class ItemModel {
  ItemModel({
    required this.version,
    required this.shortVersion,
    required this.changes,
    required this.date,
    required this.mandatory,
    required this.url,
    required this.platform,
    this.isLatest,
    this.changedFiles,
    this.appName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      version: json["version"],
      shortVersion: json["shortVersion"],
      changes: List<ChangeModel>.from(
        json["changes"].map((x) => ChangeModel.fromJson(x)),
      ),
      date: json["date"],
      mandatory: json["mandatory"],
      url: json["url"],
      platform: json["platform"],
      isLatest: json["is_latest"],
    );
  }
  final String version;
  final int shortVersion;
  final List<ChangeModel> changes;
  final String date;
  final bool mandatory;
  final String url;
  final String platform;
  final bool? isLatest;
  final List<FileHashModel?>? changedFiles;
  final String? appName;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "shortVersion": shortVersion,
      "changes": List<dynamic>.from(changes.map((x) => x.toJson())),
      "date": date,
      "mandatory": mandatory,
      "url": url,
      "platform": platform,
      "is_latest": isLatest,
    };
  }

  ItemModel copyWith({
    String? version,
    int? shortVersion,
    List<ChangeModel>? changes,
    String? date,
    bool? mandatory,
    String? url,
    String? platform,
    bool? isLatest,
    List<FileHashModel?>? changedFiles,
    String? appName,
  }) {
    return ItemModel(
      version: version ?? this.version,
      shortVersion: shortVersion ?? this.shortVersion,
      changes: changes ?? this.changes,
      date: date ?? this.date,
      mandatory: mandatory ?? this.mandatory,
      url: url ?? this.url,
      platform: platform ?? this.platform,
      isLatest: isLatest ?? this.isLatest,
      changedFiles: changedFiles ?? changedFiles,
      appName: appName ?? this.appName,
    );
  }
}

class VersionSelection {
  const VersionSelection({required this.item, required this.needUpdate});
  final ItemModel item;
  final bool needUpdate;
}

/// Picks which [ItemModel] the running app should be on.
///
/// If any entry is pinned with `is_latest: true`, that entry always wins and
/// `needUpdate` is true whenever it isn't the currently installed build —
/// higher or lower shortVersion alike, so backend can roll a device back to
/// an older build by pinning it. With no pinned entry, falls back to picking
/// the highest shortVersion and only updating when it's newer.
VersionSelection? selectVersionTarget(
  List<ItemModel> items,
  int currentBuild,
) {
  if (items.isEmpty) return null;

  final pinned = items.where((item) => item.isLatest == true).toList();
  if (pinned.isNotEmpty) {
    final target = pinned.reduce(
      (a, b) => a.shortVersion > b.shortVersion ? a : b,
    );
    return VersionSelection(
      item: target,
      needUpdate: target.shortVersion != currentBuild,
    );
  }

  final target = items.reduce(
    (a, b) => a.shortVersion > b.shortVersion ? a : b,
  );
  return VersionSelection(
    item: target,
    needUpdate: target.shortVersion > currentBuild,
  );
}

class ChangeModel {
  ChangeModel({this.type, required this.message});

  factory ChangeModel.fromJson(Map<String, dynamic> json) {
    return ChangeModel(type: json["type"], message: json["message"]);
  }
  final String? type;
  final String message;

  Map<String, dynamic> toJson() {
    return {"type": type, "message": message};
  }
}

class FileHashModel {
  FileHashModel({
    required this.filePath,
    required this.calculatedHash,
    required this.length,
  });

  factory FileHashModel.fromJson(Map<String, dynamic> json) {
    return FileHashModel(
      filePath: json["path"],
      calculatedHash: json["calculatedHash"],
      length: json["length"],
    );
  }
  final String filePath;
  final String calculatedHash;
  final int length;

  Map<String, dynamic> toJson() {
    return {
      "path": filePath,
      "calculatedHash": calculatedHash,
      "length": length,
    };
  }
}
