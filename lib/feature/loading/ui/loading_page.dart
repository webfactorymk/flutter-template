import 'package:flutter/material.dart';
import 'package:flutter_template/feature/loading/ui/circular_progress_indicator.dart';

class LoadingPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
