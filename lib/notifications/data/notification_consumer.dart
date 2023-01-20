/// Consumes new push notifications as they arrive
abstract class NotificationConsumer {
  /// Called when a new push notification arrives and app is in foreground
  ///
  /// Returns `true` if the message was handled successfully, `false` otherwise.
  Future<bool> onNotificationMessageForeground(dynamic remoteRawData);

  /// Called when a new push notification arrives and app is in background or terminated
  ///
  /// Returns `true` if the event was handled successfully, `false` otherwise.
  /// Please note that this code will run on a separate isolate on Android platform.
  Future<bool> onNotificationMessageBackground(dynamic remoteRawData);

  /// Called when the app is opened from a push notification,
  /// regardless if in foreground or terminated
  ///
  /// If the app is opened from notification action the action parameter will contain the action name
  ///
  /// Returns `true` if the event was handled successfully, `false` otherwise.
  Future<bool> onAppOpenedFromMessage(
    dynamic remoteRawData,
    String? action,
  );
}
