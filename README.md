# Flutter Template
Flutter template project - A simple TODO list app 

## Getting Started

### Run Configurations

In addition to the [Flutter's build modes][flutter_build_modes] (debug, profile, release), 
the project has 4 flavours/schemas for defining environments:
- **mock** - mock environment that uses mock values. Launches `main_mock.dart`
- **dev** - development environment that targets a development server. Launches `main_dev.dart`
- **staging** - staging environment that targets a staging server. Launches `main_staging.dart`
- **production** - production environment that targets a production server. Launches `main_production.dart`

To run the app use the following command:
```
flutter run --flavor dev -t lib/main_dev.dart
```
or edit run configurations in Android Studio:
- Go to EditConfigurations...
- Enter configuration name: DEV, STAGE, PROD
- Enter dart entry point: main_dev.dart, main_staging.dart, main_production.dart
- Enter additional run args: --flavor=dev, --flavor=staging, --flavor=production
- Enter build flavor: dev, staging, production

See [flavor_config.dart] for environment specific config.

For adding an additional Flutter flavours see the [official documentation][flutter_flavours_official] 
and [this blog post][blog_flavouring_flutter]. 

[flutter_build_modes]: https://flutter.dev/docs/testing/build-modes
[flavor_config.dart]: ./lib/config/flavor_config.dart
[flutter_flavours_official]: https://flutter.dev/docs/deployment/flavors
[blog_flavouring_flutter]: https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36

### Resolve TODOs

Go over the TODOs scattered around the project and resolve as much as possible. They will help you configure the project to your needs.

In AndroidStudio you can view all TODOs in the bottom tab as shown in this picture:

![TODOs bottom tab in AS](http://jubin.tech/assets/pic/20181023-1-todo-in-AS.png)


# Data Management

![Alt text][high_lvl_diagram]

[high_lvl_diagram]: diagrams/high_lvl_diagram.png "High level diagram"


## [TasksDataSource]

This is the main entry point for accessing and manipulating tasks data. The rest of the app should not invoke tasks' endpoints directly or query cached data. All tasks operations should go through this service.

Implementations:
- [**TasksRemoteDataSource**] - Uses the ApiService to contact a remote server;
- [**TasksCacheDataSource**] - Uses in-memory cache to retrieve tasks;
- [**TasksRepository**][tasks_repository] - Uses both *TasksRemoteDataSource* and *TasksCacheDataSource* to fetch cached data when available; Provides subscription for updates;
- [**TasksStubDataSource**][tasks_stub_data_source] - Stub;

[TasksDataSource]: ./lib/data/tasks_data_source.dart
[**TasksRemoteDataSource**]: ./lib/data/tasks_remote_data_source.dart
[**TasksCacheDataSource**]: ./lib/data/tasks_cache_data_source.dart
[tasks_repository]: ./lib/data/tasks_repository.dart


## ApiService

Abstraction over the API communication that defines (all) endpoints. 
This templates uses [Chopper], an http client generator, to make network requests.

- [UserApiService] - User related endpoints
- [UserAuthApiService] - User re-authentication endpoints
- [TasksApiService] - Tasks, TaskGroups, and task actions endpoints

[UserApiService]: lib/network/user_api_service.dart
[UserAuthApiService]: lib/network/user_auth_api_service.dart
[TasksApiService]: lib/network/tasks_api_service.dart

[Chopper]: https://pub.dev/packages/chopper


## JSON and Serialization

JSON models are serialized using a code generation library.

For one time code generation run this command in terminal: `flutter pub run build_runner build`

For subsequent code generations with conflicting outputs: `flutter pub run build_runner build --delete-conflicting-outputs`

For more information and generating code continuously see [the documentation][json_serialization].

[json_serialization]: https://flutter.dev/docs/development/data-and-backend/json

## Declarative UI

[Flutter is declarative framework][declarative_ui]. This means that Flutter builds its user interface to reflect the current state of the app. 

<img src="https://flutter.dev/assets/development/data-and-backend/state-mgmt/ui-equals-function-of-state-54b01b000694caf9da439bd3f774ef22b00e92a62d3b2ade4f2e95c8555b8ca7.png" alt="High level diagram" width="350">

~~This template attempts to be unopinionated and does not yet use a [state management tool][state_management_options].~~ ...we use [BLoC] now. But, each app service has an updates [Stream][dart_streams] that clients can subscribe to and receive state updates. See the [UpdatesStream<T> mixin][updates_mixin]. It's up to you to use a tool of your choice, or don't use one at all. 
See `TasksRepository#taskEventUpdatesStream` and `TasksRepository#taskGroupUpdatesStream` in [TasksRepository][tasks_repository]

[declarative_ui]: https://flutter.dev/docs/development/data-and-backend/state-mgmt/declarative
[state_management_options]: https://flutter.dev/docs/development/data-and-backend/state-mgmt/options
[dart_streams]: https://dart.dev/tutorials/language/streams
[BLoC]: https://pub.dev/packages/flutter_bloc
[updates_mixin]: lib/util/updates_stream.dart


# Dependency Management

Dependencies are managed in the [`service_locator.dart`][service_locator] file. This sample uses [GetIt](https://pub.dev/packages/get_it), a lightweight service locator.

[service_locator]: ./lib/service_locator.dart


# Tests

The test package contains unit tests for the `TasksDataSource` and `TasksRepository`:

- [tasks_data_source_base_test] - Base tests for every implementation; see [tasks_cache_data_source_test] that calls the base tests;
- [tasks_repository_test] - Tests the task and task group update streams: `TasksRepository#taskEventUpdatesStream` and `TasksRepository#taskGroupUpdatesStream`; 
- [tasks_stub_data_source] - TasksDataSource stub;

[tasks_data_source_base_test]: ./test/data/tasks_data_source_base_test.dart 
[tasks_cache_data_source_test]: ./test/data/tasks_cache_data_source_test.dart
[tasks_repository_test]: ./test/data/tasks_repository_test.dart
[tasks_stub_data_source]: ./test/data/tasks_stub_data_source.dart

