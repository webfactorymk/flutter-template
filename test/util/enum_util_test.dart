import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/util/enum_util.dart' as EnumUtil;

enum MockEnum { first, second }

/// Tests for enum utils.
void main() {
  group('isEnum', () {
    test('enum value', () {
      bool isEnum = EnumUtil.isEnum(MockEnum.first);

      expect(isEnum, isTrue);
    });

    test('non-enum value', () {
      bool isEnum = EnumUtil.isEnum(null);

      expect(isEnum, isFalse);
    });
  });

  group('enum equals', () {
    test('enum equals basic pass', () {
      expect(MockEnum.first == MockEnum.first, isTrue);
    });

    test('enum equals basic fail', () {
      expect(MockEnum.first == MockEnum.second, isFalse);
    });
  });

  group('enumToString', () {
    test('enum value', () {
      String value = EnumUtil.enumToString(MockEnum.first);

      expect(value, equals('first'));
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

      expect(enumValue, equals(MockEnum.first));
    });

    test('non-enum value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, '');

      expect(result, isNull);
    });

    test('null value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, null);

      expect(result, isNull);
    });
  });

  group('enumFromStringLookupMap', () {
    final Map<MockEnum, String> map = Map.unmodifiable({
      MockEnum.first: 'first',
      MockEnum.second: 'second',
    });

    test('enum value', () {
      var enumValue = EnumUtil.enumFromStringLookupMap(map, 'first');

      expect(enumValue, equals(MockEnum.first));
    });

    test('non-enum value', () {
      var result = EnumUtil.enumFromStringLookupMap(map, '');

      expect(result, isNull);
    });

    test('null value', () {
      var result = EnumUtil.enumFromString(MockEnum.values, null);

      expect(result, isNull);
    });
  });
}
