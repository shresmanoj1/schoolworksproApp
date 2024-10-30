// To parse this JSON data, do
//
//     final feeAdminRequest = feeAdminRequestFromJson(jsonString);

import 'dart:convert';

FeeAdminRequest feeAdminRequestFromJson(String str) => FeeAdminRequest.fromJson(json.decode(str));

String feeAdminRequestToJson(FeeAdminRequest data) => json.encode(data.toJson());

class FeeAdminRequest {
  FeeAdminRequest({
    this.studentId,
    this.institution,
  });

  String ? studentId;
  String ? institution;

  factory FeeAdminRequest.fromJson(Map<String, dynamic> json) => FeeAdminRequest(
    studentId: json["studentId"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "institution": institution,
  };
}
