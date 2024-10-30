// import 'package:flutter/foundation.dart';

class Parentresultheader {
  String? institution;

  Parentresultheader({
    this.institution,
  });

  Map<String, dynamic> toJson() {
    return {
      "institution": institution,
    };
  }
}
