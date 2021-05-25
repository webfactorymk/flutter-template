import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_cubit.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:flutter_template/resources/strings.dart';
import 'package:flutter_template/routing/back_button_dispatcher.dart';
import 'package:flutter_template/routing/global_router_delegate.dart';
import 'package:flutter_template/routing/home_state.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'feature/auth/login/bloc/login.dart';
import 'feature/auth/signup/bloc/signup.dart';
import 'routing/auth_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

//todo replace state with flutter hooks

class _AppState extends State<App> {
  String _buildVersion = '';

  Future<void> _getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _buildVersion =
          'Build version ${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  void initState() {
    super.initState();
    serviceLocator.get<AppLifecycleObserver>().activate();

    if (!FlavorConfig.isProduction()) {
      _getBuildVersion();
      serviceLocator
          .get<PlatformComm>()
          .echoMessage('echo')
          .catchError((error) => 'Test platform method error: $error')
          .then((backEcho) => Logger.d("Test message 'echo' - '$backEcho'"));
      serviceLocator
          .get<PlatformComm>()
          .echoObject(TaskGroup('TG-id', 'Test group', List.of(['1', '2'])))
          .then((backEcho) => Logger.d("Test message TaskGroup - '$backEcho'"))
          .catchError((error) => Logger.e('Test platform method err.: $error'));
    }
  }

  @override
  void dispose() {
    serviceLocator.get<AppLifecycleObserver>().deactivate();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!FlavorConfig.isProduction()) {
      WidgetsBinding.instance
          ?.addPostFrameCallback((_) => _insertOverlay(context, _buildVersion));
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalAuthCubit authCubit =
        GlobalAuthCubit(serviceLocator.get<UserManager>());
    final LoginCubit loginCubit = LoginCubit(serviceLocator.get<UserManager>());
    final SignUpCubit signUpCubit = SignUpCubit(
        serviceLocator.get<UserApiService>(),
        serviceLocator.get<UserManager>());

    final AppRouterDelegate _routerDelegate = AppRouterDelegate();
    final AppBackButtonDispatcher _backButtonDispatcher =
        AppBackButtonDispatcher(_routerDelegate);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeState(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GlobalAuthCubit>(create: (context) {
            return authCubit;
          }),
          BlocProvider<LoginCubit>(create: (context) {
            return loginCubit;
          }),
          BlocProvider<SignUpCubit>(create: (context) {
            return signUpCubit;
          }),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'NotoSansJP',
          ),
          localizationsDelegates: [
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            const LocalizedStringsDelegate(['en', 'mk'],
                fallbackLocale: const Locale('en')),
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('mk'), // Macedonian
          ],
          home: Router(
              routerDelegate: _routerDelegate,
              backButtonDispatcher: _backButtonDispatcher),
        ),
      ),
    );
  }

  void _insertOverlay(BuildContext context, buildVersion) {
    Overlay.of(context)?.insert(
      OverlayEntry(builder: (context) {
        var safePadding = MediaQuery.of(context).padding.bottom;
        final size = MediaQuery.of(context).size;
        final textSize = (TextPainter(
                text: TextSpan(
                    text: buildVersion,
                    style: Theme.of(context).textTheme.caption),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size;

        return Positioned(
          height: 56,
          top: size.height - max(safePadding, 20),
          left: (size.width - textSize.width) / 2,
          child: IgnorePointer(
            child: Text(
              buildVersion,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        );
      }),
    );
  }
}
