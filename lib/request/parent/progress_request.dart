// import 'package:flutter/foundation.dart';

class Addprogressheader {
  String? studentId;
  String? institution;


  Addprogressheader({
    this.studentId,
    this.institution,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "institution": institution,

    };
  }
}
