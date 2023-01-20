import 'dart:io';

import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/data_notification_consumer.dart';
import 'package:flutter_template/notifications/data/model/message.dart' as model;
import 'package:flutter_template/notifications/data/model/message_serializer.dart';
import 'package:flutter_template/notifications/local/android_notification_channels.dart';
import 'package:flutter_template/notifications/local/android_notification_details.dart';
import 'package:flutter_template/notifications/local/local_notification_manager_aw_channels.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

import 'local_notification_manager.dart';

/// Notification button click entry method
@pragma("vm:entry-point")
Future<void> onNotificationAction(ReceivedAction notificationAction) async {
  if (notificationAction.buttonKeyPressed == 'dismiss') {
    Log.d('LocalNotificationsManager - Notification action dismiss');
  } else if (notificationAction.payload?['data'] != null) {
    Log.d('LocalNotificationsManager - Notification clicked');
    await _onNotificationClick(
        notificationAction, notificationAction.buttonKeyPressed);
  } else {
    Log.w(
        'LocalNotificationsManager - Local message w/o payload $notificationAction');
  }
}

/// Handler for notification click on either foreground or terminated app state
@pragma("vm:entry-point")
Future<void> _onNotificationClick(
    ReceivedNotification notification, String action) async {
  final serializedMessage = notification.payload!['data'];
  final message = SerializableMessage.deserialize(serializedMessage);

  DataNotificationConsumer notificationConsumer;
  try {
    await serviceLocator.allReady(timeout: Duration(seconds: 10));
    notificationConsumer = serviceLocator.get<DataNotificationConsumer>();
  } catch (exp) {
    print('LocalNotificationsManagerAwAdapter - '
        'Error: App dependencies not initialized');
    return;
  }
  await notificationConsumer.onAppOpenedFromMessage(message, action);
}

/// `LocalNotificationsManager` adapter using `awesome_notifications`
///
/// See https://pub.dev/packages/awesome_notifications
///
/// To obtain an instance use `serviceLocator.get<LocalNotificationsManager>()`
class LocalNotificationsManagerAwAdapter implements LocalNotificationsManager {
  late final AwesomeNotifications _awNotification;

  bool isInitialized = false;

  LocalNotificationsManagerAwAdapter(this._awNotification);

  factory LocalNotificationsManagerAwAdapter.create() =>
      LocalNotificationsManagerAwAdapter(AwesomeNotifications());

  @override
  Future<void> init() async {
    if (isInitialized) {
      Log.d('LocalNotificationsManager - Initialize: Already initialized.');
      return;
    }

    await _awNotification.initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/fcm_notification_icon',
      NotificationChannelsMethodsAw.allChannels(),
      debug: kDebugMode,
    );

    _awNotification.setListeners(onActionReceivedMethod: onNotificationAction);

    isInitialized = true;
  }

  @override
  Future<bool> requestUserPermission() async {
    //not called because Firebase requests this permission

    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      return true;
    }
  }

  @override
  Future<void> displayLocalNotification(
    int notificationId,
    String? title,
    String? body,
    AndroidNotificationDetails? notificationDetails, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  }) async {
    _awNotification.createNotification(
      content: NotificationContent(
          id: notificationId,
          channelKey: notificationDetails?.channel.key ?? '',
          title: title,
          body: body,
          wakeUpScreen: notificationDetails?.wakeUpScreen ?? false,
          fullScreenIntent: notificationDetails?.fullScreenIntent ?? false,
          icon: notificationDetails?.iconResId != null
              ? 'resource://drawable/${notificationDetails!.iconResId}'
              : null,
          color: notificationDetails?.color,
          category:
              _notificationCategoryFromString(notificationDetails?.category),
          displayOnForeground: true,
          displayOnBackground: true,
          payload:
              payload != null ? {'data': payload.serialize() ?? ''} : null),
      actionButtons: notificationButtonsAdapter(buttons),
    );
  }

  @override
  void displayAndroidNotification(
    int notificationId,
    String? title,
    String? body,
    AndroidNotificationDetails notificationDetails, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  }) async {
    if (Platform.isAndroid) {
      displayLocalNotification(notificationId, title, body, notificationDetails,
          payload: payload, buttons: buttons);
    }
  }

  @override
  void displayIOSNotification(
    int notificationId,
    String? title,
    String? body, {
    model.Message? payload,
    List<NotificationButton>? buttons,
  }) async {
    if (Platform.isIOS) {
      displayLocalNotification(notificationId, title, body, null,
          payload: payload, buttons: buttons);
    }
  }

  @override
  void cancelNotificationId(int notificationId) {
    Log.d('LocalNotificationManager - Canceling notification: $notificationId');
    _awNotification.cancel(notificationId);
  }

  @override
  Future<void> cancelAllNotificationsFromChannel(
      AndroidNotificationChannels channel) async {
    _awNotification.cancelNotificationsByChannelKey(channel.key);
  }

  @override
  void cancelAllNotifications() {
    Log.d('LocalNotificationManager - Canceling all notifications');
    _awNotification.cancelAll();
  }

  List<NotificationActionButton>? notificationButtonsAdapter(
      List<NotificationButton>? buttons) {
    if (buttons == null) {
      return null;
    }
    return buttons
        //icons are only allowed for media types
        .map((coreButton) => NotificationActionButton(
              key: coreButton.key,
              label: coreButton.label,
              color: coreButton.color,
              showInCompactView: coreButton.showInCompactView ?? false,
              isDangerousOption: coreButton.isDangerousOption,
              actionType: coreButton.shouldOpenApp
                  ? ActionType.Default
                  : ActionType.DismissAction,
            ))
        .toList();
  }

  NotificationCategory? _notificationCategoryFromString(String? category) {
    if (category == null) {
      return null;
    }
    switch (category.toLowerCase()) {
      case 'alarm':
        return NotificationCategory.Alarm;
      case 'call':
        return NotificationCategory.Call;
      case 'email':
        return NotificationCategory.Email;
      case 'error':
        return NotificationCategory.Error;
      case 'event':
        return NotificationCategory.Event;
      case 'localSharing':
        return NotificationCategory.LocalSharing;
      case 'message':
        return NotificationCategory.Message;
      case 'missedCall':
        return NotificationCategory.MissedCall;
      case 'navigation':
        return NotificationCategory.Navigation;
      case 'progress':
        return NotificationCategory.Progress;
      case 'promo':
        return NotificationCategory.Promo;
      case 'recommendation':
        return NotificationCategory.Recommendation;
      case 'reminder':
        return NotificationCategory.Reminder;
      case 'service':
        return NotificationCategory.Service;
      case 'social':
        return NotificationCategory.Social;
      case 'status':
        return NotificationCategory.Status;
      case 'stopWatch':
        return NotificationCategory.StopWatch;
      case 'transport':
        return NotificationCategory.Transport;
      case 'workout':
        return NotificationCategory.Workout;
    }
    Log.w('LocalNotificationsManagerAwAdapter - '
        'Unrecognized category: $category');
    return null;
  }
}
