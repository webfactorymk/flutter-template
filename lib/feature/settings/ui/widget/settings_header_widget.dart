import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String header;

  const SettingsHeader({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 12, 0, 0),
      child: Text(
        header,
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColorDark,
            fontSize: 16,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
