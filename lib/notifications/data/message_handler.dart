import 'package:flutter_template/notifications/data/message.dart';

/// Handler for a single push notification [Message].
///
/// A handler does an action when a push notification arrives. For example:
/// - display a notification
/// - navigate to specific screen
/// - call another app component
/// - make a network call
///
/// Extend this class to implement handling for a single or multiple
/// message types ([Message.type]).
///
/// Mind that the app could be terminated or in the background.
/// See https://firebase.flutter.dev/docs/messaging/usage/#background-messages
///
/// Register all message handlers in [DataNotificationManager].
abstract class MessageHandler<E extends Message> {
  Future<void> handleMessage(E message);

  Future<void> handleAppOpenedFromMessage(E message);
}
