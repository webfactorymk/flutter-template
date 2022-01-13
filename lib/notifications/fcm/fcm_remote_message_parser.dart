import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/notifications/fcm/fcm_remote_message.dart';
import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_parser.dart';

class FcmRemoteMessageParser extends MultiMessageParser {
  @override
  String getTypeFromRawMessage(dynamic remoteData) =>
      (remoteData as RemoteMessage).messageType!;

  @override
  Message onUnknownType(String? type, dynamic remoteData) =>
      FcmBaseMessage(remoteData);
}
