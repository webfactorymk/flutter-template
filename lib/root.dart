import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/config/post_app_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:flutter_template/resources/theme/app_theme.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:flutter_template/routing/app_router_delegate.dart';
import 'package:flutter_template/util/app_lifecycle_observer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Root extends StatefulWidget {
  final AppRouterDelegate _appRouterDelegate;
  final LocalizationNotifier _localizationNotifier;

  const Root(
    this._appRouterDelegate,
    this._localizationNotifier, {
    Key? key,
  }) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!FlavorConfig.isProduction()) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => insertOverlay(
          context, serviceLocator.get<String>(instanceName: buildVersionKey)));
    }
  }

  @override
  Widget build(BuildContext context) {
    postAppConfig();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChangeNotifier>(
          create: (context) =>
              serviceLocator.get<PreferencesHelper>().themePreferred,
        ),
        ChangeNotifierProvider<LocalizationNotifier>(
          create: (context) => widget._localizationNotifier,
        ),
        ChangeNotifierProvider<AppRouterDelegate>(
          create: (context) => widget._appRouterDelegate,
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
            routerDelegate: widget._appRouterDelegate,
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
