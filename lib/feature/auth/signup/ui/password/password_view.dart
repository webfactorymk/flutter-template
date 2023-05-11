import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup_cubit.dart';

class PasswordView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _passwordController = TextEditingController();

  PasswordView({Key? key, this.sessionExpiredRedirect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (listenerContext, state) {},
        builder: (context, state) {
          if (state is SignupInProgress || state is SignupSuccess) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Password Page'),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 20),
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

  _onSignUpPressed(BuildContext context) {
    BlocProvider.of<SignupCubit>(context)
        .onPasswordEntered(_passwordController.text);
    BlocProvider.of<SignupCubit>(context).onUserSignup();
  }
}
