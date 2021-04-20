import 'package:flutter/material.dart';

/// Widget class representing a reusable container meant to contain a child
/// that has a keyboard dismissal property (when pressed anywhere on screen
/// opened keyboard should be dismissed).
class KeyBoardDismissalContainer extends StatelessWidget {
  final Widget child;

  const KeyBoardDismissalContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: child);
  }
}
