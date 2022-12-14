# Flutter Template

Flutter template project - A simple TODO list app. This template provides simple UI and scalable project structure that goes beyond the simple counter example. 

The app has basic login and signup screens, task list, task details, and settings screen. It supports multiple languages and in-app language change, and light and dark theme. 

It's configured with [BLoC] for state management, [Chopper] for networking, [Navigation 2.0], [GetIt] as service locator, UserManager, Repository Pattern, Logger, and util and convenience methods. 

<br />
<div>
  &emsp;&emsp;&emsp;
  <img src="https://github.com/webfactorymk/flutter-template/blob/main/diagrams/light_theme.png" alt="Light theme" width="330">
  &emsp;&emsp;&emsp;&emsp;
  <img src="https://github.com/webfactorymk/flutter-template/blob/main/diagrams/dark_theme.jpg" alt="Dark theme" width="320">  
</div>
<br />

[Navigation 2.0]: https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade

# First Run

The project is configured with mock data if you run the **MOCK** flavor. See the next section for configuring run configurations.

After installing the package dependencies with 

```
flutter pub get
```

run the code generation tool 

```
flutter pub run build_runner build
```

## Run Configurations

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

# Use as template

You can copy this repository with the _Use this template_ button and go on from there, or download the code and use it in you project.
Afterwards, you'll need to rename the project and change the app id and configuration. There are ToDos scattered through the project that will help you transition this project to your needs.

<img src="https://github.com/webfactorymk/flutter-template/blob/main/diagrams/use_as_template.png" alt="Use as template" width="520">


## [Head to the Wiki page for project documentation.](https://github.com/webfactorymk/flutter-template/wiki)

## Resolve TODOs

Go over the TODOs scattered around the project and resolve as much as possible. They will help you configure the project to your needs.

In AndroidStudio you can view all TODOs in the bottom tab as shown in this picture:

![TODOs bottom tab in AS](http://jubin.tech/assets/pic/20181023-1-todo-in-AS.png)

## App Configuration

To configure the app for your environment head to the `/config` directory:

- add flavor-specific valus in `FlavorConfig` -> `FlavorValues`
- configure firebase in `FirebaseConfig`, duh
- configure API constants in `network_constants`
- also see `pre_app_config` and `post_app_config` for preloading essential app components

_See the [wiki configuration page] for more info._

[wiki configuration page]: https://github.com/webfactorymk/flutter-template/wiki/Configuration


# Under the hood

## Data Management

![Alt text][high_lvl_diagram]

[high_lvl_diagram]: diagrams/high_lvl_diagram.png "High level diagram"


### [TasksDataSource]

This is the main entry point for accessing and manipulating tasks data. The rest of the app should not invoke tasks' endpoints directly or query cached data. All tasks operations should go through this service.

Implementations:
- [**TasksRemoteDataSource**] - Uses the ApiService to contact a remote server;
- [**TasksCacheDataSource**] - Uses in-memory cache to retrieve tasks;
- [**TasksRepository**][tasks_repository] - Uses both *TasksRemoteDataSource* and *TasksCacheDataSource* to fetch cached data when available; Provides subscription for updates;

[TasksDataSource]: ./lib/data/repository/tasks/tasks_data_source.dart
[**TasksRemoteDataSource**]: ./lib/data/repository/tasks/tasks_remote_data_source.dart
[**TasksCacheDataSource**]: ./lib/data/repository/tasks/tasks_cache_data_source.dart
[tasks_repository]: ./lib/data/repository/tasks/tasks_repository.dart


### ApiService

Abstraction over the API communication that defines (all) endpoints. 
This templates uses [Chopper], an http client generator, to make network requests.

- [UserApiService] - User related endpoints
- [UserAuthApiService] - User re-authentication endpoints
- [TasksApiService] - Tasks, TaskGroups, and task actions endpoints

[UserApiService]: lib/network/user_api_service.dart
[UserAuthApiService]: lib/network/user_auth_api_service.dart
[TasksApiService]: lib/network/tasks_api_service.dart

[Chopper]: https://pub.dev/packages/chopper


### JSON and Serialization

JSON models are serialized using a code generation library.

For one time code generation run this command in terminal: `flutter pub run build_runner build`

For subsequent code generations with conflicting outputs: `flutter pub run build_runner build --delete-conflicting-outputs`

For more information and generating code continuously see [the documentation][json_serialization].

[json_serialization]: https://flutter.dev/docs/development/data-and-backend/json

## Declarative UI and state management

[Flutter is declarative framework][declarative_ui]. This means that Flutter builds its user interface to reflect the current state of the app. 

<img src="https://docs.flutter.dev/assets/images/docs/development/data-and-backend/state-mgmt/ui-equals-function-of-state.png" alt="High level diagram" width="350">

~~This template attempts to be unopinionated and does not yet use a [state management tool][state_management_options].~~ ...we use [BLoC] now. But, each app service has an updates [Stream][dart_streams] that clients can subscribe to and receive state updates. See the [UpdatesStream<T> mixin][updates_mixin]. It's up to you to use a tool of your choice, or don't use one at all. 
See `TasksRepository#taskEventUpdatesStream` and `TasksRepository#taskGroupUpdatesStream` in [TasksRepository][tasks_repository]

[declarative_ui]: https://flutter.dev/docs/development/data-and-backend/state-mgmt/declarative
[state_management_options]: https://flutter.dev/docs/development/data-and-backend/state-mgmt/options
[dart_streams]: https://dart.dev/tutorials/language/streams
[BLoC]: https://pub.dev/packages/flutter_bloc
[updates_mixin]: lib/util/updates_stream.dart


## Dependency Management

Dependencies are managed in the [`service_locator.dart`][service_locator] file. This sample uses [GetIt], a lightweight service locator. There are 2 scopes defined in this template global and user scope. For more information visit the [wiki service locator page].

[service_locator]: ./lib/di/service_locator.dart
[GetIt]: https://pub.dev/packages/get_it
[wiki service locator page]: https://github.com/webfactorymk/flutter-template/wiki/Service-Locator

## Logger

This project uses a custom Logger configured to:
1. print to console, except in production
2. write to a file, except in production - useful for QA reporting
3. log to firebase or report a non-fatal error to firebase

Prefer to use this logger over print statements.
- `Log.d(message)` for debug messages
- `Log.w(message)` for warning messages
- `Log.e(object)` for error messages (this will also report a firebase non-fatal error)
  
## Tests

The test package contains unit tests for almost all components. Be sure to give it a look.
