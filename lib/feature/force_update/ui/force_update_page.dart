import 'package:flutter_template/feature/force_update/ui/force_update_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForceUpdatePage extends Page {
  ForceUpdatePage();

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: Duration.zero,
      pageBuilder: (BuildContext context, _, __) =>
          ForceUpdateView(),
    );
  }
}
