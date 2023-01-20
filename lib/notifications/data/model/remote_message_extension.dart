import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/notifications/data/parser/base_message_type_parser.dart';

/// Helper methods that are missing from FCM's [RemoteMessage]
extension RemoteMessageExtension on RemoteMessage? {
  /// Checks if the remote message has a type field
  bool hasType() => this?.data.containsKey(TYPE_DATA_KEY) ?? false;

  String print() {
    return 'RemoteMessage{'
        'senderId: ${this?.senderId}, '
        'category: ${this?.category}, '
        'collapseKey: ${this?.collapseKey}, '
        'contentAvailable: ${this?.contentAvailable}, '
        'manager: ${this?.data}, '
        'from: ${this?.from}, '
        'messageId: ${this?.messageId}, '
        'messageType: ${this?.messageType}, '
        'notification: ${this?.notification.print()}, '
        'sentTime: ${this?.sentTime}, '
        'threadId: ${this?.threadId}, '
        'ttl: ${this?.ttl}'
        '}';
  }
}

/// Helper methods that are missing from FCM's [RemoteNotification]
extension RemoteNotificationExtension on RemoteNotification? {
  String print() {
    return 'RemoteNotification{'
        'title: ${this?.title}, '
        'body: ${this?.body}, '
        'android: ${this?.android.print()}, '
        'apple: ${this?.apple.print()}'
        '}';
  }
}

/// Helper methods that are missing from FCM's [AndroidNotification]
extension AndroidNotificationExtension on AndroidNotification? {
  String print() {
    return 'AndroidNotification{'
        'channelId: ${this?.channelId}, '
        'priority: ${this?.priority}, '
        'visibility: ${this?.visibility.name}, '
        'tag: ${this?.tag}'
        '}';
  }
}

/// Helper methods that are missing from FCM's [AppleNotification]
extension AppleNotificationExtension on AppleNotification? {
  String print() {
    return 'AppleNotification{${this?.toMap()}}';
  }
}
