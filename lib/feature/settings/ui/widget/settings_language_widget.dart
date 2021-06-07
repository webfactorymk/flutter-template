import 'package:flutter/material.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'settings_language_icon_widget.dart';

class SettingsLanguageWidget extends StatefulWidget {
  const SettingsLanguageWidget({Key? key}) : super(key: key);

  @override
  _SettingsLanguageWidgetState createState() => _SettingsLanguageWidgetState();
}

class _SettingsLanguageWidgetState extends State<SettingsLanguageWidget> with WidgetsBindingObserver{
  String selectedLanguage = L10n.getLocale(AppLocalizations.supportedLocales.first.languageCode).languageCode;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this); // Subscribe to changes
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    setUpSelectedLanguage(context, Localizations.localeOf(context).languageCode);
  }


  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: InkWell(
            onTap: () => setUpSelectedLanguage(context, L10n.all[0].languageCode),
            child: Row(
              children: [
                SettingsLanguageIcon(languageCode: L10n.all[0].languageCode),
                Expanded(
                  child: Text(
                    'English',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Radio<String>(
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColorDark,
                  value: L10n.all[0].languageCode,
                  groupValue: selectedLanguage,
                  onChanged: (value) =>
                      setState(() => selectedLanguage = value!),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: InkWell(
            onTap: () => setUpSelectedLanguage(context, L10n.all[1].languageCode),
            child: Row(
              children: [
                SettingsLanguageIcon(languageCode: L10n.all[1].languageCode),
                Expanded(
                  child: Text(
                    'Macedonian',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Radio<String>(
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColorDark,
                  value: L10n.all[1].languageCode,
                  groupValue: selectedLanguage,
                  onChanged: (value) =>
                      setState(() => selectedLanguage = value!),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void setUpSelectedLanguage(BuildContext context, String? currentLanguage) {
    if (currentLanguage == null) currentLanguage = L10n.all[0].languageCode;

    print(selectedLanguage + ' ' + currentLanguage);
    if (selectedLanguage != currentLanguage) {
      setState(() {
        selectedLanguage = currentLanguage!;
      });

      final localizationNotifier =
          Provider.of<LocalizationNotifier>(context, listen: false);
      localizationNotifier.setLocale(L10n.getLocale(currentLanguage));
    }
  }
}
