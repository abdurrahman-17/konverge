import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  Function? onResumeCallback;

  AppLifecycleObserver({this.onResumeCallback});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (onResumeCallback != null) {
        onResumeCallback!();
      }
    }
  }
}
