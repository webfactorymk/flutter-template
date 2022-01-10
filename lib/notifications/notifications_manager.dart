import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/message.dart';
import 'package:flutter_template/notifications/message_handler.dart';
import 'package:flutter_template/notifications/message_parser.dart';

/// Abstract, implementation free, NotificationsManager.
///
/// Manages the push notification flow:
///  - listens for remote messages
///  - parses the remote messages to [Message] or a subtype
///  - calls a [MessageHandler] registered for the specific notification type
///
/// Usage:
/// 1. Create a single instance and register a [MessageParser] and
/// add [MessageHandler]s for each action that happens after a notification
/// of specific type arrives - display notification, navigate to screen, etc.
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
/// To obtain an instance use `serviceLocator.get<NotificationsManager>()`
class NotificationsManager implements NotificationConsumer {
  final Map<String, MessageHandler<Message>> _messageHandlerForType = Map();

  /// Parses incoming raw message data into a [Message] or a subtype
  final MessageParser messageParser;

  /// Global message handler called before a notification is handled. Optional.
  final MessageHandler<Message>? globalPreMessageHandler;

  /// Global message handler called after a notification is handled. Optional.
  final MessageHandler<Message>? globalPostMessageHandler;

  /// Global message filter. Optional.
  final bool Function(Message)? filterMessage;

  NotificationsManager({
    required this.messageParser,
    this.globalPreMessageHandler,
    this.globalPostMessageHandler,
    this.filterMessage,
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
  Future<bool> onNotificationMessage(dynamic remoteRawData) async {
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

    if (!(filterMessage?.call(message) ?? true)) {
      Log.w('NotificationsManager - Message did not pass filter: $message');
      return false;
    }

    try {
      await globalPreMessageHandler?.handleMessage(message);
      await _getHandlerForType(message.type).handleMessage(message);
      await globalPostMessageHandler?.handleMessage(message);
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
}
