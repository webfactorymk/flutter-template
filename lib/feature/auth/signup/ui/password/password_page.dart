import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/signup/ui/password/password_view.dart';

class PasswordPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) => PasswordView(),
    );
  }
}