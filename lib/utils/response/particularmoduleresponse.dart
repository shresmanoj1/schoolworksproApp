// To parse this JSON data, do
//
//     final particularmoduleresponse = particularmoduleresponseFromJson(jsonString);

import 'dart:convert';

Particularmoduleresponse particularmoduleresponseFromJson(String str) => Particularmoduleresponse.fromJson(json.decode(str));

String particularmoduleresponseToJson(Particularmoduleresponse data) => json.encode(data.toJson());

class Particularmoduleresponse {
  Particularmoduleresponse({
    this.success,
    this.module,
    this.progress,
  });

  bool ? success;
  dynamic module;
  int ? progress;

  factory Particularmoduleresponse.fromJson(Map<String, dynamic> json) => Particularmoduleresponse(
    success: json["success"],
    module: json["module"],
    progress: json["progress"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "module": module,
    "progress": progress,
  };
}
//
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
//     this.credit,
//     this.institution,
//   });
//
//   String learnType;
//   List<String> tags;
//   List<Lesson> lessons;
//   List<dynamic> publicLessons;
//   List<String> currentBatch;
//   List<String> accessTo;
//   List<String> blockedUsers;
//   List<String> usersWithAccess;
//   bool isExtra;
//   String id;
//   String moduleTitle;
//   String moduleDesc;
//   int duration;
//   double weeklyStudy;
//   String year;
//   String benefits;
//   ModuleLeader moduleLeader;
//   String embeddedUrl;
//   String imageUrl;
//   String moduleSlug;
//   String credit;
//   String institution;
//
//   factory Module.fromJson(Map<String, dynamic> json) => Module(
//     learnType: json["learn_type"],
//     tags: List<String>.from(json["tags"].map((x) => x)),
//     lessons: List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
//     publicLessons: List<dynamic>.from(json["public_lessons"].map((x) => x)),
//     currentBatch: List<String>.from(json["currentBatch"].map((x) => x)),
//     accessTo: List<String>.from(json["accessTo"].map((x) => x)),
//     blockedUsers: List<String>.from(json["blockedUsers"].map((x) => x)),
//     usersWithAccess: List<String>.from(json["usersWithAccess"].map((x) => x)),
//     isExtra: json["isExtra"],
//     id: json["_id"],
//     moduleTitle: json["moduleTitle"],
//     moduleDesc: json["moduleDesc"],
//     duration: json["duration"],
//     weeklyStudy: json["weekly_study"].toDouble(),
//     year: json["year"],
//     benefits: json["benefits"],
//     moduleLeader: ModuleLeader.fromJson(json["moduleLeader"]),
//     embeddedUrl: json["embeddedUrl"],
//     imageUrl: json["imageUrl"],
//     moduleSlug: json["moduleSlug"],
//     credit: json["credit"],
//     institution: json["institution"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "learn_type": learnType,
//     "tags": List<dynamic>.from(tags.map((x) => x)),
//     "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
//     "public_lessons": List<dynamic>.from(publicLessons.map((x) => x)),
//     "currentBatch": List<dynamic>.from(currentBatch.map((x) => x)),
//     "accessTo": List<dynamic>.from(accessTo.map((x) => x)),
//     "blockedUsers": List<dynamic>.from(blockedUsers.map((x) => x)),
//     "usersWithAccess": List<dynamic>.from(usersWithAccess.map((x) => x)),
//     "isExtra": isExtra,
//     "_id": id,
//     "moduleTitle": moduleTitle,
//     "moduleDesc": moduleDesc,
//     "duration": duration,
//     "weekly_study": weeklyStudy,
//     "year": year,
//     "benefits": benefits,
//     "moduleLeader": moduleLeader.toJson(),
//     "embeddedUrl": embeddedUrl,
//     "imageUrl": imageUrl,
//     "moduleSlug": moduleSlug,
//     "credit": credit,
//     "institution": institution,
//   };
// }
//
// class Lesson {
//   Lesson({
//     this.v,
//   });
//
//   int v;
//
//   factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "__v": v,
//   };
// }
//
// class ModuleLeader {
//   ModuleLeader({
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.joinDate,
//     this.imageUrl,
//     this.workType,
//     this.institution,
//   });
//
//   String firstname;
//   String lastname;
//   String email;
//   DateTime joinDate;
//   String imageUrl;
//   String workType;
//   String institution;
//
//   factory ModuleLeader.fromJson(Map<String, dynamic> json) => ModuleLeader(
//     firstname: json["firstname"],
//     lastname: json["lastname"],
//     email: json["email"],
//     joinDate: DateTime.parse(json["joinDate"]),
//     imageUrl: json["imageUrl"],
//     workType: json["workType"],
//     institution: json["institution"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "firstname": firstname,
//     "lastname": lastname,
//     "email": email,
//     "joinDate": joinDate.toIso8601String(),
//     "imageUrl": imageUrl,
//     "workType": workType,
//     "institution": institution,
//   };
// }
