import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/platform_comm/item_converter.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'platform_comm_test.mocks.dart';

@GenerateMocks([MethodChannel])
void main() {
  late MockMethodChannel mockMethodChannel;
  late PlatformComm platformComm;
  late Serialize<int> serializer;
  late Deserialize<String> deserializer;
  final String tMethod = 'testMethod';

  setUp(() {
    mockMethodChannel = MockMethodChannel();
    platformComm = PlatformComm(mockMethodChannel);
    serializer = (int param) => param.toString();
    deserializer = (dynamic data) => data.toString();
  });

  group('InvokeMethod', () {
    group('InvokeMethod, no serializer and deserializer', () {
      final String tParameter = 'testParam1';
      final String expectedValue = 'success';

      test('InvokeMethod, no parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(tMethod, []))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue =
            await platformComm.invokeMethod<String, String>(method: tMethod);

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, [])).called(1);
        expect(actualValue, expectedValue);
      });

      test('InvokeMethod, with parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(tMethod, 'testParam1'))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue = await platformComm.invokeMethod<String, String>(
            method: tMethod, param: tParameter);

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, tParameter)).called(1);
        expect(actualValue, expectedValue);
      });
    });

    group('InvokeMethod, with serializer and deserializer', () {
      int tParameter = 1;
      String tParameterSerialized = '1';
      int expectedValue = 2;
      String expectedValueDeSerialized = '2';

      test('InvokeMethod, with parameters, serialize and deserialize',
          () async {
        // arrange
        when(mockMethodChannel.invokeMethod<int>(tMethod, tParameterSerialized))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue = await platformComm.invokeMethod<String, int>(
            method: tMethod,
            param: tParameter,
            serializeParams: serializer,
            deserializeResult: deserializer);

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, tParameterSerialized))
            .called(1);
        expect(actualValue, expectedValueDeSerialized);
      });
    });
  });
}
