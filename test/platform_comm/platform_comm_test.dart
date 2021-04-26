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
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('InvokeMethod', () {
    group('InvokeMethod, no serializer and deserializer', () {
      final String tParameter = 'testParam';
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
        when(mockMethodChannel.invokeMethod<String>(tMethod, tParameter))
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

      test('InvokeMethod, with parameters, serializer and deserializer',
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

  group('InvokeProcedure', () {
    group('InvokeProcedure, no serializer', () {
      final String tParameter = 'testParam';
      final String expectedValue = 'success';

      test('InvokeProcedure, no parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(tMethod, []))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeProcedure(method: tMethod);

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, [])).called(1);
        expect(mockMethodChannel.invokeMethod<String>(tMethod, []),
            completion(equals(expectedValue)));
      });

      test('InvokeProcedure, with parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(tMethod, tParameter))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeProcedure<String>(
            method: tMethod, param: tParameter);

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, tParameter)).called(1);
        expect(mockMethodChannel.invokeMethod(tMethod, tParameter),
            completion(equals(expectedValue)));
      });
    });

    group('InvokeProcedure, with serializer', () {
      int tParameter = 1;
      String tParameterSerialized = '1';
      int expectedValue = 2;

      test('InvokeMethod, with parameters and serializer', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<int>(tMethod, tParameterSerialized))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeProcedure<int>(
          method: tMethod,
          param: tParameter,
          serializeParams: serializer,
        );

        // assert
        verify(mockMethodChannel.invokeMethod(tMethod, tParameterSerialized))
            .called(1);
        expect(mockMethodChannel.invokeMethod(tMethod, tParameterSerialized),
            completion(equals(expectedValue)));
      });
    });
  });

  group('ListenMethod', () {
    final String tParameter1 = 'testParam1';
    final String tParameter2 = 'testParam2';

    test('ListenMethodNoParams', () async {
      // arrange
      List<MethodCall> log = <MethodCall>[];
      MethodChannel channel = const MethodChannel('customChannel');
      PlatformComm tPlatformComm = PlatformComm(channel);
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
      });

      // act
      tPlatformComm.invokeMethod(method: tMethod, param: []);

      // assert
      expect(log.length, equals(1));
      expect(log.first.method, equals(tMethod));
      expect(log.first.arguments, equals([]));
    });

    test('ListenMethod, with params', () async {
      // arrange
      List<MethodCall> log = <MethodCall>[];
      MethodChannel channel = const MethodChannel('customChannel');
      PlatformComm tPlatformComm = PlatformComm(channel);
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
      });

      // act
      tPlatformComm
          .invokeMethod(method: tMethod, param: [tParameter1, tParameter2]);

      // assert
      expect(log.length, equals(1));
      expect(log.first.method, equals(tMethod));
      expect(log.first.arguments, equals([tParameter1, tParameter2]));
    });
  });
}
