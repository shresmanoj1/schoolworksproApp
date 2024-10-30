// To parse this JSON data, do
//
//     final leaveResponse = leaveResponseFromJson(jsonString);

import 'dart:convert';

LeaveResponse leaveResponseFromJson(String str) =>
    LeaveResponse.fromJson(json.decode(str));

String leaveResponseToJson(LeaveResponse data) => json.encode(data.toJson());

class LeaveResponse {
  LeaveResponse({
    this.success,
    this.pendingCount,
    this.approvedCount,
    this.deniedCount,
    this.leave,
  });

  bool? success;
  int? pendingCount;
  int? approvedCount;
  int? deniedCount;
  List<Leave>? leave;

  factory LeaveResponse.fromJson(Map<String, dynamic> json) => LeaveResponse(
        success: json["success"],
        pendingCount: json["pendingCount"],
        approvedCount: json["approvedCount"],
        deniedCount: json["deniedCount"],
        leave: List<Leave>.from(json["leave"].map((x) => Leave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "pendingCount": pendingCount,
        "approvedCount": approvedCount,
        "deniedCount": deniedCount,
        "leave": List<dynamic>.from(leave!.map((x) => x.toJson())),
      };
}

// class Leave {
//   Leave({
//     this.status,
//     this.id,
//     this.leaveTitle,
//     this.content,
//     this.startDate,
//     this.endDate,
//     this.leaveType,
//     this.user,
//     this.createdAt,
//     this.updatedAt,
//     this.remarks,
//     this.institution,
//     this.allDay
//   });
//
//   String? status;
//   String? id;
//   String? leaveTitle;
//   String? content;
//   DateTime? startDate;
//   DateTime? endDate;
//   String? leaveType;
//   User? user;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? remarks;
//   String? institution;
//   bool? allDay;
//
//   factory Leave.fromJson(Map<String, dynamic> json) => Leave(
//         status: json["status"],
//     allDay: json["allDay"],
//         id: json["_id"],
//         leaveTitle: json["leaveTitle"],
//         content: json["content"],
//         startDate: DateTime.parse(json["startDate"]),
//         endDate: DateTime.parse(json["endDate"]),
//         leaveType: json["leaveType"],
//         user: User.fromJson(json["user"]),
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         remarks: json["remarks"] == null ? null : json["remarks"],
//         institution: json["institution"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "allDay": allDay,
//         "_id": id,
//         "leaveTitle": leaveTitle,
//         "content": content,
//         "startDate": startDate?.toIso8601String(),
//         "endDate": endDate?.toIso8601String(),
//         "leaveType": leaveType,
//         "user": user?.toJson(),
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "remarks": remarks == null ? null : remarks,
//         "institution": institution,
//       };
// }


class Leave {
  String? status;
  List<dynamic>? routines;
  bool? isStudent;
  bool? allDay;
  String? id;
  String? leaveTitle;
  String? content;
  DateTime? startDate;
  DateTime? endDate;
  String? leaveType;
  String? institution;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? ticket;
  String? remarks;

  Leave({
    this.status,
    this.routines,
    this.isStudent,
    this.allDay,
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
    this.ticket,
    this.remarks,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
    status: json["status"],
    routines: List<dynamic>.from(json["routines"].map((x) => x)),
    isStudent: json["isStudent"],
    allDay: json["allDay"],
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
    ticket: json["ticket"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "routines": List<dynamic>.from(routines!.map((x) => x)),
    "isStudent": isStudent,
    "allDay": allDay,
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
    "ticket": ticket,
    "remarks": remarks,
  };
}

class User {
  User({
    this.firstname,
    this.lastname,
  });

  String? firstname;
  String? lastname;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
      };
}
