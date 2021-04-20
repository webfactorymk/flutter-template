import 'package:flutter_template/util/collections_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for collection utils.
void main() {
  final Map<int, String> map = Map.unmodifiable({5: 'five', 10: 'ten'});

  group('getByValue', () {
    test('get existing', () {
      int actual = map.getByValue('ten')!;
      expect(actual, equals(10));
    });

    test('get non-existent', () {
      int? actual = map.getByValue('imaginary-number');
      expect(actual, isNull);
    });

    test('get or else', () {
      int? actual = map.getByValue('imaginary-number', orElse: () => -10);
      expect(actual, equals(-10));
    });
  });
}
