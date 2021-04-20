import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_cubit.dart';
import 'package:flutter_template/user/user_manager.dart';

BlocProvider<GlobalAuthCubit> globalAuthBlockProvider({child: Widget}) {
  return BlocProvider<GlobalAuthCubit>(
    create: (context) {
      return GlobalAuthCubit(serviceLocator.get<UserManager>());
    },
    child: child,
  );
}
