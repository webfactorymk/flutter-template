import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/widgets/circular_progress_indicator.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BasicCircularProgressIndicator(),
        ),
      ),
    );
  }
}
