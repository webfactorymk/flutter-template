import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/feature/auth/login/ui/login_view.dart';
import 'package:flutter_template/user/user_manager.dart';

class LoginPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) => BlocProvider<LoginCubit>(
        create: (BuildContext context) =>
            LoginCubit(serviceLocator.get<UserManager>()),
        child: LoginView(),
      ),
    );
  }
}
