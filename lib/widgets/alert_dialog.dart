import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/network/util/http_exception_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_template/util/enum_util.dart';

Future<bool?> showAlertDialog(
  BuildContext context, {
  String title = '',
  String message = '',
  List<Widget> popupActions(BuildContext context)?,
  RouteSettings? settings,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible:
        false, // The user must tap button! Back button works though...
    routeSettings: settings,
    builder: (BuildContext dialogContext) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: popupActions != null
              ? popupActions(dialogContext)
              : const <Widget>[],
        );
      } else {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: popupActions != null
                ? popupActions(dialogContext)
                : const <Widget>[],
          ),
        );
      }
    },
  );
}

Future<void> showGenericErrorAlert(context, {@required dynamic error, bool popUntilFirst = false}) {

  //todo find a better way to not show the dialog
  // if (serviceLocator<NavigationRoutesObserver>().isAppUpdateDisplayed() ||
  //     serviceLocator<NavigationRoutesObserver>().isGenericErrorDialogDisplayed()) {
  //   return Future(null);
  // }
  //
  // if (error != null && (error is UnauthorizedUserException || error is NewAppVersionException)) {
  //   return Future(null);
  // }

  Log.d('Error dialog: $error');
  var errorMessage = AppLocalizations.of(context)!.error_title;
  if (error != null && !kReleaseMode) {
    errorMessage = '\n' + error.toString();
  }
  if (error is HttpExceptionCode) {
    errorMessage = AppLocalizations.of(context)!.default_error;
  }
  return showAlertDialog(
    context,
    title: AppLocalizations.of(context)!.error_title,
    message: errorMessage,
    popupActions: (dialogContext) => [
      FlatButton(
        child:
            Text(AppLocalizations.of(context)!.ok.toUpperCase()),
        onPressed: () {
          if (popUntilFirst) {
            Navigator.popUntil(dialogContext, (route) => route.isFirst);
          } else {
            Navigator.of(dialogContext, rootNavigator: true).pop();
          }
        },
      ),
    ],
  );
}
