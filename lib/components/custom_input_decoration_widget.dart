import 'package:flutter/material.dart';

import '../constants.dart';

InputDecoration customDecoration() {
  return const InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    enabledBorder:
    OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
    focusedBorder:
    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    errorBorder:
    OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
    filled: true,
  );
}