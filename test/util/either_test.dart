import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/util/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Success', () {
    late Task expectedTask;

    setUp(() {
      expectedTask =
          Task(id: '1', status: TaskStatus.done, title: 'Expected title');
    });

    test('Either.success', () async {
      // act
      final Either<Exception, Task> actualEither = Either.success(expectedTask);

      // assert
      expect(actualEither, isA<Success>());
      expect(actualEither, isNot(isA<Error>()));
      expect((actualEither as Success).value, expectedTask);
    });

    test('Either.build, success', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.build(() => expectedTask);

      // assert
      expect(actualEither, isA<Success>());
      expect(actualEither, isNot(isA<Error>()));
      expect((actualEither as Success).value, expectedTask);
    });

    test('Either.expose, success', () async {
      // arrange
      late Exception actualException;
      Exception expectedException = Exception('Throw me');
      Exception notThrownException = FormatException();
      final Either<Exception, Task> actualEither =
          Either.build(() => expectedTask);

      // act
      try {
        actualEither.expose((error) => throw notThrownException,
            (success) => throw expectedException);
      } on Exception catch (e) {
        actualException = e;
      }

      // assert
      expect(actualException, equals(expectedException));
      expect(actualException, isNot(equals(notThrownException)));
      expect(actualEither.isSuccess, true);
    });
  });

  group('Error', () {
    late Exception expectedException;

    setUp(() {
      expectedException = Exception('Throw me');
    });

    test('Either.error', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.error(expectedException);

      // assert
      expect(actualEither, isA<Error>());
      expect(actualEither, isNot(isA<Success>()));
      expect((actualEither as Error).error, expectedException);
    });

    test('Either.build, error', () async {
      // act
      final Either<Exception, Task> actualEither =
          Either.build(() => throw expectedException);

      // assert
      expect(actualEither, isA<Error>());
      expect(actualEither, isNot(isA<Success>()));
      expect((actualEither as Error).error, expectedException);
    });

    test('Either.expose, error', () async {
      // arrange
      Exception notThrownException = FormatException();
      late Exception actualException;
      final Either<Exception, Task> actualEither =
          Either.build(() => throw expectedException);

      // act
      try {
        actualEither.expose(
            (error) => throw error, (success) => throw notThrownException);
      } on Exception catch (e) {
        actualException = e;
      }

      // assert
      expect(actualException, equals(expectedException));
      expect(actualException, isNot(equals(notThrownException)));
      expect(actualEither.isSuccess, false);
    });
  });
}
