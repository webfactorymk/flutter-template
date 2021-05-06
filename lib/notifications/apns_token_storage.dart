import 'dart:async';

import 'package:flutter_template/log/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_storage/storage.dart';

const String pushTokenKey = 'apns-device-token';

/// Manages the latest saved apns device token for push notifications
class APNSTokenStorage implements Storage<String> {
  @override
  Future<void> delete() async {
    Logger.d('APNSDeviceTokenStorage - remove token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(pushTokenKey);
  }

  @override
  Future<String?> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(pushTokenKey);
  }

  @override
  Future<String> save(String token) async {
    Logger.d('APNSDeviceTokenStorage - save token: $token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pushTokenKey, token);
    return token;
  }
}
