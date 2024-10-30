// To parse this JSON data, do
//
//     final coursedetailResponse = coursedetailResponseFromJson(jsonString);

import 'dart:convert';

CoursedetailResponse coursedetailResponseFromJson(String str) =>
    CoursedetailResponse.fromJson(json.decode(str));

String coursedetailResponseToJson(CoursedetailResponse data) =>
    json.encode(data.toJson());

class CoursedetailResponse {
  CoursedetailResponse({
    this.success,
    this.course,
  });

  bool? success;
  Course? course;

  factory CoursedetailResponse.fromJson(Map<String, dynamic> json) =>
      CoursedetailResponse(
        success: json["success"],
        course: Course.fromJson(json["course"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "course": course!.toJson(),
      };
}

class Course {
  Course({
    this.modules,
    this.users,
    this.courseName,
    this.courseDesc,
    this.courseShortDesc,
    this.years,
    this.credits,
    this.imageUrl,
    this.courseSlug,
    this.institution,
  });

  List<Module>? modules;
  List<User>? users;
  String? courseName;
  String? courseDesc;
  String? courseShortDesc;
  String? years;
  String? credits;
  String? imageUrl;
  String? courseSlug;
  String? institution;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        courseName: json["courseName"],
        courseDesc: json["courseDesc"],
        courseShortDesc: json["courseShortDesc"],
        years: json["years"],
        credits: json["credits"],
        imageUrl: json["imageUrl"],
        courseSlug: json["courseSlug"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
        "courseName": courseName,
        "courseDesc": courseDesc,
        "courseShortDesc": courseShortDesc,
        "years": years,
        "credits": credits,
        "imageUrl": imageUrl,
        "courseSlug": courseSlug,
        "institution": institution,
      };
}

class Module {
  Module({
    this.tags,
    this.lessons,
    this.accessTo,
    this.blockedUsers,
    this.usersWithAccess,
    this.id,
    this.moduleTitle,
    this.moduleDesc,
    this.year,
    this.moduleLeader,
    this.moduleSlug,
    this.imageUrl,
  });

  List<String>? tags;
  List<String>? lessons;
  List<String>? accessTo;
  List<String>? blockedUsers;
  List<String>? usersWithAccess;
  String? id;
  String? moduleTitle;
  String? moduleDesc;
  String? year;
  ModuleLeader? moduleLeader;
  String? moduleSlug;
  String? imageUrl;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        tags: List<String>.from(json["tags"].map((x) => x)),
        lessons: List<String>.from(json["lessons"].map((x) => x)),
        accessTo: List<String>.from(json["accessTo"].map((x) => x)),
        blockedUsers: List<String>.from(json["blockedUsers"].map((x) => x)),
        usersWithAccess:
            List<String>.from(json["usersWithAccess"].map((x) => x)),
        id: json["_id"],
        moduleTitle: json["moduleTitle"],
        moduleDesc: json["moduleDesc"],
        year: json["year"],
        moduleLeader: json["moduleLeader"] == null
            ? null
            : ModuleLeader.fromJson(json["moduleLeader"]),
        moduleSlug: json["moduleSlug"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "lessons": List<dynamic>.from(lessons!.map((x) => x)),
        "accessTo": List<dynamic>.from(accessTo!.map((x) => x)),
        "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
        "usersWithAccess": List<dynamic>.from(usersWithAccess!.map((x) => x)),
        "_id": id,
        "moduleTitle": moduleTitle,
        "moduleDesc": moduleDesc,
        "year": year,
        "moduleLeader": moduleLeader == null ? null : moduleLeader!.toJson(),
        "moduleSlug": moduleSlug,
        "imageUrl": imageUrl,
      };
}

class ModuleLeader {
  ModuleLeader({
    this.firstname,
    this.lastname,
    this.workType,
    this.institution,
  });

  String? firstname;
  String? lastname;
  String? workType;
  String? institution;

  factory ModuleLeader.fromJson(Map<String, dynamic> json) => ModuleLeader(
        firstname: json["firstname"],
        lastname: json["lastname"],
        workType: json["workType"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "workType": workType,
        "institution": institution,
      };
}

class User {
  User();

  factory User.fromJson(Map<String, dynamic> json) => User();

  Map<String, dynamic> toJson() => {};
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
