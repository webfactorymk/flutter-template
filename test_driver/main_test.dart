import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/config/network_constants.dart';
import 'package:flutter_template/config/pre_app_config.dart';

import 'platform_comm_test_widget.dart';

Future<void> main() async {
  FlavorConfig.set(
    Flavor.MOCK,
    FlavorValues(
      baseUrlApi: baseUrlDev + apiPrefix,
    ),
  );

  await preAppConfig();

  runApp(PlatformCommTestWidget());
}