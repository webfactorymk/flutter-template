import 'package:flutter_template/notifications/message.dart';
import 'package:flutter_template/notifications/message_handler.dart';

import 'test_messages.dart';

class RootMessageHandler extends MessageHandler<Message> {
  @override
  Future<void> handleMessage(Message message) async {}
}

class MarketingMessageHandler extends MessageHandler<MarketingMessage> {
  @override
  Future<void> handleMessage(MarketingMessage message) async {
    message.text.length;
  }
}

class PaymentMessageHandler extends MessageHandler<PaymentMessage> {
  @override
  Future<void> handleMessage(PaymentMessage message) async {
    if (message is! PaymentSuccessMsg &&
        message is! PaymentFailedMsg) {
      throw Exception('Payment message is not success or error.');
    }
  }
}
