import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/auth/signup/bloc/signup_cubit.dart';
import 'package:flutter_template/feature/auth/signup/ui/signup_view.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_manager.dart';

class SignupPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) => BlocProvider<SignupCubit>(
        create: (BuildContext context) => SignupCubit(
          serviceLocator.get<UserApiService>(),
          serviceLocator.get<UserManager>(),
        ),
        child: SignupView(),
      ),
    );
  }
}
