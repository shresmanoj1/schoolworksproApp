// import 'package:flutter/foundation.dart';

class LecturerAccess {
  String moduleSlug;
  String lecturerEmail;

  LecturerAccess({required this.moduleSlug, required this.lecturerEmail});

  Map<String, dynamic> toJson() {
    return {
      "moduleSlug": moduleSlug,
      "lecturerEmail": lecturerEmail,
    };
  }
}
