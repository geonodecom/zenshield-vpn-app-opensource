import 'dart:convert';

import 'package:talker_flutter/talker_flutter.dart';

extension TalkerDataInterfaceListExt on List<TalkerData> {
  String toJsonString() {
    return jsonEncode(map((data) => data.toJson()).toList());
  }
}

extension TalkerDataJsonExt on TalkerData {
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'key': key,
      'logLevel': logLevel?.toString(),
      'exception': exception?.toString(),
      'error': error?.toString(),
      'title': title,
      'stackTrace': stackTrace?.toString(),
      'time': time.toIso8601String(),
      'pen': pen?.toString(),
    };
  }
}
