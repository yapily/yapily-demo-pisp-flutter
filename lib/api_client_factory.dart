import 'dart:async';
import 'yapily_config.dart';
import 'package:yapily_sdk/api.dart';

class ApiClientFactory {

  static Future<ApiClient> create() {
    return ConfigLoader.loadAsync().then( (yapilyConfig) {
      var httpBasicAuth = HttpBasicAuth.setCredentials(username: yapilyConfig.key, password: yapilyConfig.secret);
      var apiClient = ApiClient.withAuth(httpBasicAuth);
      return apiClient;
    });
  }

}