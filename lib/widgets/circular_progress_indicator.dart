import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicCircularProgressIndicator extends StatefulWidget {
  final double padding;
  final double height;
  final double width;

  const BasicCircularProgressIndicator({
    Key? key,
    this.padding = 0,
    this.height = 30,
    this.width = 30,
  }) : super(key: key);

  @override
  _BasicCircularProgressIndicatorState createState() =>
      _BasicCircularProgressIndicatorState();
}

class _BasicCircularProgressIndicatorState
    extends State<BasicCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Center(
        child: SizedBox(
          child: Platform.isIOS ? CupertinoActivityIndicator(radius: widget.height/2.0) : CircularProgressIndicator(),
          height: widget.height,
          width: widget.width,
        ),
      ),
    );
  }
}
