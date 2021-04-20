import 'package:flutter/services.dart';

enum ValidatorType {
  LENGTH,
  MATCH,
  NO_MATCH,
  EMAIL,
  NON_EMPTY,
  LETTERS_ONLY,
  NO_VALIDATION
}

bool isEmailValid(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern.toString());
  return (!regex.hasMatch(value)) ? false : true;
}

bool isPasswordValid(String value) {
  return value.length >= 8;
}

bool doPasswordsMatch(String password, String passwordConfirm) =>
    (password == passwordConfirm);

TextInputFormatter lettersOnlyFormatter() => FilteringTextInputFormatter.deny(
      RegExp(
          "[0-9\\.\\,\\!\\@\\#\\%\\^\\&\\*\\(\\)\\_\\-\\+\\=\\{\\[\\]\\}\\;\\:\\'\\/\\>\\<\\?\"\$]"),
    );
