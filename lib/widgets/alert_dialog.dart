import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/routing/navigation_observer.dart';

const errorDialogRouteName = 'errorDialogRouteName';

Future<void> showAlert(
  context, {
  required String title,
  String? message,
  RouteSettings? settings,
  bool isDismissible = true,
  bool willPopScope = true,
  required String primaryButtonText,
  VoidCallback? onPrimaryClick,
  String? secondaryButtonText,
  VoidCallback? onSecondaryClick,
}) {
  return showDialog<bool>(
    context: context,
    routeSettings: settings,
    barrierDismissible: isDismissible,
    builder: (BuildContext dialogContext) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message ?? ''),
          actions: _dialogButtons(
            dialogContext,
            primaryButtonText,
            onPrimaryClick,
            secondaryButtonText,
            onSecondaryClick,
          ),
        );
      } else {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message ?? ''),
            actions: _dialogButtons(
              dialogContext,
              primaryButtonText,
              onPrimaryClick,
              secondaryButtonText,
              onSecondaryClick,
            ),
          ),
        );
      }
    },
  );
}

List<Widget> _dialogButtons(
  BuildContext context,
  String primaryButtonText, [
  VoidCallback? onPrimaryClick,
  String? secondaryButtonText,
  VoidCallback? onSecondaryClick,
]) =>
    [
      if (secondaryButtonText != null)
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(secondaryButtonText),
          onPressed: () {
            onSecondaryClick?.call();
            Navigator.of(context).pop();
          },
        ),
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: Text(primaryButtonText),
        onPressed: () {
          onPrimaryClick?.call();
          Navigator.of(context).pop();
        },
      ),
    ];

/// Displays error alert with OK button and generic error title and optional message.
/// Does not overlap other error dialogs, except force update which has higher priority.
Future<void> showErrorAlert(
  context, {
  String? title,
  String? message,
  String? primaryButtonText,
  VoidCallback? onPrimaryClick,
  bool isDismissible = true,
}) {
  final navigationObserver = serviceLocator<NavigationRoutesObserver>();
  if (navigationObserver.isErrorDialogDisplayed ||
      navigationObserver.isForceUpdateDialogDisplayed) {
    return Future.value();
  }

  return showAlert(
    context,
    title: title ?? 'an_error_happened', //todo localize
    message: message,
    settings: RouteSettings(name: errorDialogRouteName),
    isDismissible: isDismissible,
    primaryButtonText: primaryButtonText ?? 'OK', //todo localize
    onPrimaryClick: onPrimaryClick,
  );
}
