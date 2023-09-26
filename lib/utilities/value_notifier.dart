import 'package:flutter/material.dart';

import 'common_functions.dart';

class ButtonNotifier extends ValueNotifier<bool> {
  List<TextEditingController> controllers;
  bool enabled;

  ButtonNotifier(super.value,
      {required this.controllers, this.enabled = false});

  void setButton() {
    enabled = checkAllFieldFilled(controllers);
    // print("enabled ${enabled}");
    notifyListeners();
  }
}
