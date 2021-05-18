import 'package:flutter/material.dart';
import 'package:flutter_template/config/pre_app_config.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_block_provider.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/util/Either.dart';

import 'app.dart';
import 'config/flavor_config.dart';
import 'config/network_constants.dart';
import 'log/logger.dart';
import 'model/task/task_status.dart';

void main() async {
  FlavorConfig.set(
    Flavor.DEV,
    FlavorValues(
      baseUrlApi: baseUrlDev + apiPrefix,
    ),
  );

  await preAppConfig();

  Either<Exception, Task> test = Either.build(() => throw Exception());

  if (test is Error) {
    Logger.d('This is some exception');
  } else {
    Logger.d('This is success object with value Task object');
  }

  Either<Exception, Task> test1 =
  Either.build(() => Task(title: 't', status: TaskStatus.done, id: '1'));

  if (test1 is Error) {
    Logger.d('This is some exception');
  } else {
    Logger.d('This is success object with value Task object');
  }

  runApp(globalAuthBlockProvider(child: App()));
}
