// To parse this JSON data, do
//
//     final switchRoleResponse = switchRoleResponseFromJson(jsonString);

import 'dart:convert';

SwitchRoleResponse switchRoleResponseFromJson(String str) =>
    SwitchRoleResponse.fromJson(json.decode(str));

String switchRoleResponseToJson(SwitchRoleResponse data) =>
    json.encode(data.toJson());

class SwitchRoleResponse {
  SwitchRoleResponse({
    this.success,
    this.token,
    this.user,
  });

  bool? success;
  String? token;
  User? user;

  factory SwitchRoleResponse.fromJson(Map<String, dynamic> json) =>
      SwitchRoleResponse(
        success: json["success"],
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  User({
    this.firstname,
    this.lastname,
    this.username,
    this.roles,
    this.type,
    this.email,
    this.institution,
    this.userInstitutionType,
    this.institutionType,
    this.relatedCourses,
    this.assignedCourses,
    this.uuid,
    this.id,
    this.parentBranch,
  });

  String? firstname;
  String? lastname;
  String? username;
  List<String>? roles;
  String? type;
  String? email;
  String? institution;
  String? userInstitutionType;
  String? institutionType;
  List<String>? relatedCourses;
  List<AssignedCourse>? assignedCourses;
  String? uuid;
  String? id;
  dynamic parentBranch;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        type: json["type"],
        email: json["email"],
        institution: json["institution"],
        userInstitutionType: json["institution_type"],
        institutionType: json["institutionType"],
        relatedCourses: List<String>.from(json["relatedCourses"].map((x) => x)),
        assignedCourses: List<AssignedCourse>.from(
            json["assignedCourses"].map((x) => AssignedCourse.fromJson(x))),
        uuid: json["uuid"],
        id: json["_id"],
        parentBranch: json["parentBranch"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "roles": List<dynamic>.from(roles!.map((x) => x)),
        "type": type,
        "email": email,
        "institution": institution,
        "institution_type": userInstitutionType,
        "institutionType": institutionType,
        "relatedCourses": List<dynamic>.from(relatedCourses!.map((x) => x)),
        "assignedCourses":
            List<dynamic>.from(assignedCourses!.map((x) => x.toJson())),
        "uuid": uuid,
        "_id": id,
        "parentBranch": parentBranch,
      };
}

class AssignedCourse {
  AssignedCourse({
    this.courseName,
    this.courseSlug,
  });

  String? courseName;
  String? courseSlug;

  factory AssignedCourse.fromJson(Map<String, dynamic> json) => AssignedCourse(
        courseName: json["courseName"],
        courseSlug: json["courseSlug"],
      );

  Map<String, dynamic> toJson() => {
        "courseName": courseName,
        "courseSlug": courseSlug,
      };
}
