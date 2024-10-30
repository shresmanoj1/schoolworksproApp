// To parse this JSON data, do
//
//     final insideActivityResponse = insideActivityResponseFromJson(jsonString);

import 'dart:convert';

InsideActivityResponse insideActivityResponseFromJson(String str) => InsideActivityResponse.fromJson(json.decode(str));

String insideActivityResponseToJson(InsideActivityResponse data) => json.encode(data.toJson());

class InsideActivityResponse {
  InsideActivityResponse({
    this.success,
    this.assessment,
    this.isPoll,
  });

  bool ? success;
  List<dynamic> ? assessment;
  bool ? isPoll;

  factory InsideActivityResponse.fromJson(Map<String, dynamic> json) => InsideActivityResponse(
    success: json["success"],
    assessment: json["assessment"] == null ? [] : List<dynamic>.from(json["assessment"].map((x) => x)),
    isPoll: json["isPoll"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assessment": List<dynamic>.from(assessment!.map((x) => x.toJson())),
    "isPoll": isPoll,
  };
}

// class Assessment {
//   Assessment({
//     this.submission,
//     this.batches,
//     this.submissions,
//     this.id,
//     this.dueDate,
//     this.contents,
//     this.lessonSlug,
//     this.institution,
//     this.createdAt,
//   });
//
//   List<dynamic> submission;
//   List<String> batches;
//   List<dynamic> submissions;
//   String id;
//   DateTime dueDate;
//   String contents;
//   String lessonSlug;
//   String institution;
//   DateTime createdAt;
//
//   factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
//     submission: List<dynamic>.from(json["submission"].map((x) => x)),
//     batches: List<String>.from(json["batches"].map((x) => x)),
//     submissions: List<dynamic>.from(json["submissions"].map((x) => x)),
//     id: json["_id"],
//     dueDate: DateTime.parse(json["dueDate"]),
//     contents: json["contents"],
//     lessonSlug: json["lessonSlug"],
//     institution: json["institution"],
//     createdAt: DateTime.parse(json["createdAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "submission": List<dynamic>.from(submission.map((x) => x)),
//     "batches": List<dynamic>.from(batches.map((x) => x)),
//     "submissions": List<dynamic>.from(submissions.map((x) => x)),
//     "_id": id,
//     "dueDate": dueDate.toIso8601String(),
//     "contents": contents,
//     "lessonSlug": lessonSlug,
//     "institution": institution,
//     "createdAt": createdAt.toIso8601String(),
//   };
// }
