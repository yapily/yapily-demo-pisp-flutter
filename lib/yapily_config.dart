import 'dart:convert' show json;
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class ConfigLoader {

  static Future<YapilyConfig> loadAsync() {
    return rootBundle.loadStructuredData<YapilyConfig>("yapily-assets/yapily-config.json",
            (jsonStr) async {
          final yapilyConfig = YapilyConfig.fromJson(json.decode(jsonStr));
          return yapilyConfig;
        });
  }

}

class YapilyConfig {

  final String key;
  final String secret;
  final String userName;
  final String callback;
  final String basePath;

  YapilyConfig({this.key = "", this.secret = "", this.userName = "", this.callback = "", this.basePath = ""});

  factory YapilyConfig.fromJson(Map<String,dynamic> jsonMap) {
    return new YapilyConfig(key: jsonMap["key"], secret: jsonMap["secret"], userName: jsonMap["userName"], callback: jsonMap["callback"]);
  }
}
