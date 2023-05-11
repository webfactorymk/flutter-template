import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/config/post_app_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:flutter_template/resources/theme/app_theme.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:flutter_template/widgets/debug_overlay.dart';
import 'package:flutter_template/routing/app_router_delegate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouterDelegate _appRouterDelegate;
  late final LocalizationNotifier _localizationNotifier;

  @override
  void initState() {
    super.initState();
    serviceLocator.get<AppLifecycleObserver>().activate();
    _appRouterDelegate = AppRouterDelegate(
      rootNavigatorKey,
      authNavigatorKey,
      homeNavigatorKey,
      serviceLocator.get<UserManager>(),
    );
    _localizationNotifier = LocalizationNotifier(
        serviceLocator.get<PreferencesHelper>().languagePreferred);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postAppConfig();
    if (!FlavorConfig.isProduction()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugOverlay(context);
      });
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
          create: (context) =>
              serviceLocator.get<PreferencesHelper>().themePreferred,
        ),
        ChangeNotifierProvider<LocalizationNotifier>(
          create: (context) => _localizationNotifier,
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
          supportedLocales: [EN, MK],
          home: Router(
            routerDelegate: _appRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    serviceLocator.get<AppLifecycleObserver>().deactivate();
    super.dispose();
  }
}
