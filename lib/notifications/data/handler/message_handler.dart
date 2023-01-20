import 'package:flutter_template/notifications/data/model/message.dart';

/// Handler for a single push notification [Message].
///
/// A handler does an action when a push notification arrives. For example:
/// - display a notification
/// - navigate to specific screen
/// - call another app component
/// - make a network call
///
/// Extend this class to implement handling for a single or multiple
/// message types ([MessageType]).
///
/// Mind that the app could be terminated or in the background.
/// See https://firebase.flutter.dev/docs/messaging/usage/#background-messages
///
/// Register all message handlers in [DataNotificationConsumerFactory].
abstract class MessageHandler<E extends Message> {
  //Fixme the generic type is not propagated in data notification consumer

  /// Handle message while the app is in foreground
  Future<bool> handleMessage(E message);

  /// Handle message while the app is in background
  /// Mind that this runs on separate isolate on Android:
  /// - you can't do UI updates
  /// - you need to create all necessary components since the memory is not shared
  Future<bool> handleBackgroundMessage(E message);

  /// Handle app opened from message in any running or terminated state
  Future<bool> handleAppOpenedFromMessage(E message, String? action);
}
