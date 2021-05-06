import 'package:flutter_template/app.dart';
import 'package:flutter_template/feature/force_update/force_update_alert.dart';

/// Handles [ForceUpdateException].
class ForceUpdateHandler {

  ForceUpdateHandler();

  void onForceUpdateEvent() {
    if (navigatorKey.currentContext != null) {
      showForceUpdateAlert(navigatorKey.currentContext!);
    }
  }
}
