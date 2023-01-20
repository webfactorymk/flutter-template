import 'package:flutter_template/app.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/routing/app_router_delegate.dart';
import 'package:provider/provider.dart';

/// Handles [ForceUpdateException].
class ForceUpdateHandler {
  ForceUpdateHandler();

  void onForceUpdateEvent() {
    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext != null) {
      rootContext.read<AppRouterDelegate>().setForceUpdateNavState();
    } else {
      Log.e(Exception('Force update dialog not shown: rootContext == null'));
    }
  }
}
