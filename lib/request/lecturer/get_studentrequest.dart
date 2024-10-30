// import 'package:flutter/foundation.dart';

class Getstudentrequest {
  String moduleSlug;

  Getstudentrequest({required this.moduleSlug});

  Map<String, dynamic> toJson() {
    return {
      "moduleSlug": moduleSlug,
    };
  }
}
