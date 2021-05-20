import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/signup/ui/signup_screen.dart';

class SignUpPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => SignUpScreen(),
    );
  }
}
