import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up Page'),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Sign up'),
                onPressed: () => _onSignUpPressed(context),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed(BuildContext context) {}
}
