// import 'package:flutter/foundation.dart';

class Attendancerequest {
  String? batch;
  String? institution;
  String ? username;


  Attendancerequest({
    this.batch,
    this.institution,
    this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      "batch": batch,
      "institution": institution,
      "username": username,

    };
  }
}
