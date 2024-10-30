// To parse this JSON data, do
//
//     final getchildrenresponse = getchildrenresponseFromJson(jsonString);

import 'dart:convert';

Getchildrenresponse getchildrenresponseFromJson(String str) =>
    Getchildrenresponse.fromJson(json.decode(str));

String getchildrenresponseToJson(Getchildrenresponse data) =>
    json.encode(data.toJson());

class Getchildrenresponse {
  Getchildrenresponse({
    this.success,
    this.children,
  });

  bool? success;
  List<Child>? children;

  factory Getchildrenresponse.fromJson(Map<String, dynamic> json) =>
      Getchildrenresponse(
        success: json["success"],
        children:
            List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "children": List<dynamic>.from(children!.map((x) => x.toJson())),
      };
}

class Child {
  Child({
    this.isSuspended,
    this.dues,
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.email,
    this.course,
    this.batch,
    this.createdAt,
    this.userImage,
    this.contact,
    this.parentsContact,
    this.institution,
    this.institute,
  });

  bool? isSuspended;
  bool? dues;
  String? id;
  String? username;
  String? firstname;
  String? lastname;
  String? email;
  String? course;
  String? batch;
  DateTime? createdAt;
  String? userImage;
  String? contact;
  String? parentsContact;
  String? institution;
  String? institute;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        isSuspended: json["isSuspended"],
        dues: json["dues"],
        id: json["_id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        course: json["course"],
        batch: json["batch"],
        createdAt: DateTime.parse(json["createdAt"]),
        userImage: json["userImage"],
        contact: json["contact"],
        parentsContact: json["parentsContact"],
        institution: json["institution"],
        institute: json["institute"],
      );

  Map<String, dynamic> toJson() => {
        "isSuspended": isSuspended ?? "",
        "dues": dues ?? "",
        "_id": id ?? "",
        "username": username ?? "",
        "firstname": firstname ?? "",
        "lastname": lastname ?? "",
        "email": email ?? "",
        "course": course ?? "",
        "batch": batch ?? "",
        "createdAt": createdAt?.toIso8601String(),
        "userImage": userImage ?? "",
        "contact": contact ?? "",
        "parentsContact": parentsContact ?? "",
        "institution": institution ?? "",
        "institute": institute ?? "",
      };
}
