import 'package:flutter/material.dart';

class Ideas {
  TextEditingController? controller;
  String title;
  String id;
  GlobalKey<FormState>? globalKey;
  String hint;

  Ideas({
    this.controller,
    required this.title,
    required this.id,
    this.globalKey,
    required this.hint,
  });

  /* Ideas(
      {this.controller,
      required this.title,
      required this.id,
      required this.hint});*/
}
