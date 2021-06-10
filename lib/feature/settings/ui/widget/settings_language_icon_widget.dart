import 'package:flutter/material.dart';

class SettingsLanguageIcon extends StatelessWidget {
  final String languageCode;

  const SettingsLanguageIcon({Key? key, required this.languageCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 24,
        width: 24,
        child: Center(
          child: Text(
            languageCode,
            style: TextStyle(fontSize: 12),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.5,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }
}
