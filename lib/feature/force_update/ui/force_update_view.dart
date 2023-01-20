import 'package:flutter_template/feature/force_update/force_update_alert.dart';
import 'package:flutter/material.dart';

class ForceUpdateView extends StatefulWidget {
  const ForceUpdateView({Key? key}) : super(key: key);

  @override
  State<ForceUpdateView> createState() => _ForceUpdateViewState();
}

class _ForceUpdateViewState extends State<ForceUpdateView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showForceUpdateAlert(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: Colors.white,
      );
    });
  }
}
