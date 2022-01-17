import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/data_notification_manager.dart';

/// Manages local notifications and their details.
///
/// When used handle the click on the notifications here.
/// To obtain an instance use `serviceLocator.get<LocalNotificationsManager>()`
class LocalNotificationsManager {
  //TODO change this values before using them
  static const String CHANNEL_ID = 'foreground';
  static const String CHANNEL_NAME = 'channel name';
  static const String CHANNEL_DESCRIPTION = 'channel description';

  late final FlutterLocalNotificationsPlugin flNotification;
  final NotificationConsumer dataPayloadConsumer;
  final InitializationSettings initializationSettings;

  /// Makes sure that initialization is called once.
  bool isInitialized = false;

  LocalNotificationsManager(
      this.initializationSettings, this.dataPayloadConsumer) {
    this.flNotification = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    if (isInitialized) {
      Log.d('LocalNotificationsService - Initialize: Aborting,'
          ' already initialized.');
      return;
    }
    await flNotification.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //TODO use the data notification manager.
      Log.d('LocalNotificationsManager - foreground notification clicked');
    });
    isInitialized = true;
  }

  /// Displays push notification for android platform.
  void displayAndroidNotification(RemoteMessage message) async {
    if (!Platform.isAndroid) {
      return;
    }

    if (message.notification != null) {
      flNotification.show(0, message.notification!.title,
          message.notification!.body, _buildAndroidNotificationDetails());
    } else {
      Log.d('LocalNotificationService - Android notification missed,'
          ' message.notification == nul');
    }
  }

  /// Builds notification details for android platform.
  NotificationDetails _buildAndroidNotificationDetails() {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      channelDescription: CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );
    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }
}
