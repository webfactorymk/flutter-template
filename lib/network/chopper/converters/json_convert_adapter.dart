import 'dart:convert';

typedef dynamic ToJsonElement<T>(T item);

typedef T FromJsonElement<T>(dynamic data);

/// Adapts concrete types to and from JSON objects
/// for use with [jsonEncode] and [jsonDecode].
class JsonConvertAdapter<T> {
  final ToJsonElement<T> toJsonElement;

  final FromJsonElement<T> fromJsonElement;

  JsonConvertAdapter(this.toJsonElement, this.fromJsonElement);
}