// To parse this JSON data, do
//
//     final lecturerModuleDetailResponse = lecturerModuleDetailResponseFromJson(jsonString);

import 'dart:convert';

LecturerModuleDetailResponse lecturerModuleDetailResponseFromJson(String str) =>
    LecturerModuleDetailResponse.fromJson(json.decode(str));

String lecturerModuleDetailResponseToJson(LecturerModuleDetailResponse data) =>
    json.encode(data.toJson());

class LecturerModuleDetailResponse {
  LecturerModuleDetailResponse({
    this.success,
    this.module,
  });

  bool? success;
  dynamic module;

  factory LecturerModuleDetailResponse.fromJson(Map<String, dynamic> json) =>
      LecturerModuleDetailResponse(
        success: json["success"],
        module: json["module"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "module": module,
      };
}

// class Module {
//   Module({
//     this.learnType,
//     this.tags,
//     this.lessons,
//     this.publicLessons,
//     this.currentBatch,
//     this.accessTo,
//     this.blockedUsers,
//     this.usersWithAccess,
//     this.isExtra,
//     this.id,
//     this.moduleTitle,
//     this.moduleDesc,
//     this.duration,
//     this.weeklyStudy,
//     this.year,
//     this.benefits,
//     this.moduleLeader,
//     this.embeddedUrl,
//     this.imageUrl,
//     this.moduleSlug,
//     this.institution,
//     this.exam,
//   });
//
//   String? learnType;
//   List<String>? tags;
//   List<Lesson>? lessons;
//   List<dynamic>? publicLessons;
//   List<String>? currentBatch;
//   List<String>? accessTo;
//   List<String>? blockedUsers;
//   List<String>? usersWithAccess;
//   bool? isExtra;
//   String? id;
//   String? moduleTitle;
//   String? moduleDesc;
//   int? duration;
//   int? weeklyStudy;
//   String? year;
//   String? benefits;
//   ModuleLeader? moduleLeader;
//   String? embeddedUrl;
//   String? imageUrl;
//   String? moduleSlug;
//   String? institution;
//   Exam? exam;
//
//   factory Module.fromJson(Map<String, dynamic> json) => Module(
//         learnType: json["learn_type"] ?? "",
//         tags: json["tags"] == null
//             ? []
//             : List<String>.from(json["tags"].map((x) => x)),
//         lessons: json["lessons"] == null
//             ? []
//             : List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
//         publicLessons: json["public_lessons"] == null
//             ? []
//             : List<dynamic>.from(json["public_lessons"].map((x) => x)),
//         currentBatch: json["currentBatch"] == null
//             ? []
//             : List<String>.from(json["currentBatch"].map((x) => x)),
//         accessTo: json["accessTo"] == null
//             ? []
//             : List<String>.from(json["accessTo"].map((x) => x)),
//         blockedUsers: json["blockedUsers"] == null
//             ? []
//             : List<String>.from(json["blockedUsers"].map((x) => x)),
//         usersWithAccess: json["usersWithAccess"] == null
//             ? []
//             : List<String>.from(json["usersWithAccess"].map((x) => x)),
//         isExtra: json["isExtra"] ?? "",
//         id: json["_id"] ?? "",
//         moduleTitle: json["moduleTitle"] ?? "",
//         moduleDesc: json["moduleDesc"] ?? "",
//         duration: json["duration"] ?? "",
//         weeklyStudy: json["weekly_study"] ?? "",
//         year: json["year"] ?? "",
//         benefits: json["benefits"] ?? "",
//         moduleLeader: ModuleLeader.fromJson(json["moduleLeader"]),
//         embeddedUrl: json["embeddedUrl"] ?? "",
//         imageUrl: json["imageUrl"] ?? "",
//         moduleSlug: json["moduleSlug"] ?? "",
//         institution: json["institution"] ?? "",
//         exam: Exam.fromJson(json["exam"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "learn_type": learnType,
//         "tags": List<dynamic>.from(tags!.map((x) => x)),
//         "lessons": List<dynamic>.from(lessons!.map((x) => x.toJson())),
//         "public_lessons": List<dynamic>.from(publicLessons!.map((x) => x)),
//         "currentBatch": List<dynamic>.from(currentBatch!.map((x) => x)),
//         "accessTo": List<dynamic>.from(accessTo!.map((x) => x)),
//         "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
//         "usersWithAccess": List<dynamic>.from(usersWithAccess!.map((x) => x)),
//         "isExtra": isExtra,
//         "_id": id,
//         "moduleTitle": moduleTitle,
//         "moduleDesc": moduleDesc,
//         "duration": duration,
//         "weekly_study": weeklyStudy,
//         "year": year,
//         "benefits": benefits,
//         "moduleLeader": moduleLeader?.toJson(),
//         "embeddedUrl": embeddedUrl,
//         "imageUrl": imageUrl,
//         "moduleSlug": moduleSlug,
//         "institution": institution,
//         "exam": exam?.toJson(),
//       };
// }
//
// class Exam {
//   Exam({
//     this.attemptedBy,
//     this.id,
//     this.examTitle,
//   });
//
//   List<String>? attemptedBy;
//   String? id;
//   String? examTitle;
//
//   factory Exam.fromJson(Map<String, dynamic> json) => Exam(
//         attemptedBy: List<String>.from(json["attemptedBy"].map((x) => x)),
//         id: json["_id"] ?? "",
//         examTitle: json["examTitle"] ?? "",
//       );
//
//   Map<String, dynamic> toJson() => {
//         "attemptedBy": List<dynamic>.from(attemptedBy!.map((x) => x)),
//         "_id": id,
//         "examTitle": examTitle,
//       };
// }
//
// class Lesson {
//   Lesson({
//     this.audioEnabled,
//     this.isPublic,
//     this.comments,
//     this.assessments,
//     this.id,
//     this.lessonTitle,
//     this.week,
//     this.lessonSlug,
//     this.institution,
//   });
//
//   bool? audioEnabled;
//   bool? isPublic;
//   List<String>? comments;
//   List<String>? assessments;
//   String? id;
//   String? lessonTitle;
//   String? week;
//   String? lessonSlug;
//   String? institution;
//
//   factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
//         audioEnabled: json["audioEnabled"] ?? "",
//         isPublic: json["isPublic"] ?? "",
//         comments: json["comments"] == null
//             ? []
//             : List<String>.from(json["comments"].map((x) => x)),
//         assessments: json["assessments"] == null
//             ? []
//             : List<String>.from(json["assessments"].map((x) => x)),
//         id: json["_id"] ?? "",
//         lessonTitle: json["lessonTitle"] ?? "",
//         week: json["week"] ?? "",
//         lessonSlug: json["lessonSlug"] ?? "",
//         institution: json["institution"] ?? "",
//       );
//
//   Map<String, dynamic> toJson() => {
//         "audioEnabled": audioEnabled,
//         "isPublic": isPublic,
//         "comments": List<dynamic>.from(comments!.map((x) => x)),
//         "assessments": List<dynamic>.from(assessments!.map((x) => x)),
//         "_id": id,
//         "lessonTitle": lessonTitle,
//         "week": week,
//         "lessonSlug": lessonSlug,
//         "institution": institution,
//       };
// }
//
// class ModuleLeader {
//   ModuleLeader({
//     this.id,
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.joinDate,
//     this.imageUrl,
//     this.socialMediaLinks,
//     this.workType,
//     this.institution,
//   });
//
//   String? id;
//   String? firstname;
//   String? lastname;
//   String? email;
//   DateTime? joinDate;
//   String? imageUrl;
//   String? socialMediaLinks;
//   String? workType;
//   String? institution;
//
//   factory ModuleLeader.fromJson(Map<String, dynamic> json) => ModuleLeader(
//         id: json["_id"] ?? "",
//         firstname: json["firstname"] ?? "",
//         lastname: json["lastname"] ?? "",
//         email: json["email"] ?? "",
//         joinDate: DateTime.parse(json["joinDate"]),
//         imageUrl: json["imageUrl"] ?? "",
//         socialMediaLinks: json["socialMediaLinks"] ?? "",
//         workType: json["workType"] ?? "",
//         institution: json["institution"] ?? "",
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "firstname": firstname,
//         "lastname": lastname,
//         "email": email,
//         "joinDate": joinDate?.toIso8601String(),
//         "imageUrl": imageUrl,
//         "socialMediaLinks": socialMediaLinks,
//         "workType": workType,
//         "institution": institution,
//       };
// }
