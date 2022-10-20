import 'package:flutter_template/notifications/data/message.dart';

/// Parses remote notification data to a [Message] or a subtype.
///
/// Extend this class to implement message parsing specific to your remote data.
/// Register a message parser in [DataNotificationManager].
abstract class MessageParser {
  Message parseMessage(dynamic remoteData);
}

/// Message parser that expects a [Message] as param and just forwards it.
class StubMessageParser implements MessageParser {
  @override
  Message parseMessage(remoteData) => remoteData as Message;
}

/// Determines the [Message.type] from raw remote notification data.
typedef String TypeFromRawMessage(dynamic remoteData);

/// Message parser that will use a separate parser for each message type.
class MultiMessageParser implements MessageParser {
  final Map<String, MessageParser> _messageParserForType = Map();
  final TypeFromRawMessage _typeFromRawMessage;
  MessageParser? _defaultMessageParser;

  MultiMessageParser(this._typeFromRawMessage);

  /// Registers a [MessageParser] for a specific [Message.type]
  void registerMessageParser({
    required MessageParser parser,
    required Iterable<String> forMessageTypes,
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
  Message onUnknownType(String? type, dynamic remoteData) {
    if (_defaultMessageParser != null) {
      return _defaultMessageParser!.parseMessage(remoteData);
    } else {
      throw Exception('NotificationsManager - '
          'Message type does not have a parser: $type; Default parser is null');
    }
  }

  @override
  Message parseMessage(dynamic remoteData) {
    final type = _typeFromRawMessage(remoteData);
    final parser = _messageParserForType[type];
    if (parser == null) {
      return onUnknownType(type, remoteData);
    }
    return parser.parseMessage(remoteData);
  }
}
