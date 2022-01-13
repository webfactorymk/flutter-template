import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_handler.dart';

import 'test_messages.dart';

class RootMessageHandler extends MessageHandler<Message> {
  @override
  Future<void> handleMessage(Message message) async {}

  @override
  Future<void> handleAppOpenedFromMessage(Message message) async {}
}

class MarketingMessageHandler extends MessageHandler<MarketingMessage> {
  @override
  Future<void> handleMessage(MarketingMessage message) async {
    message.text.length;
  }

  @override
  Future<void> handleAppOpenedFromMessage(MarketingMessage message) async {
    message.text.length;
  }
}

class PaymentMessageHandler extends MessageHandler<PaymentMessage> {
  @override
  Future<void> handleMessage(PaymentMessage message) => _handle(message);

  @override
  Future<void> handleAppOpenedFromMessage(PaymentMessage message) =>
      _handle(message);

  Future<void> _handle(PaymentMessage message) async {
    if (message is! PaymentSuccessMsg && message is! PaymentFailedMsg) {
      throw Exception('Payment message is not success or error.');
    }
  }
}
