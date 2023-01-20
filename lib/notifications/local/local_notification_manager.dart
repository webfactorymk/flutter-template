import 'dart:ui';

import 'package:flutter_template/notifications/data/model/message.dart' as model;
import 'package:flutter_template/notifications/local/android_notification_channels.dart';
import 'package:flutter_template/notifications/local/android_notification_details.dart';

import 'local_notification_manager_aw_adapter.dart';

/// Manages local notifications and their details.
///
/// When used it should handle the click on the notifications too.
///
/// To obtain an instance use `serviceLocator.get<LocalNotificationsManager>()`
abstract class LocalNotificationsManager {
  factory LocalNotificationsManager.create() =>
      LocalNotificationsManagerAwAdapter.create();

  /// Performs initial initialization at app start
  Future<void> init();

  /// Request user permission
  Future<bool> requestUserPermission();

  /// Displays push notification on both android and iOS
  Future<void> displayLocalNotification(
    int notificationId,
    String? title,
    String? body,
    AndroidNotificationDetails? notificationDetails, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  });

  /// Displays push notification on the android platform only
  void displayAndroidNotification(
    int notificationId,
    String? title,
    String? body,
    AndroidNotificationDetails notificationDetails, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  });

  /// Displays push notification on the iOS platform only
  void displayIOSNotification(
    int id,
    String? title,
    String? body, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  });

  /// Cancels a notification with the specified id
  void cancelNotificationId(int notificationId);

  /// Cancels all notifications from specific channel
  ///
  /// Works only on Android
  Future<void> cancelAllNotificationsFromChannel(
      AndroidNotificationChannels channel);

  /// Cancels all notifications
  void cancelAllNotifications();
}

class NotificationButton {
  final String key;
  final String label;
  final bool? showInCompactView;
  final bool isDangerousOption;
  final bool shouldOpenApp;
  final Color? color;

  NotificationButton({
    required this.key,
    required this.label,
    this.showInCompactView,
    this.shouldOpenApp = true,
    this.isDangerousOption = false,
    this.color,
  });
}
