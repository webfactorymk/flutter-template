import 'dart:convert';

import 'package:flutter_template/network/chopper/converters/json_convert_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final JsonConvertAdapter<DateTime> converter;

  setUp(() {
    converter = JsonConvertAdapter<DateTime>(
      (dateTime) => dateTime.toIso8601String(),
      (dateTime) => DateTime.parse(dateTime),
    );
  });

  test('Decode items list', () {
    final List<DateTime> convertedResponse =
        (jsonDecode(jsonResponse) as Iterable)
            .map((item) => converter.fromJsonElement(item))
            .cast<DateTime>()
            .toList();
    expect(convertedResponse, equals(dateTimeList));
  });
}

final List<DateTime> dateTimeList = [
  DateTime(2021, 12, 29),
  DateTime(2021, 12, 28),
  DateTime(2021, 12, 27),
  DateTime(2021, 12, 26),
  DateTime(2021, 12, 23),
];

const String jsonResponse = "[" +
    "\"2021-12-29\"," +
    "\"2021-12-28\"," +
    "\"2021-12-27\"," +
    "\"2021-12-26\"," +
    "\"2021-12-23\"" +
    "]";
