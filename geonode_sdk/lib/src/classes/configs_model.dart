class ConfigModel {
  int? multipleSocketConnectionsCPUsBy;
  int? sESSIONLIMITCOUNTPERPEER;
  DownloadUrls? downloadUrls;
  Versions? versions;
  String? configversiontoken;
  int? maxSocketPerUser;
  int? appPeerMonitorRate;
  int? sdkPeerMonitorRate;
  bool? showOfferWall;
  BuildNumbers? buildNumbers;

  ConfigModel(
      {this.multipleSocketConnectionsCPUsBy,
      this.sESSIONLIMITCOUNTPERPEER,
      this.downloadUrls,
      this.versions,
      this.configversiontoken,
      this.maxSocketPerUser,
      this.appPeerMonitorRate,
      this.sdkPeerMonitorRate,
      this.showOfferWall,
      this.buildNumbers});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    multipleSocketConnectionsCPUsBy = json['multipleSocketConnectionsCPUsBy'];
    multipleSocketConnectionsCPUsBy = json['maxSocketPerUser'];
    sESSIONLIMITCOUNTPERPEER = json['SESSION_LIMIT_COUNT_PER_PEER'];
    appPeerMonitorRate = json['appPeerMonitorRate'];
    sdkPeerMonitorRate = json['sdkPeerMonitorRate'];
    downloadUrls = json['downloadUrls'] != null
        ? DownloadUrls?.fromJson(json['downloadUrls'])
        : null;
    versions =
        json['versions'] != null ? Versions?.fromJson(json['versions']) : null;
    configversiontoken = json['config_version_token'];
    showOfferWall = json['showOfferWall'];
    buildNumbers = json['buildNumbers'] != null
        ? BuildNumbers?.fromJson(json['buildNumbers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['multipleSocketConnectionsCPUsBy'] = multipleSocketConnectionsCPUsBy;
    data['maxSocketPerUser'] = maxSocketPerUser;
    data['SESSION_LIMIT_COUNT_PER_PEER'] = sESSIONLIMITCOUNTPERPEER;
    data['downloadUrls'] = downloadUrls!.toJson();
    data['versions'] = versions!.toJson();
    data['config_version_token'] = configversiontoken;
    data['appPeerMonitorRate'] = appPeerMonitorRate;
    data['sdkPeerMonitorRate'] = sdkPeerMonitorRate;
    data['showOfferWall'] = showOfferWall;
    data['showOfferWall'] = showOfferWall;
    data['buildNumbers'] = buildNumbers!.toJson();
    return data;
  }
}

class ConfigData {
  String? configversiontoken;
  ConfigModel? config;

  ConfigData({this.configversiontoken, this.config});

  ConfigData.fromJson(Map<String, dynamic> json) {
    configversiontoken = json['config_version_token'];
    config =
        json['config'] != null ? ConfigModel?.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['config_version_token'] = configversiontoken;
    data['config'] = config!.toJson();
    return data;
  }
}

class DownloadUrls {
  String? android;
  String? ios;
  String? macOS;
  String? macOS64;
  String? linux;
  String? windows;
  String? androidHuawei;

  DownloadUrls(
      {this.android,
      this.ios,
      this.macOS,
      this.macOS64,
      this.linux,
      this.windows,
      this.androidHuawei});

  DownloadUrls.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    ios = json['ios'];
    macOS = json['macOS'];
    macOS64 = json['macOS64'];
    linux = json['linux'];
    windows = json['windows'];
    androidHuawei = json['androidHuawei'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['ios'] = ios;
    data['macOS'] = macOS;
    data['macOS64'] = macOS64;
    data['linux'] = linux;
    data['windows'] = windows;
    data['androidHuawei'] = androidHuawei;
    return data;
  }
}

class ConfigRoot {
  ConfigData? configData;
  String? message;

  ConfigRoot({this.configData, this.message});

  ConfigRoot.fromJson(Map<String, dynamic> json) {
    configData =
        json['data'] != null ? ConfigData?.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['data'] = configData?.toJson();
    dataMap['message'] = message;
    return dataMap;
  }
}

class Versions {
  String? desktop;
  String? mobile;

  Versions({this.desktop, this.mobile});

  Versions.fromJson(Map<String, dynamic> json) {
    desktop = json['desktop'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desktop'] = desktop;
    data['mobile'] = mobile;
    return data;
  }
}

class BuildNumbers {
  String? android;
  String? ios;
  String? huawei;

  BuildNumbers({this.android, this.ios, this.huawei});

  BuildNumbers.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    ios = json['ios'];
    huawei = json['huawei'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['ios'] = ios;
    data['huawei'] = huawei;
    return data;
  }
}
