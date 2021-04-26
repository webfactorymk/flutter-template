import 'package:flutter_template/util/subscription.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class CancelFunction {
  void call();
}

class CancelFunctionMock extends Mock implements CancelFunction {}

/// Tests for [Subscription]
void main() {
  group('synchronous', () {
    late Subscription subscription;
    late CancelFunctionMock cancelFunction;

    setUp(() {
      cancelFunction = CancelFunctionMock();
      subscription = Subscription(cancel: cancelFunction);
    });

    test('cancel called once', () {
      subscription.cancel();

      verify(cancelFunction()).called(1);
    });

    test('cancel called multiple times', () {
      subscription.cancel();
      subscription.cancel();

      verify(cancelFunction()).called(1);
    });
  });

  group('asynchronous', () {
    late AsyncSubscription subscription;
    late CancelFunctionMock cancelFunction;

    setUp(() {
      cancelFunction = CancelFunctionMock();
      subscription = AsyncSubscription(cancel: () async => cancelFunction());
    });

    test('async cancel called once', () async {
      await subscription.cancel();

      verify(cancelFunction()).called(1);
    });

    test('cancel called multiple times', () async {
      await subscription.cancel();
      await subscription.cancel();

      verify(cancelFunction()).called(1);
    });
  });
}
