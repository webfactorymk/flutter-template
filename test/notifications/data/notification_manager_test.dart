import 'package:flutter_template/log/console_logger.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_filter.dart';
import 'package:flutter_template/notifications/data/message_handler.dart';
import 'package:flutter_template/notifications/data/message_parser.dart';
import 'package:flutter_template/notifications/data/data_notification_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notification_manager_test.mocks.dart';
import 'test_message_handlers.dart';
import 'test_messages.dart';

@GenerateMocks([MessageHandler])
void main() {
  late DataNotificationManager notificationsManager;

  setUp(() {
    Log.logger = ConsoleLogger.create();
    notificationsManager = DataNotificationManager(
      messageParser: StubMessageParser(),
    );
  });

  test('Unhandled message', () async {
    Message unknown = Message('unknown-type');

    bool msgHandled = await notificationsManager.onNotificationMessage(unknown);

    expect(msgHandled, isFalse);
  });

  test('Single handler for single message', () async {
    MockMessageHandler<Message> messageHandler = MockMessageHandler();
    notificationsManager
      ..registerMessageHandler(
        handler: messageHandler,
        forMessageTypes: ['msg-type'],
      );
    Message message = Message('msg-type');

    bool msgHandled = await notificationsManager.onNotificationMessage(message);

    expect(msgHandled, isTrue);
    verify(messageHandler.handleMessage(message));
    verifyNoMoreInteractions(messageHandler);
  });

  test('Single handler for multiple messages', () async {
    MockMessageHandler<Message> messageHandler = MockMessageHandler();
    notificationsManager
      ..registerMessageHandler(
        handler: messageHandler,
        forMessageTypes: ['type1', 'type2'],
      );
    Message msg1 = Message('type1');
    Message msg2 = Message('type2');

    bool msg1Handled = await notificationsManager.onNotificationMessage(msg1);
    bool msg2Handled = await notificationsManager.onNotificationMessage(msg2);

    expect(msg1Handled, isTrue);
    expect(msg2Handled, isTrue);
    verifyInOrder([
      messageHandler.handleMessage(msg1),
      messageHandler.handleMessage(msg2),
    ]);
  });

  test('Message handler overwrite (latest set)', () async {
    MockMessageHandler<Message> messageHandlerInitial = MockMessageHandler();
    MockMessageHandler<Message> messageHandlerOverwrite = MockMessageHandler();
    notificationsManager
      ..registerMessageHandler(
        handler: messageHandlerInitial,
        forMessageTypes: ['msg-type'],
      )
      ..registerMessageHandler(
        handler: messageHandlerOverwrite,
        forMessageTypes: ['msg-type'],
      );
    Message message = Message('msg-type');

    bool msgHandled = await notificationsManager.onNotificationMessage(message);

    expect(msgHandled, isTrue);
    verify(messageHandlerOverwrite.handleMessage(message));
    verifyNever(messageHandlerInitial.handleMessage(any));
  });

  test('Message handlers for multiple message subtypes', () async {
    notificationsManager
      ..registerMessageHandler(
        handler: RootMessageHandler(),
        forMessageTypes: ['root'],
      )
      ..registerMessageHandler(
        handler: MarketingMessageHandler(),
        forMessageTypes: ['msg-marketing'],
      )
      ..registerMessageHandler(
        handler: PaymentMessageHandler(),
        forMessageTypes: ['msg-payment-success', 'msg-payment-error'],
      );

    bool rootMsgHandled =
        await notificationsManager.onNotificationMessage(Message('root'));
    bool marketingMsgHandled =
        await notificationsManager.onNotificationMessage(MarketingMessage('M'));
    bool paymentSuccessMsgHandled =
        await notificationsManager.onNotificationMessage(PaymentSuccessMsg());
    bool paymentFailedMsgHandled =
        await notificationsManager.onNotificationMessage(PaymentFailedMsg('E'));

    expect(rootMsgHandled, isTrue);
    expect(marketingMsgHandled, isTrue);
    expect(paymentSuccessMsgHandled, isTrue);
    expect(paymentFailedMsgHandled, isTrue);
  });

  test('Message filter', () async {
    MockMessageHandler<Message> messageHandler = MockMessageHandler();

    notificationsManager = DataNotificationManager(
      messageParser: StubMessageParser(),
      messageFilter: DiscardAllFilter(),
    )..registerMessageHandler(
        handler: messageHandler,
        forMessageTypes: ['msg-type'],
      );

    Message message = Message('msg-type');

    bool msgHandled = await notificationsManager.onNotificationMessage(message);

    expect(msgHandled, isFalse);
    verifyNever(messageHandler.handleMessage(any));
  });

  test('Global pre and post message handler', () async {
    MockMessageHandler<Message> preMessageHandler = MockMessageHandler();
    MockMessageHandler<Message> messageHandler = MockMessageHandler();
    MockMessageHandler<Message> postMessageHandler = MockMessageHandler();
    notificationsManager = DataNotificationManager(
      messageParser: StubMessageParser(),
      globalPreMessageHandler: preMessageHandler,
      globalPostMessageHandler: postMessageHandler,
    )..registerMessageHandler(
        handler: messageHandler,
        forMessageTypes: ['type1', 'type2'],
      );
    Message msg1 = Message('type1');
    Message msg2 = Message('type2');

    bool msg1Handled = await notificationsManager.onNotificationMessage(msg1);
    bool msg2Handled = await notificationsManager.onNotificationMessage(msg2);

    expect(msg1Handled, isTrue);
    expect(msg2Handled, isTrue);
    verifyInOrder([
      preMessageHandler.handleMessage(msg1),
      messageHandler.handleMessage(msg1),
      postMessageHandler.handleMessage(msg1),
      preMessageHandler.handleMessage(msg2),
      messageHandler.handleMessage(msg2),
      postMessageHandler.handleMessage(msg2),
    ]);
  });
}
