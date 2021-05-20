import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/login/ui/login_screen.dart';

class LoginPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => LoginScreen(),
    );
  }
}
