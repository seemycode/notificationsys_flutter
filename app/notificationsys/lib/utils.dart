import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class Utils {
  /// GCP
  static const String GCP_PROJECT_NAME = 'gcp_project_name';

  /// GCP >> indicates the sa json file to authenticate to the remote server from client app
  static const String GCP_SA_FILE_FOR_CLIENT = 'gcp_sa_key_filename';

  static Future<Map> readEnvData() async {
    late String envJson;
    envJson = await rootBundle.loadString('keys/env.json');
    var map = json.decode(envJson) as Map;
    return map;
  }

  static getPlatform() {
    var platform = 'undefined';
    if (kIsWeb) {
      return 'web';
    } else {
      if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        platform = 'other';
      }
    }
    return platform;
  }

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceIdentifier = "";

    try {
      if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceIdentifier = webInfo.vendor! +
            webInfo.userAgent! +
            webInfo.hardwareConcurrency.toString();
      } else {
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
          deviceIdentifier = androidInfo.androidId!;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
          deviceIdentifier = iosInfo.identifierForVendor!;
        } else if (Platform.isLinux) {
          LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
          deviceIdentifier = linuxInfo.machineId!;
        }
      }
    } on PlatformException {
      return 'Error trying to get device id';
    }

    return deviceIdentifier;
  }
}
