import 'package:flutter/material.dart';
import 'package:flutter_template/config/pre_app_config.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_block_provider.dart';

import 'app.dart';
import 'config/flavor_config.dart';
import 'config/network_constants.dart';

void main() async {
  FlavorConfig.set(
    Flavor.STAGING,
    FlavorValues(
      baseUrlApi: baseUrlStage + apiPrefix,
    ),
  );

  await preAppConfig();

  runApp(globalAuthBlockProvider(child: App()));
}
