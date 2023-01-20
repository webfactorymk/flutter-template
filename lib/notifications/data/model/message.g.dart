// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      type: json['type'] == null
          ? MessageType.UNKNOWN
          : typeFromJson(json['type'] as String),
      messageId: json['messageId'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      fullScreenIntent: json['fullScreenIntent'] as bool?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'type': typeToJson(instance.type),
      'messageId': instance.messageId,
      'title': instance.title,
      'body': instance.body,
      'fullScreenIntent': instance.fullScreenIntent,
    };
