import 'package:zenshield/core/api/endpoints/api_configuration.dart';

sealed class Api {
  static String _host = '';
  static ApiEndpoints _endpoints = ApiEndpoints.defaults();

  static String get host => _host;
  static ApiEndpoints get endpoints => _endpoints;

  static void setConfiguration(ApiConfiguration config) {
    _host = config.host;
    _endpoints = ApiEndpoints.fromMap(config.endpoints);
  }

  // ignore: use_setters_to_change_properties
  static void setHost(String value) {
    _host = value;
  }

  String get endpoint => 'https://$_host';
}
