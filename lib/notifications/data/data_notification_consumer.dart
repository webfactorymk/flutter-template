import 'package:flutter_template/notifications/data/filter/message_filter.dart';
import 'package:flutter_template/notifications/data/handler/message_handler.dart';
import 'package:flutter_template/notifications/data/model/message.dart';
import 'package:flutter_template/notifications/data/model/message_type.dart';
import 'package:flutter_template/notifications/data/parser/message_parser.dart';

import 'notification_consumer.dart';

/// Data Notifications Consumer
///
/// Data remote messages, besides the UI information, hold data payload
/// with additional information. Usually a key value map.
///
/// This component will:
///  - await remote message on [NotificationConsumer.onNotificationMessageForeground]
///  - parse the remote messages to [Message] or a subtype using a [MessageParser]
///  - call a [MessageHandler] registered for the specific notification type
///    to perform an action
///
/// Usage:
/// 1. Create a single instance and register a [MessageParser] and
/// add [MessageHandler]s for each action that happens after a notification
/// of specific type arrives - make network call, call a service, etc.
///
/// 2. This component implements [NotificationConsumer]. Pass this instance
/// to a concrete implementation that listens for push notifications that will
/// call [onNotificationMessageForeground] each time a new push notification arrives.
/// Example: FirebaseMessaging.
///
/// 3. Optionally, add message filter [filterMessage] and
/// global message handlers that get called before and after a notification
/// is handled by the specific type [MessageHandler].
///
/// <i>
/// When handling remote messages mind that the app could be terminated or
/// in the background where OS restrictions might not allow some actions.
/// Limit tasks to 30 seconds and (on Android) avoid UI modifications since
/// the process will run in a separate isolate.
///
/// See https://firebase.flutter.dev/docs/messaging/usage/#background-messages
/// </i>
///
/// <br>
/// To obtain an instance use `serviceLocator.get<DataNotificationConsumer>()`
class DataNotificationConsumer implements NotificationConsumer {
  /// Message handlers for specific message types
  final Map<MessageType, MessageHandler<dynamic>> _messageHandlerForType =
      Map();

  /// Parses incoming raw message data into a [Message] or a subtype
  final MessageParser messageParser;

  /// Global message handler called before a notification is handled. Optional.
  final MessageHandler<Message>? globalPreMessageHandler;

  /// Global message handler called after a notification is handled. Optional.
  final MessageHandler<Message>? globalPostMessageHandler;

  /// Global message filter. Optional.
  final MessageFilter? messageFilter;

  DataNotificationConsumer({
    required this.messageParser,
    this.globalPreMessageHandler,
    this.globalPostMessageHandler,
    this.messageFilter,
  });

  /// Registers a [MessageHandler] for a specific [Message.type]
  void registerMessageHandler({
    required MessageHandler<Message> handler,
    required Iterable<MessageType> forMessageTypes,
  }) {
    forMessageTypes.forEach((type) {
      _messageHandlerForType[type] = handler;
    });
  }

  /// Called when a new push notification arrives and app is in foreground
  ///
  /// Returns `true` if the message was handled successfully, `false` otherwise.
  @override
  Future<bool> onNotificationMessageForeground(dynamic remoteRawData) =>
      _handleNotificationMessage(
        remoteRawData,
        appOpenedFromMessage: false,
        appIsInForeground: true,
      );

  /// Called when a new push notification arrives.
  ///
  /// Returns `true` if the message was handled successfully, `false` otherwise.
  /// Note: This code runs on different isolate on Android
  @override
  Future<bool> onNotificationMessageBackground(dynamic remoteRawData) =>
      _handleNotificationMessage(
        remoteRawData,
        appOpenedFromMessage: false,
        appIsInForeground: false,
      );

  @override
  Future<bool> onAppOpenedFromMessage(dynamic remoteRawData, String? action) =>
      _handleNotificationMessage(remoteRawData,
          appOpenedFromMessage: true, appIsInForeground: true, action: action);

  Future<bool> _handleNotificationMessage(
    dynamic remoteRawData, {
    required bool appOpenedFromMessage,
    required bool appIsInForeground,
    String? action,
  }) async {
    late dynamic message;
    try {
      message = messageParser.parseMessage(remoteRawData);
      print('NotificationConsumer - '
          '${appOpenedFromMessage ? 'App opened from' : 'New'} '
          'message: $message');
    } catch (exp) {
      print(
          'NotificationConsumer - Message could not be parsed: $remoteRawData');
      return false;
    }

    if (!_hasHandlerForType(message.type)) {
      print(
          'NotificationConsumer - Message type does not have a handler: ${message.type}');
      return false;
    }

    if (!(await messageFilter?.filterMessage(message) ?? true)) {
      print('NotificationConsumer - Message did not pass filter: $message');
      return false;
    }

    try {
      await Future.forEach<MessageHandler?>(
          [
            globalPreMessageHandler,
            _getHandlerForType(message.type),
            globalPostMessageHandler,
          ].cast(), (messageHandler) {
        if (appOpenedFromMessage) {
          return messageHandler?.handleAppOpenedFromMessage(message, action);
        } else {
          if (appIsInForeground) {
            return messageHandler?.handleMessage(message);
          } else {
            return messageHandler?.handleBackgroundMessage(message);
          }
        }
      });
      return true;
    } catch (error) {
      print('NotificationConsumer - Error handling '
          'message: $message, '
          'error: $error');
      return false;
    }
  }

  bool _hasHandlerForType(MessageType messageType) =>
      _messageHandlerForType.containsKey(messageType);

  MessageHandler<dynamic> _getHandlerForType(MessageType messageType) =>
      _messageHandlerForType[messageType]!;
}
