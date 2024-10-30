import 'dart:convert';

Lessoncontentresponse lessoncontentresponseFromJson(String str) =>
    Lessoncontentresponse.fromJson(json.decode(str));

String lessoncontentresponseToJson(Lessoncontentresponse data) =>
    json.encode(data.toJson());

class Lessoncontentresponse {
  Lessoncontentresponse({
    this.success,
    this.lesson,
    this.isPoll,
  });

  bool? success;
  Lesson? lesson;
  bool? isPoll;

  factory Lessoncontentresponse.fromJson(Map<String, dynamic> json) =>
      Lessoncontentresponse(
        success: json["success"],
        lesson: Lesson.fromJson(json["lesson"]),
        isPoll: json["isPoll"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "lesson": lesson!.toJson(),
        "isPoll": isPoll,
      };
}

class Lesson {
  Lesson({
    this.type,
    this.audioEnabled,
    this.comments,
    this.assessments,
    this.id,
    this.lessonTitle,
    this.week,
    this.lessonContents,
    this.lessonSlug,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.institution,
    this.moduleLeader,
  });

  String? type;
  bool? audioEnabled;
  List<dynamic>? comments;
  List<String>? assessments;
  String? id;
  String? lessonTitle;
  String? week;
  String? lessonContents;
  String? lessonSlug;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? institution;
  String? moduleLeader;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        type: json["type"],
        audioEnabled: json["audioEnabled"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        assessments: List<String>.from(json["assessments"].map((x) => x)),
        id: json["_id"],
        lessonTitle: json["lessonTitle"],
        week: json["week"],
        lessonContents: json["lessonContents"],
        lessonSlug: json["lessonSlug"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        institution: json["institution"],
        moduleLeader: json["moduleLeader"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "audioEnabled": audioEnabled,
        "comments": List<dynamic>.from(comments!.map((x) => x)),
        "assessments": List<dynamic>.from(assessments!.map((x) => x)),
        "_id": id,
        "lessonTitle": lessonTitle,
        "week": week,
        "lessonContents": lessonContents,
        "lessonSlug": lessonSlug,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "institution": institution,
        "moduleLeader": moduleLeader,
      };
}
