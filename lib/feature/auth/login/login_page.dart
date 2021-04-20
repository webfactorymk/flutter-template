import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  final bool sessionExpiredRedirect;

  LoginPage({Key? key, this.sessionExpiredRedirect = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Login Page'),
    );
  }
}

