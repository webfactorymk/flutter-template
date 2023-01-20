import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/notifications/data/model/message.dart';
import 'package:flutter_template/notifications/data/model/message_type.dart';
import 'package:flutter_template/notifications/local/android_notification_ids.dart';

import 'message_parser.dart';

const String TYPE_DATA_KEY = 'type';
const String TITLE_KEY = 'title';
const String BODY_KEY = 'body';

/// Extracts [MessageType] from rawData in various forms:
/// - [Message]
/// - [RemoteMessage]
/// - [Map<String, dynamic>]
MessageType getTypeFromRawData(dynamic rawData) {
  if (rawData is Message) {
    return rawData.type;
  } else if (rawData is Map<String, dynamic>) {
    return getTypeFromMappedData(rawData);
  } else if (rawData is RemoteMessage) {
    return getTypeFromMappedData(rawData.data);
  } else {
    return MessageType.UNKNOWN;
  }
}

/// Extracts [MessageType] from [Map] data
MessageType getTypeFromMappedData(Map<String, dynamic> data) {
  return data.containsKey(TYPE_DATA_KEY)
      ? data[TYPE_DATA_KEY].toString().toMessageType()
      : MessageType.UNKNOWN;
}

/// [MessageParser] for both remote and local notification raw data
class BaseMessageTypeParser implements MessageParser {
  @override
  Message parseMessage(dynamic messageObject) {
    if (messageObject is Message) {
      return messageObject;
    } else if (messageObject is RemoteMessage) {
      return Message(
        type: getTypeFromMappedData(messageObject.data),
        messageId: messageObject.messageId,
        title: messageObject.notification?.title ?? messageObject.data[TITLE_KEY],
        body: messageObject.notification?.body ?? messageObject.data[BODY_KEY],
      );
    } else if (messageObject is Map<String, dynamic>) {
      final type = getTypeFromMappedData(messageObject);
      return Message(
        type: type,
        messageId: getMessageIdForType(type).toString(),
        title: messageObject[TITLE_KEY],
        body: messageObject[BODY_KEY],
      );
    } else {
      throw Exception('BaseMessageTypeParser - '
          'Message object not recognised: $messageObject');
    }
  }
}
