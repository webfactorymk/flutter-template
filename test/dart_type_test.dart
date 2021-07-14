import 'package:flutter_test/flutter_test.dart';

Type _typeOf<T>() => T;

/// Tests for dart [Type].
void main() {
  group('is', () {
    test('is on object: Will be true for this and parent classes', () {
      final ChildClass childObject = ChildClass();

      // True
      expectTrue(childObject is ChildClass);
      expectTrue(childObject is ParentClass);
      expectTrue(childObject is Interface);

      // False
      expectTrue(childObject is! GrandChildClass);
    });

    test('is on class: A class is a Type', () {
      // True
      expectTrue(ChildClass is Type);

      // False
      expectFalse(ChildClass is ChildClass);
      expectFalse(ChildClass is ParentClass);
      expectFalse(ChildClass is Interface);
    });

    test('is on generic: Same as class', () {
      void Function<T>() func = <T>() {
        // True
        expectTrue(T is Type);

        // False
        expectFalse(T is ChildClass);
        expectFalse(T is ParentClass);
        expectFalse(T is Interface);
      };

      func<ChildClass>();
    });
  });

  group('==', () {
    test("== on object: Can't compare unrelated types", () {
      final ChildClass childObject = ChildClass();

      // False
      expectFalse(childObject == ChildClass);
      expectFalse(childObject == ParentClass);
      expectFalse(childObject == Interface);
    });

    test("== on class: Comparing types won't be true for superclasses", () {
      // True
      expectTrue(ChildClass == ChildClass);

      // False
      expectFalse(ChildClass == Type);
      expectFalse(ChildClass == ParentClass);
      expectFalse(ChildClass == Interface);
    });

    test('== on generic: Same as class', () {
      void Function<T>() func = <T>() {
        // True
        expectTrue(T == ChildClass);

        // False
        expectFalse(T == Type);
        expectFalse(T == ParentClass);
        expectFalse(T == Interface);
      };

      func<ChildClass>();
    });
  });

  group('type of', () {
    test('type of is', () {
      // True
      expectTrue(_typeOf<ChildClass>() is Type);

      // False
      expectFalse(_typeOf<ChildClass>() is ChildClass);
      expectFalse(_typeOf<ChildClass>() is ParentClass);
      expectFalse(_typeOf<ChildClass>() is Interface);
    });

    test('type of equals', () {
      // True
      expectTrue(_typeOf<ChildClass>() == ChildClass);

      // False
      expectFalse(_typeOf<ChildClass>() == Type);
      expectFalse(_typeOf<ChildClass>() == ParentClass);
      expectFalse(_typeOf<ChildClass>() == Interface);
    });

    test('type of equals: nested generics', () {
      void Function<T>() func = <T>() {
        // True
        expectTrue(T == _typeOf<List<String>>());

        // False
        expectFalse(T == List);
        expectFalse(T is List);
        expectFalse(T is List<String>);
      };

      func<List<String>>();
    });

    test('void type', () {
      void Function<T>() func = <T>() {
        // True
        expectTrue(T == _typeOf<void>());
        expectTrue(T is Type);
      };

      func<void>();
    });

    test('runtime type', () {
      // True
      expectTrue(ChildClass().runtimeType == ChildClass);
    });
  });
}

void expectTrue(bool expression) => expect(expression, isTrue);

void expectFalse(bool expression) => expect(expression, isFalse);

abstract class Interface {}

abstract class ParentClass {}

class ChildClass extends ParentClass implements Interface {}

class GrandChildClass extends ParentClass implements Interface {}
