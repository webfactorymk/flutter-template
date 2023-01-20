import 'package:flutter_template/notifications/data/model/message.dart';

/// Filters a remote [Message] to not be handled by [MessageHandler].
///
/// Register a global message filter in [DataNotificationManager].
abstract class MessageFilter {
  /// Return false to discard the message, true otherwise.
  Future<bool> filterMessage(Message message);
}

/// Filters all notifications if there is logged in user only.
class LoggedInUserOnlyFilter implements MessageFilter {
  late final Future<bool> Function() isUserLoggedIn;

  @override
  Future<bool> filterMessage(Message _) => isUserLoggedIn();
}

/// You shall not pass filter.
class DiscardAllFilter implements MessageFilter {
  @override
  Future<bool> filterMessage(Message _) async => false;
}
