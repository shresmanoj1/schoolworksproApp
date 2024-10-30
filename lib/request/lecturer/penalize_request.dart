// To parse this JSON data, do
//
//     final penalizeRequest = penalizeRequestFromJson(jsonString);

import 'dart:convert';

PenalizeRequest penalizeRequestFromJson(String str) =>
    PenalizeRequest.fromJson(json.decode(str));

String penalizeRequestToJson(PenalizeRequest data) =>
    json.encode(data.toJson());

class PenalizeRequest {
  PenalizeRequest({
    this.remarks,
    this.username,
  });

  String? remarks;
  String? username;

  factory PenalizeRequest.fromJson(Map<String, dynamic> json) =>
      PenalizeRequest(
        remarks: json["remarks"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "remarks": remarks,
        "username": username,
      };
}
