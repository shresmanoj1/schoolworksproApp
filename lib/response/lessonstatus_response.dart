// To parse this JSON data, do
//
//     final lessonstatusResponse = lessonstatusResponseFromJson(jsonString);

import 'dart:convert';

LessonstatusResponse lessonstatusResponseFromJson(String str) =>
    LessonstatusResponse.fromJson(json.decode(str));

String lessonstatusResponseToJson(LessonstatusResponse data) =>
    json.encode(data.toJson());

class LessonstatusResponse {
  LessonstatusResponse({
    this.success,
    this.lessonStatus,
  });

  bool? success;
  dynamic lessonStatus;

  factory LessonstatusResponse.fromJson(Map<String, dynamic> json) =>
      LessonstatusResponse(
        success: json["success"],
        lessonStatus: json["lessonStatus"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "lessonStatus": lessonStatus,
      };
}

// class LessonStatus {
//   LessonStatus({
//     this.isCompleted,
//     this.id,
//     this.lesson,
//     this.moduleSlug,
//     this.startDate,
//     this.institution,
//     this.student,
//   });

//   bool? isCompleted;
//   String? id;
//   String? lesson;
//   String? moduleSlug;
//   DateTime? startDate;
//   String? institution;
//   String? student;

//   factory LessonStatus.fromJson(Map<String, dynamic> json) => LessonStatus(
//         isCompleted: json["isCompleted"],
//         id: json["_id"],
//         lesson: json["lesson"],
//         moduleSlug: json["moduleSlug"],
//         startDate: DateTime.parse(json["startDate"]),
//         institution: json["institution"],
//         student: json["student"],
//       );

//   Map<String, dynamic> toJson() => {
//         "isCompleted": isCompleted,
//         "_id": id,
//         "lesson": lesson,
//         "moduleSlug": moduleSlug,
//         "startDate": startDate!.toIso8601String(),
//         "institution": institution,
//         "student": student,
//       };
// }
