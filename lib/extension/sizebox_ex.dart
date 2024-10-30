
import 'package:flutter/material.dart';

extension SizeBoxEx on num {

  SizedBox get sH => SizedBox(height: this.toDouble());

  SizedBox get sW => SizedBox(width: this.toDouble());
}

extension SizedBoxExtension on Widget {

  SizedBox sH(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  SizedBox sW(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  SizedBox sHW({double width = 0.0, double height = 0.0}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }
}