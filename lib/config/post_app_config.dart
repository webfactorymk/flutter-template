import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/platform_comm/platform_comm.dart';

/// Configuration that needs to be done after the Flutter app starts goes here.
///
/// To minimize the app loading time keep this setup fast and simple.
Future<void> postAppConfig() async {
  // This code will be executed after the build method
  // because of the way async functions are scheduled
  if (!FlavorConfig.isProduction()) {
    serviceLocator.get<String>(instanceName: buildVersionKey);
    serviceLocator
        .get<PlatformComm>()
        .echoMessage('echo')
        .catchError((error) => 'Test platform method error: $error')
        .then((backEcho) => Log.d("Test message 'echo' - '$backEcho'"));
    serviceLocator
        .get<PlatformComm>()
        .echoObject(TaskGroup('TG-id', 'Test group', List.of(['1', '2'])))
        .then((backEcho) => Log.d("Test message TaskGroup - '$backEcho'"))
        .catchError((error) => Log.e('Test platform method err.: $error'));
  }
}

void insertOverlay(BuildContext context, buildVersion) {
  Overlay.of(context)?.insert(
    OverlayEntry(builder: (context) {
      var safePadding = MediaQuery.of(context).padding.bottom;
      final size = MediaQuery.of(context).size;
      final textSize = (TextPainter(
              text: TextSpan(
                  text: buildVersion,
                  style: Theme.of(context).textTheme.caption),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

      return Positioned(
        height: 56,
        top: size.height - max(safePadding, 20),
        left: (size.width - textSize.width) / 2,
        child: IgnorePointer(
          child: Text(
            buildVersion,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      );
    }),
  );
}
