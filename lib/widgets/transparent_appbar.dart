import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? title;
  final Widget? action;
  final Widget? leading;
  final double leadingWidth;

  TransparentAppBar({
    Key? key,
    this.title,
    this.action,
    this.leading,
    this.leadingWidth = 56.0,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (action != null) {
      actions.add(action!);
    }
    return AppBar(
      centerTitle: true,
      title: title,
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      leading: leading,
      leadingWidth: leadingWidth,
      actions: actions,
    );
  }
}
