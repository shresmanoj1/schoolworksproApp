// To parse this JSON data, do
//
//     final getLeaveResponseNew = getLeaveResponseNewFromJson(jsonString);

import 'dart:convert';

GetLeaveResponseNew getLeaveResponseNewFromJson(String str) => GetLeaveResponseNew.fromJson(json.decode(str));

String getLeaveResponseNewToJson(GetLeaveResponseNew data) => json.encode(data.toJson());

class GetLeaveResponseNew {
  GetLeaveResponseNew({
    this.success,
    this.leave,
    this.leaveType,
  });

  bool ? success;
  List<dynamic> ? leave;
  dynamic leaveType;

  factory GetLeaveResponseNew.fromJson(Map<String, dynamic> json) => GetLeaveResponseNew(
    success: json["success"],
    leave: List<dynamic>.from(json["leave"].map((x) => x)),
    leaveType: json["leave_type"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "leave": List<dynamic>.from(leave!.map((x) => x)),
    "leave_type": leaveType,
  };
}

