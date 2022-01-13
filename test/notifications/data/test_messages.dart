import 'package:flutter_template/notifications/data/message.dart';

class MarketingMessage extends Message {
  final String text;

  MarketingMessage(this.text) : super('msg-marketing');
}

abstract class PaymentMessage extends Message {
  PaymentMessage(String type) : super(type);
}

class PaymentSuccessMsg extends PaymentMessage {
  PaymentSuccessMsg() : super('msg-payment-success');
}

class PaymentFailedMsg extends PaymentMessage {
  final Object error;

  PaymentFailedMsg(this.error) : super('msg-payment-error');
}
