// To parse this JSON data, do
//
//     final updateLessonResponse = updateLessonResponseFromJson(jsonString);

import 'dart:convert';

UpdateLessonResponse updateLessonResponseFromJson(String str) =>
    UpdateLessonResponse.fromJson(json.decode(str));

String updateLessonResponseToJson(UpdateLessonResponse data) =>
    json.encode(data.toJson());

class UpdateLessonResponse {
  UpdateLessonResponse({
    this.success,
    this.lessonUpdate,
  });

  bool? success;
  dynamic lessonUpdate;

  factory UpdateLessonResponse.fromJson(Map<String, dynamic> json) =>
      UpdateLessonResponse(
        success: json["success"],
        lessonUpdate: json["lessonUpdate"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "lessonUpdate": lessonUpdate.toJson(),
      };
}
//
// class LessonUpdate {
//   LessonUpdate({
//     this.type,
//     this.audioEnabled,
//     this.isPublic,
//     this.comments,
//     this.assessments,
//     this.id,
//     this.lessonTitle,
//     this.week,
//     this.lessonContents,
//     this.lessonSlug,
//     this.institution,
//   });
//
//   String type;
//   bool audioEnabled;
//   bool isPublic;
//   List<dynamic> comments;
//   List<dynamic> assessments;
//   String id;
//   String lessonTitle;
//   String week;
//   String lessonContents;
//   String lessonSlug;
//   String institution;
//
//   factory LessonUpdate.fromJson(Map<String, dynamic> json) => LessonUpdate(
//     type: json["type"],
//     audioEnabled: json["audioEnabled"],
//     isPublic: json["isPublic"],
//     comments: List<dynamic>.from(json["comments"].map((x) => x)),
//     assessments: List<dynamic>.from(json["assessments"].map((x) => x)),
//     id: json["_id"],
//     lessonTitle: json["lessonTitle"],
//     week: json["week"],
//     lessonContents: json["lessonContents"],
//     lessonSlug: json["lessonSlug"],
//     institution: json["institution"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": type,
//     "audioEnabled": audioEnabled,
//     "isPublic": isPublic,
//     "comments": List<dynamic>.from(comments.map((x) => x)),
//     "assessments": List<dynamic>.from(assessments.map((x) => x)),
//     "_id": id,
//     "lessonTitle": lessonTitle,
//     "week": week,
//     "lessonContents": lessonContents,
//     "lessonSlug": lessonSlug,
//     "institution": institution,
//   };
// }
