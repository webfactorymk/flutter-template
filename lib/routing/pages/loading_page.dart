import 'package:flutter/material.dart';
import 'package:flutter_template/feature/loading/ui/loading_screen.dart';

class LoadingPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => LoadingScreen(),
    );
  }
}
