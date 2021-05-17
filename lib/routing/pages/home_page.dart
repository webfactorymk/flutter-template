import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/home_screen.dart';

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => HomeScreen(),
    );
  }
}
