import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/app_routes.dart';
import 'package:flutter_template/log/logger.dart';
import 'package:flutter_template/network/util/http_exception_code.dart';
import 'package:flutter_template/resources/string_key.dart';
import 'package:flutter_template/resources/strings.dart';
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

  Logger.d('Error dialog: $error');
  var errorMessage = Strings.localizedString(context, StringKey.error_message);
  if (error != null && !kReleaseMode) {
    errorMessage = '\n' + error.toString();
  }
  if (error is HttpExceptionCode) {
    var errorKey = enumFromString(StringKey.values, error.errorResponse);
    errorMessage = Strings.localizedString(
        context, errorKey != null ? errorKey : StringKey.default_error);
  }
  return showAlertDialog(
    context,
    title: Strings.localizedString(context, StringKey.error_title),
    message: errorMessage,
    settings: RouteSettings(name: Routes.alertError),
    popupActions: (dialogContext) => [
      FlatButton(
        child:
            Text((Strings.localizedString(dialogContext, StringKey.ok)).toUpperCase()),
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