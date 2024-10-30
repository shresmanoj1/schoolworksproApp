// To parse this JSON data, do
//
//     final findbyemailresponse = findbyemailresponseFromJson(jsonString);

import 'dart:convert';

Findbyemailresponse findbyemailresponseFromJson(String str) =>
    Findbyemailresponse.fromJson(json.decode(str));

String findbyemailresponseToJson(Findbyemailresponse data) =>
    json.encode(data.toJson());

class Findbyemailresponse {
  Findbyemailresponse({
    this.success,
    this.lecturer,
  });

  bool? success;
  Lecturer? lecturer;

  factory Findbyemailresponse.fromJson(Map<dynamic, dynamic> json) =>
      Findbyemailresponse(
        success: json["success"],
        lecturer: Lecturer.fromJson(json["lecturer"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "success": success,
        "lecturer": lecturer?.toJson(),
      };
}

class Lecturer {
  Lecturer({
    this.firstname,
    this.lastname,
    this.email,
    this.modules,
  });

  String? firstname;
  String? lastname;
  String? email;
  List<dynamic>? modules;

  factory Lecturer.fromJson(Map<dynamic, dynamic> json) => Lecturer(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        modules: List<dynamic>.from(json["modules"].map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "modules": List<dynamic>.from(modules!.map((x) => x)),
      };
}
