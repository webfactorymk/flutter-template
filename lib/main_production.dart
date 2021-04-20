import 'package:flutter/material.dart';
import 'package:flutter_template/config/pre_app_config.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_block_provider.dart';

import 'app.dart';
import 'config/flavor_config.dart';

void main() async {
  FlavorConfig.set(
    Flavor.PRODUCTION,
    FlavorValues(
      baseApiUrl: 'example.com/api/',
    ),
  );

  await preAppConfig();

  runApp(globalAuthBlockProvider(child: App()));
}
