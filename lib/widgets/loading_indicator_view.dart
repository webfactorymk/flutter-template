import 'package:flutter/material.dart';
import 'package:flutter_template/widgets/circular_progress_indicator.dart';

class LoadingIndicatorView extends StatefulWidget {
  final double indicatorSize;
  final BoxShape shape;

  LoadingIndicatorView({
    this.indicatorSize = 30.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  _LoadingIndicatorViewState createState() =>
      _LoadingIndicatorViewState();
}

class _LoadingIndicatorViewState extends State<LoadingIndicatorView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: widget.shape,
      ),
      child: Center(
        child: BasicCircularProgressIndicator(
          width: widget.indicatorSize,
          height: widget.indicatorSize,
        ),
      ),
    );
  }
}

