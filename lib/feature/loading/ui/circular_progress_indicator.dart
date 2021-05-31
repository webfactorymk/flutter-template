import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformCircularProgressIndicator extends StatelessWidget {
  final double padding;
  final double height;
  final double width;

  const PlatformCircularProgressIndicator({
    Key? key,
    this.padding = 0,
    this.height = 30,
    this.width = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: SizedBox(
          child: Platform.isIOS
              ? CupertinoActivityIndicator(radius: height / 2.0)
              : CircularProgressIndicator(),
          height: height,
          width: width,
        ),
      ),
    );
  }
}
