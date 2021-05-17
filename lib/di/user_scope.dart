import 'package:flutter_template/data/repository/tasks/tasks_cache_data_source.dart';
import 'package:flutter_template/data/repository/tasks/tasks_remote_data_source.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/network/tasks_api_service.dart';

/// User scoped components that are created when the user logs in
/// and destroyed on logout.
const String userScopeName = 'userScope';

/// Use [setupUserScope] to setup components that need to be alive as
/// long as there is a logged in user. Provide a dispose method when
/// registering that will be invoked when this scope is torn down.
Future<void> setupUserScope(String userId) async {

  //todo add other user scope dependencies here, mind to provide dispose methods

  // Repositories
  final TasksApiService tasksApiService = serviceLocator.get<TasksApiService>();
  final TasksRepository tasksRepository = TasksRepository(
    remote: TasksRemoteDataSource(userId, tasksApiService),
    cache: TasksCacheDataSource(userId),
  );

  serviceLocator
    ..registerSingleton<TasksRepository>(tasksRepository,
        dispose: (instance) => instance.teardown());
}

/// Use [teardownUserScope] to dispose the user scoped components if
/// you haven't provided a dispose method when registering.
Future<void> teardownUserScope() async {

  //todo teardown user scope components registered without dispose method here
}
