// To parse this JSON data, do
//
//     final allprogressresponse = allprogressresponseFromJson(jsonString);

import 'dart:convert';

AllProgressResponse allprogressresponseFromJson(String str) => AllProgressResponse.fromJson(json.decode(str));

String allprogressresponseToJson(AllProgressResponse data) => json.encode(data.toJson());

class AllProgressResponse {
  AllProgressResponse({
    this.success,
    this.allProgress,
  });

  bool ? success;
  List<dynamic> ? allProgress;

  factory AllProgressResponse.fromJson(Map<String, dynamic> json) => AllProgressResponse(
    success: json["success"],
    allProgress: List<dynamic>.from(json["allProgress"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allProgress": List<dynamic>.from(allProgress!.map((x) => x.toJson())),
  };
}

// class AllProgress {
//   AllProgress({
//     this.moduleTitle,
//     this.progress,
//   });
//
//   String moduleTitle;
//   int progress;
//
//   factory AllProgress.fromJson(Map<String, dynamic> json) => AllProgress(
//     moduleTitle: json["moduleTitle"],
//     progress: json["progress"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "moduleTitle": moduleTitle,
//     "progress": progress,
//   };
// }
