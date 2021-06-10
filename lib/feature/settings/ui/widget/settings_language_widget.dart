import 'package:flutter/material.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:provider/provider.dart';

import 'settings_language_icon_widget.dart';

class SettingsLanguageWidget extends StatefulWidget {
  final String selectedLanguage;

  const SettingsLanguageWidget({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  _SettingsLanguageWidgetState createState() => _SettingsLanguageWidgetState();
}

class _SettingsLanguageWidgetState extends State<SettingsLanguageWidget>
    with WidgetsBindingObserver {
  late String selectedLanguage;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this); // Subscribe to changes
    super.initState();
    selectedLanguage = widget.selectedLanguage;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    setUpSelectedLanguage(
        context, WidgetsBinding.instance!.window.locales.first.languageCode);
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
            onTap: () => setUpSelectedLanguage(context, EN.languageCode),
            child: IgnorePointer(
              child: Row(
                children: [
                  SettingsLanguageIcon(languageCode: EN.languageCode),
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
                    value: EN.languageCode,
                    groupValue: selectedLanguage,
                    onChanged: (value) =>
                        setState(() => selectedLanguage = value!),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: InkWell(
            onTap: () => setUpSelectedLanguage(context, MK.languageCode),
            child: IgnorePointer(
              child: Row(
                children: [
                  SettingsLanguageIcon(languageCode: MK.languageCode),
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
                    value: MK.languageCode,
                    groupValue: selectedLanguage,
                    onChanged: (value) =>
                        setState(() => selectedLanguage = value!),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void setUpSelectedLanguage(
      BuildContext context, String? currentLanguage) async {
    if (currentLanguage == null) currentLanguage = EN.languageCode;

    if (selectedLanguage != currentLanguage) {
      setState(() {
        selectedLanguage = currentLanguage!;
      });

      final localizationNotifier =
          Provider.of<LocalizationNotifier>(context, listen: false);
      await localizationNotifier.setLocale(currentLanguage);
    }
  }
}
