typedef Map<String, dynamic> ToMap<T>(T item);

typedef T FromMap<T>(Map<String, dynamic> data);

/// Converts concrete types to and from `Map<String, dynamic>`.
class MapConverter<T> {
  final ToMap<T> toMap;

  final FromMap<T> fromMap;

  MapConverter(this.toMap, this.fromMap);
}