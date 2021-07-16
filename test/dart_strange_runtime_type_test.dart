import 'package:flutter_test/flutter_test.dart';

//real life scenario - dynamic json converter:
//  https://github.com/webfactorymk/flutter-template/commit/6e4cac846bd54b7b1f6e8b2587b40e110fe54b33#diff-55b2e560073dacce762ef47b5007071836476ff07abd8d264297a9fcbade4245
void main() {
  test('runtimeType type of wrapper not determined', () {
    Map<String, PrinterWrapper<dynamic>> mapOfPrintersForAnything = Map();

    mapOfPrintersForAnything['user-printer'] =
        PrinterWrapper<User>((user) => print('Mr/Ms ${user.lastName}'));

    final dynamicUserPrinter = mapOfPrintersForAnything['user-printer']!;

    // if we use
    //     dynamicUserPrinter.printer(User('Smith'));
    // we'd get runtime error:
    //     type '(User) => void' is not a subtype of type '(dynamic) => void'


    // ---- the tricky solution ----
    final userPrinter;
    if (dynamicUserPrinter.runtimeType == dynamicUserPrinter.runtimeType) {
      // gets to know the runtime type instead of using dynamic
      userPrinter = dynamicUserPrinter;
    } else {
      userPrinter = null;
    }

    userPrinter.printer(User('Smith'));
  });
}

class User {
  final lastName;

  User(this.lastName);
}

typedef void Printer<T>(T item);

class PrinterWrapper<T> {
  final Printer<T> printer;

  PrinterWrapper(this.printer);
}
