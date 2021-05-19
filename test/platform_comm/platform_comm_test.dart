import 'package:flutter/services.dart';
import 'package:flutter_template/data/item_converter.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'platform_comm_test.mocks.dart';
import 'test_method_channel.dart';

abstract class NoParamFunction {
  dynamic call();
}

abstract class ParamFunction<P> {
  dynamic call(P);
}

class NoParamFunctionMock extends Mock implements NoParamFunction {}

class ParamFunctionMock<P> extends Mock implements ParamFunction<P> {}

@GenerateMocks([MethodChannel])
void main() {
  late MockMethodChannel mockMethodChannel;
  late PlatformComm platformComm;
  final String method = 'testMethod';

  TestWidgetsFlutterBinding.ensureInitialized();

  group('InvokeMethod', () {
    setUp(() {
      mockMethodChannel = MockMethodChannel();
      platformComm = PlatformComm(mockMethodChannel);
    });

    group('InvokeMethod, no serializer and deserializer', () {
      final String expectedValue = 'success';

      test('InvokeMethod, no parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(method, []))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue =
            await platformComm.invokeMethod<String, String>(method: method);

        // assert
        verify(mockMethodChannel.invokeMethod(method, [])).called(1);
        expect(actualValue, expectedValue);
      });

      test('InvokeMethod, with parameters', () async {
        // arrange
        final String param = 'testParam';
        when(mockMethodChannel.invokeMethod<String>(method, param))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue = await platformComm.invokeMethod<String, String>(
            method: method, param: param);

        // assert
        verify(mockMethodChannel.invokeMethod(method, param)).called(1);
        expect(actualValue, expectedValue);
      });
    });

    group('InvokeMethod, with serializer and deserializer', () {
      test('InvokeMethod, with parameters, serializer and deserializer',
          () async {
        // arrange
        Serialize<int> serializer = (int param) => param.toString();
        Deserialize<String> deserializer = (dynamic data) => data.toString();
        int param = 1;
        String paramSerialized = '1';
        int expectedValue = 2;
        String expectedValueDeSerialized = '2';
        when(mockMethodChannel.invokeMethod<int>(method, paramSerialized))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        var actualValue = await platformComm.invokeMethod<String, int>(
            method: method,
            param: param,
            serializeParam: serializer,
            deserializeResult: deserializer);

        // assert
        verify(mockMethodChannel.invokeMethod(method, paramSerialized))
            .called(1);
        expect(actualValue, expectedValueDeSerialized);
      });
    });
  });

  group('InvokeProcedure', () {
    setUp(() {
      mockMethodChannel = MockMethodChannel();
      platformComm = PlatformComm(mockMethodChannel);
    });

    group('InvokeProcedure, no serializer', () {
      final String expectedValue = 'success';

      test('InvokeProcedure, no parameters', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(method, []))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeMethod(method: method);

        // assert
        verify(mockMethodChannel.invokeMethod(method, [])).called(1);
        expect(mockMethodChannel.invokeMethod<String>(method, []),
            completion(equals(expectedValue)));
      });

      test('InvokeProcedure, with parameters', () async {
        // arrange
        final String param = 'testParam';
        when(mockMethodChannel.invokeMethod<String>(method, param))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeMethod<void, String>(
            method: method, param: param);

        // assert
        verify(mockMethodChannel.invokeMethod(method, param)).called(1);
        expect(mockMethodChannel.invokeMethod(method, param),
            completion(equals(expectedValue)));
      });
    });

    group('InvokeProcedure, with serializer', () {
      test('InvokeMethod, with parameters and serializer', () async {
        // arrange
        Serialize<int> serializer = (int param) => param.toString();
        int param = 1;
        String paramSerialized = '1';
        int expectedValue = 2;
        when(mockMethodChannel.invokeMethod<int>(method, paramSerialized))
            .thenAnswer((realInvocation) => Future.value(expectedValue));

        // act
        await platformComm.invokeMethod<void, int>(
          method: method,
          param: param,
          serializeParam: serializer,
        );

        // assert
        verify(mockMethodChannel.invokeMethod(method, paramSerialized))
            .called(1);
      });

      test('InvokeMethod, with return type void and deserializer', () async {
        // arrange
        when(mockMethodChannel.invokeMethod<String>(method, 'param'))
            .thenAnswer((realInvocation) => Future.value('result'));

        // act
        void voidUnusableResult = await platformComm.invokeMethod<void, String>(
          method: method,
          param: 'param',
          deserializeResult: (resultRaw) => 23,
        );

        // assert
        verify(mockMethodChannel.invokeMethod(method, 'param')).called(1);
      });
    });
  });

  group('ListenMethod', () {
    late TestMethodChannel channel;
    late PlatformComm platformComm;
    late Future Function(MethodCall call)? handler;

    setUp(() {
      channel = TestMethodChannel('customChannel');
      platformComm = PlatformComm(channel);
      handler = channel.handler;
    });

    test('ListenMethodNoParams', () async {
      // arrange
      NoParamFunctionMock mockNoParamFunction = NoParamFunctionMock();

      // act
      platformComm.listenMethodNoParams(
          method: method, callback: mockNoParamFunction.call);
      await handler?.call(MethodCall(method, []));

      // assert
      verify(mockNoParamFunction.call()).called(1);
    });

    test('ListenMethod, with params', () async {
      // arrange
      final String param = 'testParam';
      ParamFunctionMock<String> mockParamFunction = ParamFunctionMock<String>();

      // act
      platformComm.listenMethod(
          method: method,
          callback: (param) async => mockParamFunction.call(param));
      await handler?.call(MethodCall(method, param));

      // assert
      verify(mockParamFunction.call(param)).called(1);
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });
  });
}
