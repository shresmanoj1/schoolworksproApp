// import 'package:flutter/foundation.dart';

class Lessonraterequest {
  String? lessonSlug;
  double? rating;

  Lessonraterequest({
    this.lessonSlug,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      "lessonSlug": lessonSlug,
      "rating": rating,
    };
  }
}
