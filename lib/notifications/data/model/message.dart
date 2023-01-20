import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/notifications/data/model/message_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

/// Push notification base message. Extend to add more data.
@immutable
@JsonSerializable()
class Message extends Equatable {
  @JsonKey(toJson: typeToJson, fromJson: typeFromJson)
  final MessageType type;
  final String? messageId;
  final String? title;
  final String? body;
  final bool? fullScreenIntent; //android only

  Message({
    this.type = MessageType.UNKNOWN,
    this.messageId,
    this.title,
    this.body,
    this.fullScreenIntent,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [messageId, type, title, body];

  @override
  String toString() {
    return 'Message{'
        'type: $type, '
        'messageId: $messageId, '
        'title: $title, '
        'body: $body, '
        'fullScreenIntent (Android): $fullScreenIntent'
        '}';
  }
}

String typeToJson(MessageType value) => value.getKey();

MessageType typeFromJson(String value) => value.toMessageType();
