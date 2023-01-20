
import 'package:flutter_template/notifications/data/model/message.dart';
import 'package:flutter_template/notifications/data/model/message_type.dart';

/// Parses notification data to a [Message] or a subtype.
///
/// Extend this class to implement message parsing specific to your notif. data.
/// Register a message parser in [DataNotificationManager].
abstract class MessageParser {
  Message parseMessage(dynamic messageObject);
}

/// Message parser that expects a [Message] as param and just forwards it.
class StubMessageParser implements MessageParser {
  @override
  Message parseMessage(messageObject) => messageObject as Message;
}

/// Determines the [Message.type] from raw notification data.
typedef MessageType TypeFromRawData(dynamic rawData);

/// Message parser that will use a separate parser for each message type.
class MultiMessageParser implements MessageParser {
  final Map<MessageType, MessageParser> _messageParserForType = Map();
  final TypeFromRawData _typeFromRawData;
  MessageParser? _defaultMessageParser;

  MultiMessageParser(this._typeFromRawData);

  /// Registers a [MessageParser] for a specific [Message.type]
  void registerMessageParser({
    required MessageParser parser,
    required Iterable<MessageType> forMessageTypes,
  }) {
    forMessageTypes.forEach((type) {
      _messageParserForType[type] = parser;
    });
  }

  /// Registers default [MessageParser] for any unregistered [Message.type]s
  void registerDefaultMessageParser(MessageParser defaultParser) {
    _defaultMessageParser = defaultParser;
  }

  /// Override this method to provide handling for unknown types.
  Message onUnknownType(String? type, dynamic messageObject) {
    if (_defaultMessageParser != null) {
      return _defaultMessageParser!.parseMessage(messageObject);
    } else {
      throw Exception('NotificationsManager - '
          'Message type does not have a parser: $type; Default parser is null');
    }
  }

  @override
  Message parseMessage(dynamic messageObject) {
    final type = _typeFromRawData(messageObject);
    final parser = _messageParserForType[type];
    if (parser != null) {
      return parser.parseMessage(messageObject);
    } else {
      return onUnknownType(type.getKey(), messageObject);
    }
  }
}
