import 'package:flutter_template/notifications/message.dart';

/// Handler for a single push notification [Message].
///
/// A handler does an action when a push notification arrives. For example:
/// - display a notification
/// - navigate to specific screen
/// - call another app component
///
/// Extend this class to implement handling for a single or multiple
/// message types ([Message.type]).
///
/// Register all message handlers in [DataNotificationManager].
abstract class MessageHandler<E extends Message> {
  Future<void> handleMessage(E message);
}
