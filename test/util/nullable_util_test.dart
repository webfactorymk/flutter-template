import 'package:flutter_template/util/nullable_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for nullable utils.
void main() {
  final Map<int, String> map = Map.unmodifiable({5: 'five', 10: 'ten'});

  group('NullSafeFuture', () {
    test('cast', () {
      Future<int?> nullableFuture = Future.value(10);

      Future<int> nonNullableFuture = nullableFuture.asNonNullable();

      expect(nonNullableFuture, completion(equals(10)));
    });

    test('cast fail', () {
      Future<int?> nullableFuture = Future.value(null);

      Future<int> nonNullableFuture = nullableFuture.asNonNullable();

      expect(nonNullableFuture, throwsA(isInstanceOf<Error>()));
    });

    test('cast redundant', () {
      Future<int> nonNullableFuture1 = Future.value(10);

      Future<int> nonNullableFuture2 = nonNullableFuture1.asNonNullable();

      expect(nonNullableFuture2, completion(equals(10)));
    });
  });
}
