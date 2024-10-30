// To parse this JSON data, do
//
//     final collaborationGroupResponse = collaborationGroupResponseFromJson(jsonString);

import 'dart:convert';

CollaborationGroupResponse collaborationGroupResponseFromJson(String str) => CollaborationGroupResponse.fromJson(json.decode(str));

String collaborationGroupResponseToJson(CollaborationGroupResponse data) => json.encode(data.toJson());

class CollaborationGroupResponse {
  CollaborationGroupResponse({
    this.success,
    this.assignmentGroup,
  });

  bool? success;
  List<AssignmentGroup>? assignmentGroup;

  factory CollaborationGroupResponse.fromJson(Map<String, dynamic> json) => CollaborationGroupResponse(
    success: json["success"],
    assignmentGroup: List<AssignmentGroup>.from(json["assignmentGroup"].map((x) => AssignmentGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assignmentGroup": List<dynamic>.from(assignmentGroup!.map((x) => x.toJson())),
  };
}

class AssignmentGroup {
  AssignmentGroup({
    this.users,
    this.hasEdit,
    this.assignmentSubGroup,
    this.id,
    this.assignment,
    this.groupName,
    this.createdBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  List<User>? users;
  List<String>? hasEdit;
  List<AssignmentSubGroup>? assignmentSubGroup;
  String? id;
  String? assignment;
  String? groupName;
  String? createdBy;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AssignmentGroup.fromJson(Map<String, dynamic> json) => AssignmentGroup(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    hasEdit: List<String>.from(json["hasEdit"].map((x) => x)),
    assignmentSubGroup: List<AssignmentSubGroup>.from(json["assignmentSubGroup"].map((x) => AssignmentSubGroup.fromJson(x))),
    id: json["_id"],
    assignment: json["assignment"],
    groupName: json["groupName"],
    createdBy: json["createdBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
    "hasEdit": List<dynamic>.from(hasEdit!.map((x) => x)),
    "assignmentSubGroup": List<dynamic>.from(assignmentSubGroup!.map((x) => x.toJson())),
    "_id": id,
    "assignment": assignment,
    "groupName": groupName,
    "createdBy": createdBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AssignmentSubGroup {
  AssignmentSubGroup({
    this.title,
    this.color,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? title;
  String? color;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory AssignmentSubGroup.fromJson(Map<String, dynamic> json) => AssignmentSubGroup(
    title: json["title"],
    color: json["color"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "color": color,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.contact,
    this.address,
    this.course,
    this.batch,
    this.institution,
    this.username,
    this.userImage,
    this.coventryId,
  });

  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? contact;
  String? address;
  String? course;
  String? batch;
  String? institution;
  String? username;
  String? userImage;
  dynamic coventryId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    contact: json["contact"],
    address: json["address"],
    course: json["course"],
    batch: json["batch"],
    institution: json["institution"],
    username: json["username"],
    userImage: json["userImage"],
    coventryId: json["coventryID"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "contact": contact,
    "address": address,
    "course": course,
    "batch": batch,
    "institution": institution,
    "username": username,
    "userImage": userImage,
    "coventryID": coventryId,
  };
}
