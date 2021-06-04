import 'package:flutter/material.dart';
import 'package:flutter_template/feature/settings/ui/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: Center(
          child: SettingsView(),
        ),
      ),
    );
  }
}
