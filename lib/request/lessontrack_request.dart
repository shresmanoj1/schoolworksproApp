// import 'package:flutter/foundation.dart';

class LessonTrackRequest {
  final String? moduleSlug;
  final String? lesson;

  LessonTrackRequest({
    this.moduleSlug,
    this.lesson,
  });

  Map<String, dynamic> toJson() {
    return {
      "moduleSlug": moduleSlug,
      "lesson": lesson,
    };
  }
}
