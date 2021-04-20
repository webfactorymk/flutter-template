import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> showModalSheet(
  BuildContext context, {
  required Widget content,
  bool dragEnabled = true,
}) async {
  if (Platform.isIOS) {
    return showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      enableDrag: dragEnabled,
      builder: (context) => content,
    );
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      enableDrag: dragEnabled,
      builder: (context) => content,
    );
  }
}
