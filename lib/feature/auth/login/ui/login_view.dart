import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({Key? key, this.sessionExpiredRedirect = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (listenerContext, state) {},
        builder: (context, state) {
          if (state is LoginInProgress) {
            return CircularProgressIndicator();
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Login Page'),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _userNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Username",
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
                      child: Text('Login'),
                      onPressed: () => _onLoginPressed(context),
                    ),
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
            );
          }
        },
      ),
    );
  }

  void _onLoginPressed(BuildContext context) {
    BlocProvider.of<LoginCubit>(context)
        .onUserLogin(_userNameController.text, _passwordController.text);
  }

  void _onSignUpPressed(BuildContext context) {
    context.read<AuthRouterDelegate>().setSignupNavState();
  }
}
