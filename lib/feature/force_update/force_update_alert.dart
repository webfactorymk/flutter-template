import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const APP_STORE_URL = 'app store url'; //todo add app store url in config file
const PLAY_STORE_URL =
    'play store url'; //todo add play store url in config file

Future<void> showForceUpdateAlert(BuildContext context) {
  // todo don't show the dialog if it's already displayed
  // if (serviceLocator<NavigationRoutesObserver>().isAppUpdateDisplayed()) {
  //   return null;
  // }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    routeSettings: RouteSettings(name: 'Routes.alertUpdate'),
    builder: (BuildContext dialogContext) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.update_alert_title),
          content: Text(AppLocalizations.of(context)!.update_alert_message_ios),
          actions: [
            FlatButton(
              child: Text(AppLocalizations.of(context)!.update_cta),
              onPressed: () {
                _launchURL(APP_STORE_URL);
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
            ),
          ],
        );
      } else {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)!.update_alert_title),
            content: Text(
                AppLocalizations.of(context)!.update_alert_message_android),
            actions: [
              FlatButton(
                child: Text(AppLocalizations.of(context)!.update_cta),
                onPressed: () {
                  _launchURL(PLAY_STORE_URL);
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      }
    },
  );
}

void _launchURL(String url) async {
  var encodedUrl = Uri.encodeFull(url);
  if (await canLaunch(encodedUrl)) {
    await launch(encodedUrl);
  } else {
    throw 'Could not launch $encodedUrl';
  }
}
