import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup_cubit.dart';

class UsernameView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (listenerContext, state) {
          if (state is AwaitPasswordInput) {
            context.read<AuthRouterDelegate>().setSignupPasswordNavState();
          }
        },
        builder: (context, state) {
          if (state is SignupInProgress || state is SignupSuccess) {
            return CircularProgressIndicator();
          } else {
            _usernameController.text = (state as AwaitUserInput).username;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up Page'),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Username",
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Next'),
                      onPressed: () => _onNextPressed(context),
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

  void _onNextPressed(BuildContext context) {
    BlocProvider.of<SignupCubit>(context)
        .onUsernameEntered(_usernameController.text);
  }
}
