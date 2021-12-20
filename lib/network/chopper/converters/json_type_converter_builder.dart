import 'package:flutter_template/network/chopper/converters/json_convert_adapter.dart';
import 'package:flutter_template/network/chopper/converters/json_type_converter.dart';

import 'map_converter.dart' show FromMap, MapConverter, ToMap;

/// Builder class for [JsonTypeConverter]
class JsonTypeConverterBuilder {
  final Map<Type, JsonConvertAdapter<dynamic>> _converterMap = {};

  JsonTypeConverterBuilder(
      [Map<Type, JsonConvertAdapter<dynamic>> converterMap = const {}]) {
    _converterMap.addAll(converterMap);
  }

  /// Registers `Map<String, dynamic>` converter for the concrete type.
  /// Use when dealing with JSON objects.
  JsonTypeConverterBuilder registerConverter<T>({
    required ToMap<T> toMap,
    required FromMap<T> fromMap,
  }) {
    _converterMap[T] = MapConverter<T>(toMap, fromMap);
    return this;
  }

  /// Registers `dynamic` converter for the concrete type.
  /// Use when the JSON is a list or a primitive, not an object.
  JsonTypeConverterBuilder registerCustomConverter<T>({
    required ToJsonElement<T> toJsonElement,
    required FromJsonElement<T> fromJsonElement,
  }) {
    _converterMap[T] = JsonConvertAdapter<T>(toJsonElement, fromJsonElement);
    return this;
  }

  JsonTypeConverter build() =>
      JsonTypeConverter(Map.unmodifiable(_converterMap));
}
