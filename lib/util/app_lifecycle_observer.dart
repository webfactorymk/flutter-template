import 'package:flutter/widgets.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/util/updates_stream.dart';

/// Monitors app lifecycle events.
///
/// Subscribe to listen for updates.
/// Mind to unsubscribe.
///
/// The start and stop methods activate/deactivate this component globally;
/// don't use them within the app.
///
/// To obtain an instance use `serviceLocator.get<AppLifecycleObserver>()`
class AppLifecycleObserver
    with WidgetsBindingObserver, UpdatesStream<AppLifecycleState> {

  bool _activated = false;
  AppLifecycleState _lastState = AppLifecycleState.inactive;

  AppLifecycleState get lastState => _lastState;

  /// Global method to start monitoring application state.
  void activate() {
    if (_activated) {
      Log.w('Warning: AppLifecycleObserver is already activated.');
      return;
    }
    _activated = true;
    WidgetsBinding.instance.addObserver(this);
  }

  /// Global method to stop monitoring application state.
  void deactivate() {
    if (!_activated) {
      Log.w('Warning: AppLifecycleObserver is already deactivated.');
      return;
    }
    _activated = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _lastState = state;
    addUpdate(state);
  }
}
