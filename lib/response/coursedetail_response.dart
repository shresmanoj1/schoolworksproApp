// To parse this JSON data, do
//
//     final coursedetailResponse = coursedetailResponseFromJson(jsonString);

import 'dart:convert';

CoursedetailResponse coursedetailResponseFromJson(String str) => CoursedetailResponse.fromJson(json.decode(str));

String coursedetailResponseToJson(CoursedetailResponse data) => json.encode(data.toJson());

class CoursedetailResponse {
  CoursedetailResponse({
    this.success,
    this.course,
  });

  bool? success;
  Course? course;

  factory CoursedetailResponse.fromJson(Map<String, dynamic> json) => CoursedetailResponse(
    success: json["success"],
    course: Course.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "course": course?.toJson(),
  };
}

class Course {
  Course({
    this.modules,
    this.branches,
    this.users,
    this.courseName,
    this.courseDesc,
    this.years,
    this.credits,
    this.imageUrl,
    this.courseSlug,
    this.institution,
  });

  List<Module>? modules;
  List<dynamic>? branches;
  List<String>? users;
  String? courseName;
  String? courseDesc;
  String? years;
  String? credits;
  String? imageUrl;
  String? courseSlug;
  String? institution;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    modules: List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
    branches: List<dynamic>.from(json["branches"].map((x) => x)),
    users: json["users"] == null ? [] : List<String>.from(json["users"].map((x) => x)),
    courseName: json["courseName"],
    courseDesc: json["courseDesc"],
    years: json["years"],
    credits: json["credits"],
    imageUrl: json["imageUrl"],
    courseSlug: json["courseSlug"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
    "branches": List<dynamic>.from(branches!.map((x) => x)),
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
    "courseName": courseName,
    "courseDesc": courseDesc,
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
    this.institution,
    this.imageUrl,
  });

  List<String>? tags;
  List<dynamic>? lessons;
  List<String>? accessTo;
  List<dynamic>? blockedUsers;
  List<dynamic>? usersWithAccess;
  String? id;
  String? moduleTitle;
  String? moduleDesc;
  String? year;
  ModuleLeader? moduleLeader;
  String? moduleSlug;
  String? institution;
  String? imageUrl;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    tags: List<String>.from(json["tags"].map((x) => x)),
    lessons: List<dynamic>.from(json["lessons"].map((x) => x)),
    accessTo: List<String>.from(json["accessTo"].map((x) => x)),
    blockedUsers: List<dynamic>.from(json["blockedUsers"].map((x) => x)),
    usersWithAccess: List<dynamic>.from(json["usersWithAccess"].map((x) => x)),
    id: json["_id"],
    moduleTitle: json["moduleTitle"],
    moduleDesc: json["moduleDesc"],
    year: json["year"],
    moduleLeader: ModuleLeader.fromJson(json["moduleLeader"]),
    moduleSlug: json["moduleSlug"],
    institution: json["institution"],
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
    "moduleLeader": moduleLeader?.toJson(),
    "moduleSlug": moduleSlug,
    "institution": institution,
    "imageUrl": imageUrl,
  };
}

class ModuleLeader {
  ModuleLeader({
    this.address,
    this.firstname,
    this.lastname,
    this.workType,
    this.institution,
    this.imageUrl,
  });

  String? address;
  String? firstname;
  String? lastname;
  String? workType;
  String? institution;
  String? imageUrl;

  factory ModuleLeader.fromJson(Map<String, dynamic> json) => ModuleLeader(
    address: json["address"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    workType: json["workType"],
    institution: json["institution"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "firstname": firstname,
    "lastname": lastname,
    "workType": workType,
    "institution": institution,
    "imageUrl": imageUrl,
  };
}
