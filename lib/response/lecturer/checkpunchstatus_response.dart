// To parse this JSON data, do
//
//     final checkPunchStatus = checkPunchStatusFromJson(jsonString);

import 'dart:convert';

CheckPunchStatus checkPunchStatusFromJson(String str) =>
    CheckPunchStatus.fromJson(json.decode(str));

String checkPunchStatusToJson(CheckPunchStatus data) =>
    json.encode(data.toJson());

class CheckPunchStatus {
  CheckPunchStatus({
    this.success,
    this.status,
  });

  bool? success;
  dynamic status;

  factory CheckPunchStatus.fromJson(Map<String, dynamic> json) =>
      CheckPunchStatus(
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
      };
}

// class Status {
//   Status({
//     this.id,
//     this.status,
//   });
//
//   String ? id;
//   String ? status;
//
//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//         id: json["_id"],
//         status: json["status"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "status": status,
//       };
// }
