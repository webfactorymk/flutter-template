import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/notifications/message.dart';
import 'package:flutter_template/notifications/message_parser.dart';

class FcmBaseMessage extends Message {
  final RemoteMessage remoteMessage;

  FcmBaseMessage(this.remoteMessage) : super(remoteMessage.messageType!);
}

class FcmRemoteMessageParser implements MessageParser {
  @override
  Message parseMessage(dynamic remoteData) => FcmBaseMessage(remoteData);
}
