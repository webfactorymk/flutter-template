import 'package:flutter/material.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/feature/settings/ui/widget/settings_language_widget.dart';
import 'package:flutter_template/feature/settings/ui/widget/settings_theme_switch_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_template/di/service_locator.dart';
import 'widget/settings_header_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsHeader(header: AppLocalizations.of(context)!.theme),
          SettingsThemeSwitch(),
          Container(color: Colors.grey, height: 1),
          SettingsHeader(header: AppLocalizations.of(context)!.language),
          SettingsLanguageWidget(
              selectedLanguage:
                  serviceLocator.get<PreferencesHelper>().languagePreferred)
        ],
      ),
    );
  }
}
