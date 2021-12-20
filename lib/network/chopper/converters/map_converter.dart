import 'package:flutter_template/network/chopper/converters/json_convert_adapter.dart';

typedef Map<String, dynamic> ToMap<T>(T item);

typedef T FromMap<T>(Map<String, dynamic> data);

/// Converts concrete types to and from `Map<String, dynamic>`.
class MapConverter<T> extends JsonConvertAdapter<T> {
  MapConverter(ToMap<T> toMap, FromMap<T> fromMap)
      : super(
          (item) => toMap(item),
          (data) => fromMap(data),
        );
}
