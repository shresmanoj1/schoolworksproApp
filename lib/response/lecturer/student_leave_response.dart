// To parse this JSON data, do
//
//     final studentLeaveResponse = studentLeaveResponseFromJson(jsonString);

import 'dart:convert';

StudentLeaveResponse studentLeaveResponseFromJson(String str) => StudentLeaveResponse.fromJson(json.decode(str));

String studentLeaveResponseToJson(StudentLeaveResponse data) => json.encode(data.toJson());

class StudentLeaveResponse {
  StudentLeaveResponse({
    this.success,
    this.studentLeaves,
  });

  bool? success;
  List<StudentLeaf>? studentLeaves;

  factory StudentLeaveResponse.fromJson(Map<String, dynamic> json) => StudentLeaveResponse(
    success: json["success"],
    studentLeaves: List<StudentLeaf>.from(json["studentLeaves"].map((x) => StudentLeaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "studentLeaves": List<dynamic>.from(studentLeaves!.map((x) => x.toJson())),
  };
}

class StudentLeaf {
  StudentLeaf({
    this.username,
    this.leaves,
  });

  String? username;
  List<Leaf>? leaves;

  factory StudentLeaf.fromJson(Map<String, dynamic> json) => StudentLeaf(
    username: json["username"],
    leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "leaves": List<dynamic>.from(leaves!.map((x) => x.toJson())),
  };
}

class Leaf {
  Leaf({
    this.status,
    this.routines,
    this.isStudent,
    this.allDay,
    this.id,
    this.leaveTitle,
    this.content,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.user,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.ticket,
  });

  String? status;
  List<dynamic>? routines;
  bool? isStudent;
  bool? allDay;
  String? id;
  String? leaveTitle;
  String? content;
  String? leaveType;
  DateTime? startDate;
  DateTime? endDate;
  User? user;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? ticket;

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
    status: json["status"],
    routines: List<dynamic>.from(json["routines"].map((x) => x)),
    isStudent: json["isStudent"],
    allDay: json["allDay"],
    id: json["_id"],
    leaveTitle: json["leaveTitle"],
    content: json["content"],
    leaveType: json["leaveType"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    user: User.fromJson(json["user"]),
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    ticket: json["ticket"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "routines": List<dynamic>.from(routines!.map((x) => x)),
    "isStudent": isStudent,
    "allDay": allDay,
    "_id": id,
    "leaveTitle": leaveTitle,
    "content": content,
    "leaveType": leaveType,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "user": user?.toJson(),
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "ticket": ticket,
  };
}

class User {
  User({
    this.type,
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.userImage,
  });

  String? type;
  String? id;
  String? firstname;
  String? lastname;
  String? username;
  String? userImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    type: json["type"],
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    userImage: json["userImage"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "userImage": userImage,
  };
}
