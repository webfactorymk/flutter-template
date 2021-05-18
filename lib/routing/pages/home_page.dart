import 'package:flutter/material.dart';
import 'package:flutter_template/routing/home_shell.dart';

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => HomeShell(),
    );
  }
}
