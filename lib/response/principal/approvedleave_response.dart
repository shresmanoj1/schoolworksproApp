// To parse this JSON data, do
//
//     final approvedLeaveResponse = approvedLeaveResponseFromJson(jsonString);

import 'dart:convert';

ApprovedLeaveResponse approvedLeaveResponseFromJson(String str) => ApprovedLeaveResponse.fromJson(json.decode(str));

String approvedLeaveResponseToJson(ApprovedLeaveResponse data) => json.encode(data.toJson());

class ApprovedLeaveResponse {
  ApprovedLeaveResponse({
    this.success,
    this.leaves,
  });

  bool ? success;
  List<Leaf> ? leaves;

  factory ApprovedLeaveResponse.fromJson(Map<String, dynamic> json) => ApprovedLeaveResponse(
    success: json["success"],
    leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "leaves": List<dynamic>.from(leaves!.map((x) => x.toJson())),
  };
}

class Leaf {
  Leaf({
    this.status,
    this.id,
    this.leaveTitle,
    this.content,
    this.startDate,
    this.endDate,
    this.leaveType,
    this.institution,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  String ? status;
  String ? id;
  String ? leaveTitle;
  String ? content;
  DateTime ? startDate;
  DateTime ? endDate;
  String ? leaveType;
  String ? institution;
  User ? user;
  DateTime ? createdAt;
  DateTime ? updatedAt;

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
    status: json["status"],
    id: json["_id"],
    leaveTitle: json["leaveTitle"],
    content: json["content"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    leaveType: json["leaveType"],
    institution: json["institution"],
    user: User.fromJson(json["user"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "_id": id,
    "leaveTitle": leaveTitle,
    "content": content,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "leaveType": leaveType,
    "institution": institution,
    "user": user?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class User {
  User({
    this.firstname,
    this.lastname,
  });

  String ? firstname;
  String ? lastname;

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstname: json["firstname"],
    lastname: json["lastname"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
  };
}
