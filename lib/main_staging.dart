import 'package:flutter/material.dart';
import 'package:flutter_template/config/pre_app_config.dart';
import 'package:flutter_template/util/preferences.dart';

import 'app.dart';
import 'config/flavor_config.dart';
import 'config/network_constants.dart';

Future<void> main() async {
  FlavorConfig.set(
    Flavor.STAGING,
    FlavorValues(
      baseUrlApi: baseUrlStage + apiPrefix,
    ),
  );

  await preAppConfig();

  runApp(App(
    storedLanguageCode: await getStoredLanguage(),
    themeChangeNotifier: await getPreferredTheme(),
  ));
}
