import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/util/string_util.dart';

/// Tests for string utils.
void main() {
  group('shortenForPrint()', () {
    final text = '0123456789';

    test('shorten longer than n', () {
      final actual = text.shortenForPrint(2);
      final expected = '01...89';

      expect(actual, equals(expected));
    });

    test('shorten equal to n', () {
      final actual = text.shortenForPrint(); //defaults to 5
      final expected = text;

      expect(actual, equals(expected));
    });

    test('shorten shorter than n', () {
      final actual = text.shortenForPrint(10);
      final expected = text;

      expect(actual, equals(expected));
    });
  });
}
