// To parse this JSON data, do
//
//     final encryptStudentQrResponse = encryptStudentQrResponseFromJson(jsonString);

import 'dart:convert';

EncryptStudentQrResponse encryptStudentQrResponseFromJson(String str) => EncryptStudentQrResponse.fromJson(json.decode(str));

String encryptStudentQrResponseToJson(EncryptStudentQrResponse data) => json.encode(data.toJson());

class EncryptStudentQrResponse {
  EncryptStudentQrResponse({
    this.success,
    this.qrData,
  });

  bool? success;
  QrData? qrData;

  factory EncryptStudentQrResponse.fromJson(Map<String, dynamic> json) => EncryptStudentQrResponse(
    success: json["success"],
    qrData: QrData.fromJson(json["qrData"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "qrData": qrData?.toJson(),
  };
}

class QrData {
  QrData({
    this.username,
    this.batch,
    this.moduleSlug,
    this.classType,
    this.attendanceBy,
    this.institution,
    this.token,
    this.qrType,
    this.date,
  });

  String? username;
  String? batch;
  String? moduleSlug;
  String? classType;
  String? attendanceBy;
  String? institution;
  String? token;
  String? qrType;
  String? date;

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    username: json["username"],
    batch: json["batch"],
    moduleSlug: json["moduleSlug"],
    classType: json["classType"],
    attendanceBy: json["attendanceBy"],
    institution: json["institution"],
    token: json["token"],
    qrType: json["qrType"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "batch": batch,
    "moduleSlug": moduleSlug,
    "classType": classType,
    "attendanceBy": attendanceBy,
    "institution": institution,
    "token": token,
    "qrType": qrType,
    "date": date,
  };
}
