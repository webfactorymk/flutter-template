import 'dart:async';

import 'package:flutter_template/log/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_storage/storage.dart';

const String pushTokenKey = 'firebase-device-token';

/// Manages the latest saved device token for push notifications
class FirebaseTokenStorage implements Storage<String> {
  @override
  Future<void> delete() async {
    Logger.d('FirebaseDeviceTokenStorage - remove token');
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
    Logger.d('FirebaseDeviceTokenStorage - save token: $token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pushTokenKey, token);
    return token;
  }
}
