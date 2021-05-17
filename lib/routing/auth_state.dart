import 'package:flutter/cupertino.dart';

class AuthState extends ChangeNotifier {
  bool _signUpPressed;

  AuthState() : _signUpPressed = false;

  bool get signUpPressed => _signUpPressed;

  set signUpPressed(bool signUpPressed) {
    _signUpPressed = signUpPressed;
    notifyListeners();
  }
}
