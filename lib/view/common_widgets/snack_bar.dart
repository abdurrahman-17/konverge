import 'package:flutter/material.dart';
import '../../main.dart';

import '../../theme/app_style.dart';

void showSnackBar({
  required String message,
  Duration? duration,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: AppStyle.txtPoppinsRegular14WhiteA700,
    ),
    duration: duration ?? const Duration(milliseconds: 4000),
  );
  ScaffoldMessenger.of(globalNavigatorKey.currentContext!)
      .showSnackBar(snackBar);
}
