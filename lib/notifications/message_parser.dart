import 'package:flutter_template/notifications/message.dart';
import 'package:flutter_template/notifications/notifications_manager.dart';

/// Parses remote notification data to a [Message] or a subtype.
///
/// Extend this class to implement message parsing specific to your remote data.
/// Register a message parser in [NotificationsManager].
abstract class MessageParser {
  Message parseMessage(dynamic remoteData);
}

/// Message parser that expects a [Message] as param and just forwards it.
class StubMessageParser implements MessageParser {
  @override
  Message parseMessage(remoteData) => remoteData as Message;
}
