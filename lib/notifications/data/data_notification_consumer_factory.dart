import 'package:flutter_template/notifications/data/data_notification_consumer.dart';
import 'package:flutter_template/notifications/data/filter/message_filter.dart';
import 'package:flutter_template/notifications/data/handler/message_handler.dart';
import 'package:flutter_template/notifications/data/model/message.dart';
import 'package:flutter_template/notifications/data/parser/base_message_type_parser.dart';
import 'package:flutter_template/notifications/data/parser/message_parser.dart';
import 'package:flutter_template/notifications/local/local_notification_manager.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';

class DataNotificationConsumerFactory {
  static DataNotificationConsumer create({
    MessageFilter? messageFilter,
    MessageHandler<Message>? globalPreMessageHandler,
    MessageHandler<Message>? globalPostMessageHandler,
  }) {
    return DataNotificationConsumer(
      messageParser: MultiMessageParser(getTypeFromRawData)
        // todo register message parsers
        // ..registerMessageParser(
        //   parser: ATypeParser(),
        //   forMessageTypes: [MessageType.A],
        // )
        // ..registerMessageParser(
        //   parser: BTypeParser(),
        //   forMessageTypes: [MessageType.B],
        // )
        ..registerDefaultMessageParser(BaseMessageTypeParser()),
      messageFilter: messageFilter,
      globalPreMessageHandler: globalPreMessageHandler,
      globalPostMessageHandler: globalPostMessageHandler,
    );
  }

  static void registerNewMessageHandlers(
    DataNotificationConsumer dataNotificationConsumer,
    LocalNotificationsManager localNotificationsManager,
    PlatformComm platformComm,
  ) {
    // todo register message type handlers
    // dataNotificationConsumer
    //   ..registerMessageHandler(
    //     handler: AHandler(
    //       localNotificationsManager: localNotificationsManager,
    //     ),
    //     forMessageTypes: [
    //       MessageType.A,
    //     ],
    //   )
    //   ..registerMessageHandler(
    //     handler: BHandler(),
    //     forMessageTypes: [
    //       MessageType.B,
    //       MessageType.B,
    //       MessageType.B,
    //     ],
    //   );
  }
}
