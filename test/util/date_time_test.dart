import 'package:flutter_test/flutter_test.dart';

/// Tests for [DateTime].
void main() {
  const String dateTimeApiResponse = '2020-09-17T14:05:21.519Z';

  test("Parse Api response (JsonSerializable)", () {
    final actual = DateTime.parse(dateTimeApiResponse);
    final expected = DateTime.utc(2020, 9, 17, 14, 05, 21, 519);

    expect(expected, equals(actual));
  });
}
