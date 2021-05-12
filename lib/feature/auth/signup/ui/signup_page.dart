import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup.dart';
import 'package:flutter_template/widgets/circular_progress_indicator.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (listenerContext, state) {
          if (state is SignUpSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is SignUpInProgress) {
            return BasicCircularProgressIndicator();
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up Page'),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Email",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Sign up'),
                      onPressed: () => _onSignUpPressed(context),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _onSignUpPressed(BuildContext context) {
    BlocProvider.of<SignUpCubit>(context)
        .onUserSignUp(_emailController.text, _passwordController.text);
  }
}
