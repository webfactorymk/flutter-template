import 'collections_util.dart';

/// Checks if item is enum
bool isEnum(item) {
  final split = item.toString().split('.');
  return split.length > 1 && split[0] == item.runtimeType.toString();
}

/// Convert an enum to a string
String enumToString(dynamic enumItem) {
  assert(enumItem != null);
  assert(isEnum(enumItem),
      'Item $enumItem of type ${enumItem.runtimeType.toString()} is not enum');
  return enumItem.toString().split('.')[1];
}

/// Returns enum from a string value using a provided enum values list.
/// If the value can not be found `null` is returned.
E? enumFromString<E>(List<E?> enumValues, String? value) {
  if (value == null) {
    return null;
  }

  return enumValues
      .firstWhereOrElseNullable((enumItem) => enumToString(enumItem) == value);
}

/// Returns enum from a string value using a provided lookup map.
/// If the value can not be found `null` is returned.
E? enumFromStringLookupMap<E>(Map<E, String> enumStringMap, String? value) {
  if (value == null) {
    return null;
  }

  Iterable<MapEntry<E, String>?> enumEntries = enumStringMap.entries;
  return enumEntries
      .firstWhereOrElseNullable((e) => e?.value == value, orElse: () => null)
      ?.key;
}
