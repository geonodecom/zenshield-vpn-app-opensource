// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:io';
import 'package:dart_peer_repo/src/shared/global.dart';
import 'package:http/src/response.dart' as res;
import '../classes/error_model.dart';
import '../shared/constants.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<dynamic> getPeerMonitorData(
      String? firebaseToken, String? sdkApiKey,
      {userId,
      peerId,
      configVersionToken,
      onTokenExpired,
      required currentPeerMonitorUrl}) async {
    var peerMonitorUrl = currentPeerMonitorUrl;
    Map<String, String> header = await getHeaders(firebaseToken, sdkApiKey);
    var url = "${peerMonitorUrl}peer/monitor/$userId/$peerId";

    if (configVersionToken != null) {
      url = '$url/$configVersionToken';
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      if (getIsDebug) {
        logPrint(
            'userId $userId, peerId $peerId, configVersionToken $configVersionToken');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final res = json.decode(response.body);
        return res['data'];
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          if (getIsDebug) {
            logPrint('token expired');
          }
          onTokenExpired();
        }
        if (getIsDebug) {
          logPrint(
              "Something went wrong => getPeerMonitorData, response ${response.body}, status ${response.statusCode}");
        }
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint(
            'error on monitor => ${e.toString()}, userId $userId, peerId $peerId,');
      }
    }
    return null;
  }

  static Future<res.Response?> createPeer(
    String? firebaseToken,
    String? sdkApiKey, {
    userDeviceInfo,
    ip,
    ipInfo,
    userid,
    peerUrl,
  }) async {
    var peerUlr = peerUrl;
    Map<String, String> header = await getHeaders(firebaseToken, sdkApiKey);

    String? uid = await getUserId();

    Map<String, dynamic> body = {
      "ip": ip,
      "username": "test",
      "password": "test",
      "userId": uid ?? '',
      "userDeviceInfo": userDeviceInfo,
    };
    try {
      final response = await http.post(Uri.parse("${peerUlr}peer/createPeer"),
          body: json.encode(body), headers: header);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        ErrorResponseModel errorResponseModel =
            errorResponseModelFromJson(response.body);
        if (getIsDebug) {
          logPrint(
              "error creating peer, response error response => ${errorResponseModel.message}, status ${response.statusCode}");
        }
        return response;
      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        if (getIsDebug) {
          logPrint(
              'server error > 500 => ${response.body}, status ${response.statusCode}');
        }
        return response;
      }
    } catch (e, stackTrace) {
      if (getIsDebug) {
        logPrint(
            'error creating peer => ${e.toString()}, stackTrace => $stackTrace');
      }
      return null;
    }
    return null;
  }

  static Future<dynamic> deletePeer(
      String? peerId, String? firebaseToken, String? sdkApiKey,
      {peerUrl}) async {
    var peerUlr = peerUrl;
    Map<String, String> header = await getHeaders(firebaseToken, sdkApiKey);

    Map<String, dynamic> body = {
      "peerId": peerId,
    };

    try {
      final response = await http.delete(Uri.parse("${peerUlr}peer/deletePeer"),
          body: json.encode(body), headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final res = json.decode(response.body);
        if (getIsDebug) {
          logPrint('deleted peer successfully => $res');
        }
        return res;
      } else {
        if (getIsDebug) {
          logPrint(
              "Something went wrong deleting peer, ${response.body}, status: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint('error deleting peer => ${e.toString()}');
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> markPeerAsAlive(
      String? firebaseToken, String? sdkApiKey,
      {peerId, peerUrl}) async {
    var peerUlr = peerUrl;
    Map<String, String> header = await getHeaders(firebaseToken, sdkApiKey);

    Map<String, dynamic> body = {
      "peerId": peerId,
    };

    try {
      final response = await http.post(
          Uri.parse("${peerUlr}peer/markPeerAsAlive"),
          body: json.encode(body),
          headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        json.decode(response.body);
        return {'isAlive': true, 'statusCode': response.statusCode};
      } else {
        if (getIsDebug) {
          logPrint(
              "Something went wrong marking peer as alive, response ${response.body}, status ${response.statusCode}");
        }

        return {'isAlive': false, 'statusCode': response.statusCode};
      }
    } catch (e) {
      if (getIsDebug) {
        logPrint('error marking peer as alive => ${e.toString()}');
      }
      return null;
    }
  }

  static Future<Map<String, String>> getHeaders(
      String? firebaseToken, String? sdkApiKey) async {
    final token = {
      AppConstants.LOGIN_TOKEN: firebaseToken,
      AppConstants.SDK_API_KEY: sdkApiKey,
      AppConstants.PEER_TOKEN: null
    };

    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
      "x-app-version": '2.0.0',
      'device-os': Platform.operatingSystem,
    };
    if ((token[AppConstants.LOGIN_TOKEN] != null &&
            token[AppConstants.LOGIN_TOKEN] != '') &&
        token[AppConstants.PEER_TOKEN] == null) {
      header[AppConstants.HEADER_AUTH_TOKEN] = token[AppConstants.LOGIN_TOKEN]!;
    }

    if (token[AppConstants.PEER_TOKEN] != null &&
        token[AppConstants.PEER_TOKEN] != '') {
      header[AppConstants.HEADER_PEER_TOKEN] = token[AppConstants.PEER_TOKEN]!;
    }

    if (token[AppConstants.SDK_API_KEY] != null &&
        token[AppConstants.SDK_API_KEY] != '') {
      header[AppConstants.SDK_API_KEY] = token[AppConstants.SDK_API_KEY]!;
      header['x-sdk-version'] = '1.1.45';
    }
    return header;
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (getIsDebug) {
        logPrint('hasInternetConnection: ${response.statusCode}');
      }
      return response.statusCode >= 200 || response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  static getUserId({String? currentUserId}) {
    return currentUserId;
  }
}
