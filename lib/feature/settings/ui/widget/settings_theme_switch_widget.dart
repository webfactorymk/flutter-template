import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsThemeSwitch extends StatefulWidget {
  const SettingsThemeSwitch({Key? key}) : super(key: key);

  @override
  _SettingsThemeSwitchState createState() => _SettingsThemeSwitchState();
}

class _SettingsThemeSwitchState extends State<SettingsThemeSwitch> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    updateTheme(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: InkWell(
        onTap: () => toggleBrightness(context, !isDarkTheme),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.palette_outlined,
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.dark_theme,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: isDarkTheme,
              onChanged: (val) => toggleBrightness(context, val),
            ),
          ],
        ),
      ),
    );
  }

  void updateTheme(BuildContext context) {
    final bool currentBrightness =
        Theme.of(context).brightness == Brightness.dark;
    if (currentBrightness != isDarkTheme) {
      setState(() {
        isDarkTheme = currentBrightness;
      });
    }
  }

  toggleBrightness(BuildContext context, bool val) async {
    setState(() {
      isDarkTheme = val;
    });
    final themeNotifier =
        Provider.of<ThemeChangeNotifier>(context, listen: false);
    await themeNotifier.toggleTheme();
  }
}
