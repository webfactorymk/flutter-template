import 'package:flutter_template/network/chopper/converters/json_type_converter.dart';

import 'map_converter.dart' show FromMap, MapConverter, ToMap;

/// Builder class for [JsonTypeConverter]
class JsonTypeConverterBuilder {
  final Map<Type, MapConverter<dynamic>> _converterMap = {};

  JsonTypeConverterBuilder(
      [Map<Type, MapConverter<dynamic>> converterMap = const {}]) {
    _converterMap.addAll(converterMap);
  }

  /// Registers `Map<String, dynamic>` converter for the concrete type.
  JsonTypeConverterBuilder registerConverter<T>({
    required ToMap<T> toMap,
    required FromMap<T> fromMap,
  }) {
    _converterMap[T] = MapConverter<T>(toMap, fromMap);
    return this;
  }

  JsonTypeConverter build() =>
      JsonTypeConverter(Map.unmodifiable(_converterMap));
}
