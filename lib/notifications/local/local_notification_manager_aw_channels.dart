import 'package:flutter_template/notifications/local/android_notification_channels.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

extension NotificationChannelsMethodsAw on AndroidNotificationChannels {
  static List<NotificationChannel> allChannels() => _channels.values.toList();

  NotificationChannel channel() => _channels[this]!;
}

//todo map this to android_notification_channels

final Map<AndroidNotificationChannels, NotificationChannel> _channels = {
  // A
  AndroidNotificationChannels.A: NotificationChannel(
    channelKey: AndroidNotificationChannels.A.key,
    channelName: AndroidNotificationChannels.A.visibleName,
    channelDescription: AndroidNotificationChannels.A.visibleName,
    importance: NotificationImportance.Max,
    locked: false,
    channelShowBadge: false,
    enableVibration: true,
    enableLights: true,
    playSound: true,
    soundSource: 'resource://raw/call',
  ),
  // B
  AndroidNotificationChannels.B: NotificationChannel(
    channelKey: AndroidNotificationChannels.B.key,
    channelName: AndroidNotificationChannels.B.visibleName,
    channelDescription: AndroidNotificationChannels.B.visibleName,
    importance: NotificationImportance.High,
    channelShowBadge: false,
  ),
};
