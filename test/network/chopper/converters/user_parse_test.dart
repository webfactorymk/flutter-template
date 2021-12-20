import 'dart:convert';

import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/chopper/converters/json_convert_adapter.dart';
import 'package:flutter_template/network/chopper/converters/map_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final JsonConvertAdapter<User> converter;

  setUp(() {
    converter = MapConverter<User>(
      (user) => user.toJson(),
      (data) => User.fromJson(data),
    );
  });

  test('Decode item', () {
    final User convertedResponse =
        converter.fromJsonElement(jsonDecode(jsonResponse));
    expect(convertedResponse, equals(user));
  });
}

final User user = User(id: '1', email: 'user@example.com');

const String jsonResponse =
    "{" + "\"uuid\": \"1\"," + "\"email\": \"user@example.com\"" + "}";
