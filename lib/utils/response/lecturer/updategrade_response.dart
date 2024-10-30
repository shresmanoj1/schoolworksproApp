// To parse this JSON data, do
//
//     final updateGradeResponse = updateGradeResponseFromJson(jsonString);

import 'dart:convert';

UpdateGradeResponse updateGradeResponseFromJson(String str) => UpdateGradeResponse.fromJson(json.decode(str));

String updateGradeResponseToJson(UpdateGradeResponse data) => json.encode(data.toJson());

class UpdateGradeResponse {
  UpdateGradeResponse({
    this.success,
    this.message,
    this.result,
  });

  bool ? success;
  String ? message;
  dynamic result;

  factory UpdateGradeResponse.fromJson(Map<String, dynamic> json) => UpdateGradeResponse(
    success: json["success"],
    message: json["message"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result,
  };
}

