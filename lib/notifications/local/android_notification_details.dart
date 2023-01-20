import 'dart:ui';

import 'package:flutter_template/notifications/data/model/message_type.dart';
import 'package:flutter_template/notifications/local/android_notification_channels.dart';

/// Contains notification details specific to Android
class AndroidNotificationDetails {
  final AndroidNotificationChannels channel;
  final String? iconResId;
  final int importance;
  final int priority;
  final Color? color;
  final String? category;
  final bool fullScreenIntent;
  final bool wakeUpScreen;

  const AndroidNotificationDetails(
    this.channel, {
    this.iconResId,
    this.importance = 3,
    this.priority = 0,
    this.color,
    this.category,
    this.fullScreenIntent = false,
    this.wakeUpScreen = false,
  });
}

//todo modify this too

final typeANotificationDetails = AndroidNotificationDetails(
  AndroidNotificationChannels.A,
  category: 'call',
  importance: 5, //max
  priority: 2, //max
  wakeUpScreen: true,
  fullScreenIntent: false, //if true is indistinguishable from actual taps
);

final infoNotificationDetails = AndroidNotificationDetails(
  AndroidNotificationChannels.B,
  priority: 1, //high
);

AndroidNotificationDetails getNotifDetailsForMessageType(MessageType type) {
  switch (type) {
    case MessageType.A:
    case MessageType.B:
      return typeANotificationDetails;
    case MessageType.UNKNOWN:
      return infoNotificationDetails;
  }
}
