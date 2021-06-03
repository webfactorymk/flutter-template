import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup_cubit.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (listenerContext, state) {},
        builder: (context, state) {
          if (state is SignupInProgress || state is SignupSuccess) {
            return CircularProgressIndicator();
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
    BlocProvider.of<SignupCubit>(context)
        .onUserSignup(_emailController.text, _passwordController.text);
  }
}
