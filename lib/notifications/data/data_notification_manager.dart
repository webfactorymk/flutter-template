import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_filter.dart';
import 'package:flutter_template/notifications/data/message_handler.dart';
import 'package:flutter_template/notifications/data/message_parser.dart';

/// Data Notifications Manager
///
/// Data remote messages, besides the UI information, hold data payload
/// with additional information. Usually a key value map.
///
/// This component will:
///  - await remote message on [NotificationConsumer.onNotificationMessage]
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
/// call [onNotificationMessage] each time a new push notification arrives.
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
/// To obtain an instance use `serviceLocator.get<NotificationsManager>()`
class DataNotificationManager implements NotificationConsumer {
  final Map<String, MessageHandler<Message>> _messageHandlerForType = Map();

  /// Parses incoming raw message data into a [Message] or a subtype
  final MessageParser messageParser;

  /// Global message handler called before a notification is handled. Optional.
  final MessageHandler<Message>? globalPreMessageHandler;

  /// Global message handler called after a notification is handled. Optional.
  final MessageHandler<Message>? globalPostMessageHandler;

  /// Global message filter. Optional.
  final MessageFilter? messageFilter;

  DataNotificationManager({
    required this.messageParser,
    this.globalPreMessageHandler,
    this.globalPostMessageHandler,
    this.messageFilter,
  });

  /// Registers a [MessageHandler] for a specific [Message.type]
  void registerMessageHandler({
    required MessageHandler<Message> handler,
    required Iterable<String> forMessageTypes,
  }) {
    forMessageTypes.forEach((type) {
      _messageHandlerForType[type] = handler;
    });
  }

  /// Called when a new push notification arrives.
  ///
  /// Returns `true` if the message was handled successfully, `false` otherwise.
  @override
  Future<bool> onNotificationMessage(dynamic remoteRawData) =>
      _handleNotificationMessage(remoteRawData, false);

  /// Called when the app is opened from a push notification.
  ///
  /// Returns `true` if the event was handled successfully, `false` otherwise.
  @override
  Future<bool> onAppOpenedFromMessage(dynamic remoteRawData) =>
      _handleNotificationMessage(remoteRawData, true);

  Future<bool> _handleNotificationMessage(
    dynamic remoteRawData,
    bool appOpenedFromMessage,
  ) async {
    Message message;
    try {
      message = messageParser.parseMessage(remoteRawData);
      Log.d('NotificationsManager - New message: $message');
    } catch (exp) {
      Log.e(
          'NotificationsManager - Message could not be parsed: $remoteRawData');
      return false;
    }

    if (!_hasHandlerForType(message.type)) {
      Log.e('NotificationsManager - '
          'Message type does not have a handler: ${message.type}');
      return false;
    }

    if (!(await messageFilter?.filterMessage(message) ?? true)) {
      Log.w('NotificationsManager - Message did not pass filter: $message');
      return false;
    }

    try {
      await Future.forEach<MessageHandler?>([
        globalPreMessageHandler,
        _getHandlerForType(message.type),
        globalPostMessageHandler,
      ], (messageHandler) {
        if (appOpenedFromMessage) {
          return messageHandler?.handleAppOpenedFromMessage(message);
        } else {
          return messageHandler?.handleMessage(message);
        }
      });
      return true;
    } catch (error) {
      Log.e('NotificationsManager - Error handling '
          'message: $message, '
          'error: $error');
      return false;
    }
  }

  bool _hasHandlerForType(String messageType) =>
      _messageHandlerForType.containsKey(messageType);

  MessageHandler<Message> _getHandlerForType(String messageType) =>
      _messageHandlerForType[messageType]!;
}

/// Consumes new push notifications as they arrive.
abstract class NotificationConsumer {
  /// Returns `true` if the message was handled successfully, `false` otherwise.
  Future<bool> onNotificationMessage(dynamic remoteRawData);

  /// Returns `true` if the event was handled successfully, `false` otherwise.
  Future<bool> onAppOpenedFromMessage(dynamic remoteRawData);
}
