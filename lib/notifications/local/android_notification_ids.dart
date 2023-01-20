import 'package:flutter_template/notifications/data/model/message_type.dart';

//todo modify this

const TYPE_A_NOTIFICATION_ID = 111111;
const TYPE_B_NOTIFICATION_ID = 222222;
const TYPE_C_NOTIFICATION_ID = 333333;

int getMessageIdForType(MessageType type) {
  switch (type) {
    case MessageType.A:
      return TYPE_A_NOTIFICATION_ID;
    case MessageType.B:
      return TYPE_B_NOTIFICATION_ID;
    case MessageType.UNKNOWN:
      return DateTime.now().millisecondsSinceEpoch;
  }
}
