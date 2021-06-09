import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/auth/signup/ui/username/username_view.dart';

class UsernamePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) => UsernameView(),
    );
  }
}
