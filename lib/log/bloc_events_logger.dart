import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/pre_app_config.dart';
import 'package:flutter_template/log/logger.dart';

/// Logs blog events.
///
/// To apply globally, before the app starts, set it as bloc observer:
///       Bloc.observer = BlocEventsLogger();
///
/// See [preAppConfig]
class BlocEventsLogger extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (event != null) {
      Logger.d(event.toString());
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger.d(transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Logger.e(error);
    super.onError(bloc, error, stackTrace);
  }
}
