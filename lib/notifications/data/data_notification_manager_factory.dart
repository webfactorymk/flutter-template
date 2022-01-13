import 'package:flutter_template/notifications/fcm/fcm_remote_message_parser.dart';
import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_filter.dart';
import 'package:flutter_template/notifications/data/message_handler.dart';
import 'package:flutter_template/notifications/data/data_notification_manager.dart';

class DataNotificationsManagerFactory {
  static DataNotificationManager create({
    MessageFilter? messageFilter,
    MessageHandler<Message>? globalPreMessageHandler,
    MessageHandler<Message>? globalPostMessageHandler,
  }) {
    return DataNotificationManager(
      messageParser: FcmRemoteMessageParser() //todo add a message parsers
      // ..registerMessageParser(
      //   parser: parser,
      //   forMessageTypes: forMessageTypes,
      // ),
      ,
      messageFilter: messageFilter,
      globalPreMessageHandler: globalPreMessageHandler,
      globalPostMessageHandler: globalPostMessageHandler,
    );
    //todo register message action handlers
    //..registerMessageHandler(handler: handler, forMessageTypes: []);
  }
}
