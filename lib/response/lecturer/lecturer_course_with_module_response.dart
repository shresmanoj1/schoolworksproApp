// To parse this JSON data, do
//
//     final lecturerCourseWithModuleResponse = lecturerCourseWithModuleResponseFromJson(jsonString);

import 'dart:convert';

LecturerCourseWithModuleResponse lecturerCourseWithModuleResponseFromJson(String str) => LecturerCourseWithModuleResponse.fromJson(json.decode(str));

String lecturerCourseWithModuleResponseToJson(LecturerCourseWithModuleResponse data) => json.encode(data.toJson());

class LecturerCourseWithModuleResponse {
  bool? success;
  Data? data;

  LecturerCourseWithModuleResponse({
    this.success,
    this.data,
  });

  factory LecturerCourseWithModuleResponse.fromJson(Map<String, dynamic> json) => LecturerCourseWithModuleResponse(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? imageUrl;
  List<Course>? course;

  Data({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.imageUrl,
    this.course,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    imageUrl: json["imageUrl"],
    course: List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "imageUrl": imageUrl,
    "course": List<dynamic>.from(course!.map((x) => x.toJson())),
  };
}

class Course {
  List<Module>? modules;
  String? id;
  String? courseName;
  String? courseSlug;

  Course({
    this.modules,
    this.id,
    this.courseName,
    this.courseSlug,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    modules: List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
    id: json["_id"],
    courseName: json["courseName"],
    courseSlug: json["courseSlug"],
  );

  Map<String, dynamic> toJson() => {
    "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
    "_id": id,
    "courseName": courseName,
    "courseSlug": courseSlug,
  };
}

class Module {
  bool? hidden;
  String? id;
  String? moduleTitle;
  String? imageUrl;
  String? moduleSlug;

  Module({
    this.hidden,
    this.id,
    this.moduleTitle,
    this.imageUrl,
    this.moduleSlug,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    hidden: json["hidden"],
    id: json["_id"],
    moduleTitle: json["moduleTitle"],
    imageUrl: json["imageUrl"],
    moduleSlug: json["moduleSlug"],
  );

  Map<String, dynamic> toJson() => {
    "hidden": hidden,
    "_id": id,
    "moduleTitle": moduleTitle,
    "imageUrl": imageUrl,
    "moduleSlug": moduleSlug,
  };
}
