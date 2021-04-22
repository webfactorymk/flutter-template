import 'package:flutter_test/flutter_test.dart';

import '../../lib/util/enum_util.dart' as EnumUtil;

enum MockEnum { first, second }

/// Tests for enum utils.
void main() {
  group('isEnum', () {
    test('enum value', () {
      bool isEnum = EnumUtil.isEnum(MockEnum.first);

      expect(isEnum, true);
    });

    test('non-enum value', () {
      bool isEnum = EnumUtil.isEnum(null);

      expect(isEnum, false);
    });
  });

  group('enumToString', () {
    test('enum value', () {
      String value = EnumUtil.enumToString(MockEnum.first);

      expect(value, 'first');
    });

    test('non-enum value', () {
      expect(() => EnumUtil.enumToString(1), throwsAssertionError);
    });

    test('null value', () {
      expect(() => EnumUtil.enumToString(null), throwsAssertionError);
    });
  });

  group('enumFromString', () {
    test('enum value', () {
      var enumValue = EnumUtil.enumFromString(MockEnum.values, 'first');

      expect(enumValue, MockEnum.values.first);
    });

    test('non-enum value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, '');

      expect(result, null);
    });

    test('null value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, null);

      expect(result, null);
    });
  });

  group('enumFromStringLookupMap', () {
    final Map<MockEnum, String> map = Map.unmodifiable({
      MockEnum.first: 'first',
      MockEnum.second: 'second',
    });

    test('enum value', () {
      var enumValue = EnumUtil.enumFromStringLookupMap(map, 'first');

      expect(enumValue, MockEnum.values.first);
    });

    test('non-enum value', () {
      var result = EnumUtil.enumFromStringLookupMap(map, '');

      expect(result, null);
    });

    test('null value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, null);

      expect(result, null);
    });
  });
}
