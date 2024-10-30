// To parse this JSON data, do
//
//     final myExamGenerateQrResponse = myExamGenerateQrResponseFromJson(jsonString);

import 'dart:convert';

MyExamGenerateQrResponse myExamGenerateQrResponseFromJson(String str) => MyExamGenerateQrResponse.fromJson(json.decode(str));

String myExamGenerateQrResponseToJson(MyExamGenerateQrResponse data) => json.encode(data.toJson());

class MyExamGenerateQrResponse {
  bool? success;
  dynamic qrData;

  MyExamGenerateQrResponse({
    this.success,
    this.qrData,
  });

  factory MyExamGenerateQrResponse.fromJson(Map<String, dynamic> json) => MyExamGenerateQrResponse(
    success: json["success"],
    qrData: json["qrData"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "qrData": qrData,
  };
}

class QrData {
  String? firstname;
  String? lastname;
  String? batch;
  String? institution;
  String? username;
  String? exams;
  String? token;

  QrData({
    this.firstname,
    this.lastname,
    this.batch,
    this.institution,
    this.username,
    this.exams,
    this.token,
  });

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    firstname: json["firstname"],
    lastname: json["lastname"],
    batch: json["batch"],
    institution: json["institution"],
    username: json["username"],
    exams: json["exams"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "batch": batch,
    "institution": institution,
    "username": username,
    "exams": exams,
    "token": token,
  };
}
