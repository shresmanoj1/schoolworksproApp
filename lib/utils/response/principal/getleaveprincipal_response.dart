// To parse this JSON data, do
//
//     final getLeavePrincipalResponse = getLeavePrincipalResponseFromJson(jsonString);

import 'dart:convert';

GetLeavePrincipalResponse getLeavePrincipalResponseFromJson(String str) =>
    GetLeavePrincipalResponse.fromJson(json.decode(str));

String getLeavePrincipalResponseToJson(GetLeavePrincipalResponse data) =>
    json.encode(data.toJson());

class GetLeavePrincipalResponse {
  GetLeavePrincipalResponse({
    this.success,
    this.leave,
  });

  bool? success;
  List<Leave>? leave;

  factory GetLeavePrincipalResponse.fromJson(Map<String, dynamic> json) =>
      GetLeavePrincipalResponse(
        success: json["success"],
        leave: List<Leave>.from(json["leave"].map((x) => Leave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "leave": List<dynamic>.from(leave!.map((x) => x.toJson())),
      };
}

class Leave {
  Leave({
    this.id,
    this.leaveType,
    this.days,
    this.time,
    this.institution,
  });

  String? id;
  String? leaveType;
  String? days;
  String? time;
  String? institution;

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["_id"],
        leaveType: json["leaveType"],
        days: json["days"],
        time: json["time"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "leaveType": leaveType,
        "days": days,
        "time": time,
        "institution": institution,
      };
}
