import 'package:flutter/widgets.dart';

/// A Function Widget
///
/// Converts a function into a widget for better handling by the Flutter
/// framework when the widget tree is rebuilt:
/// - always uses the right [BuildContext]
/// - doesn't confuse hot reload
///
/// <b>
/// The body is called by this widget's build method and must be a pure function.
/// I.e. always return the same Widget, without side effects and without holding state.
/// </b><br />
///
/// See
/// [Widget Build](https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html)
/// [FunctionalWidget](https://pub.dev/packages/functional_widget),
/// [Flutter Function Issue](https://github.com/flutter/flutter/issues/19269),
/// [Broken Animation Example](https://dartpad.dev/?id=1870e726d7e04699bc8f9d78ba71da35&null_safety=true)
class FunctWidget extends StatelessWidget {
  final Widget Function(BuildContext) body;

  const FunctWidget({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(context);
  }
}
