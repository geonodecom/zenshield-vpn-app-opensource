import 'package:dart_peer_repo/src/shared/global.dart';

class Settings {
  // Singleton instance
  static final Settings _instance = Settings._internal();

  // Private constructor
  Settings._internal();

  // Factory constructor to return the singleton instance
  factory Settings() => _instance;

  // Settings map
  Map<String, dynamic> settings = {
    'is_reusable_socket_mode_on': true,
    'is_stand_by_socket_mode_on': true,
    'number_of_stand_by_sockets': 2,
    'launch_stand_by_socket_on_new_request': false,
  };

  // Helper method to convert to boolean
  bool _convert(dynamic value) {
    return value != null && int.tryParse(value.toString()) == 1;
  }

  // Setter for updating settings
  void set({
    required dynamic reusableMode,
    required dynamic standByMode,
    required dynamic numberOfStandBySockets,
    required dynamic launchStandBySocketOnNewRequest,
  }) {
    if (getIsDebug) {
      logPrint(
          'Settings -> set, reusableMode: $reusableMode, standByMode: $standByMode, numberOfStandBySockets: $numberOfStandBySockets, launchStandBySocketOnNewRequest: $launchStandBySocketOnNewRequest');
    }
    settings['is_reusable_socket_mode_on'] = _convert(reusableMode);
    settings['is_stand_by_socket_mode_on'] = _convert(standByMode);
    settings['launch_stand_by_socket_on_new_request'] =
        _convert(launchStandBySocketOnNewRequest);
    settings['number_of_stand_by_sockets'] =
        int.tryParse(numberOfStandBySockets.toString()) ?? 2;
  }

  // Getter for checking a specific setting
  bool get shouldOpenStandBySocketOnNewRequest {
    return settings['launch_stand_by_socket_on_new_request'] as bool;
  }
}

// Access the global settings instance
final globalSettings = Settings();
