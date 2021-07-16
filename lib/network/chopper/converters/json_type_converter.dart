import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/network/chopper/converters/map_converter.dart';

/// [Converter] that converts JSON data to concrete types using
/// [jsonEncode]/[jsonDecode] and a type conversion map.
///
/// All supported types must be registered using [registerConverter].
/// Example:
///       JsonTypeConverterBuilder()
///         .registerConverter<User>(
///           toMap: (user) => user.toJson(),
///           fromMap: (map) => User.fromJson(map),
///         )
///         .registerConverter<Task>(
///           toMap: (task) => task.toJson(),
///           fromMap: (map) => Task.fromJson(map),
///         );
///
/// _Based on [JsonConverter].
@immutable
class JsonTypeConverter implements Converter {
  final Map<Type, MapConverter<dynamic>> _converterMap;

  const JsonTypeConverter(this._converterMap);

  @override
  Request convertRequest(Request request) {
    request = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    final contentType = request.headers[contentTypeKey];
    if (contentType == null || !contentType.contains(jsonHeaders)) {
      return request;
    }

    if (request.body == null) {
      return request;
    }

    final type = request.body.runtimeType;
    final typeConverterDynamic = _converterMap[type];
    final typeConverter;
    if (typeConverterDynamic.runtimeType == typeConverterDynamic.runtimeType) {
      // gets to know the runtime type instead of using dynamic
      // another solution is to use final Map<Type, dynamic> _converterMap;
      typeConverter = typeConverterDynamic;
    } else {
      typeConverter = null;
    }

    if (typeConverter == null) {
      Log.w('JsonTypeConverter - No converter found for type: $type');
      return request;
    }

    final body = jsonEncode(typeConverter.toMap(request.body));
    return request.copyWith(body: body);
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    final supportedContentTypes = [jsonHeaders, jsonApiHeaders];

    final contentType = response.headers[contentTypeKey];
    var body = response.body;

    if (supportedContentTypes.contains(contentType)) {
      body = utf8.decode(response.bodyBytes);
    }

    try {
      body = json.decode(body);
    } catch (e) {
      Log.w('JsonTypeConverter - Could not decode json body.'
          ' Response type: ${BodyType.runtimeType}'
          ' Error: $e');
    }

    final typeConverter = _converterMap[InnerType];

    if (typeConverter == null) {
      Log.w('JsonTypeConverter - No converter found for type: $InnerType');
    } else {
      if (isTypeOf<BodyType, InnerType>()) {
        body = typeConverter.fromMap(body) as InnerType;
      } else if (isTypeOf<BodyType, Iterable<InnerType>>()) {
        body = body.map((item) => typeConverter.fromMap(item) as InnerType);
        body = body.cast<InnerType>();
        if (isTypeOf<BodyType, List<InnerType>>()) {
          body = (body as Iterable<InnerType>).toList();
        }
      } else if (isTypeOf<BodyType, Map<String, InnerType>>()) {
        body = body.map((key, item) => MapEntry(key, typeConverter.fromMap(item) as InnerType));
        body = body.cast<String, InnerType>();
      }
    }

    return response.copyWith<BodyType>(body: body);
  }
}
