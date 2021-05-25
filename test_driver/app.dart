import 'package:flutter_driver/driver_extension.dart';
import 'main_test.dart' as app;

// Instruments the app
// See https://flutter.dev/docs/cookbook/testing/integration/introduction
void main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  await app.main();
}

// To run the tests, run the following command from the root of the project:
//
/// fvm flutter drive --target=test_driver/app.dart --flavor=mock
