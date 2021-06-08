import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:flutter_template/resources/theme/app_theme.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:flutter_template/routing/app_router_delegate.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  final String storedLanguageCode;
  final ThemeChangeNotifier themeChangeNotifier;

  App({Key? key, required this.storedLanguageCode, required this.themeChangeNotifier})
      : super(key: key);

  @override
  _AppState createState() => _AppState();
}

//todo replace state with flutter hooks, if you want to

class _AppState extends State<App> {
  String _buildVersion = '';
  late AppRouterDelegate _appRouterDelegate;
  late final localizationNotifier;

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
    //todo await post_app_config() ?
    serviceLocator.get<AppLifecycleObserver>().activate();
    _appRouterDelegate = AppRouterDelegate(navigatorKey, authNavigatorKey,
        homeNavigatorKey, serviceLocator.get<UserManager>());

    if (!FlavorConfig.isProduction()) {
      _getBuildVersion();
      serviceLocator
          .get<PlatformComm>()
          .echoMessage('echo')
          .catchError((error) => 'Test platform method error: $error')
          .then((backEcho) => Log.d("Test message 'echo' - '$backEcho'"));
      serviceLocator
          .get<PlatformComm>()
          .echoObject(TaskGroup('TG-id', 'Test group', List.of(['1', '2'])))
          .then((backEcho) => Log.d("Test message TaskGroup - '$backEcho'"))
          .catchError((error) => Log.e('Test platform method err.: $error'));
    }

    localizationNotifier = LocalizationNotifier(widget.storedLanguageCode);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChangeNotifier>(
          create: (context) => widget.themeChangeNotifier,
        ),
        ChangeNotifierProvider<LocalizationNotifier>(
          create: (context) => localizationNotifier,
        ),
        ChangeNotifierProvider<AppRouterDelegate>(
          create: (context) => _appRouterDelegate,
        ),
      ],
      child: Consumer2<LocalizationNotifier, ThemeChangeNotifier>(
          builder: (context, localeObject, themeObject, _) {
        return MaterialApp(
          theme: themeLight(),
          darkTheme: themeDark(),
          themeMode: themeObject.getThemeMode,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: localeObject.locale,
          supportedLocales: L10n.all,
          home: Router(
            routerDelegate: _appRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      }),
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
