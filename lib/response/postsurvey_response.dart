// To parse this JSON data, do
//
//     final postsurveyresponse = postsurveyresponseFromJson(jsonString);

import 'dart:convert';

Postsurveyresponse postsurveyresponseFromJson(String str) =>
    Postsurveyresponse.fromJson(json.decode(str));

String postsurveyresponseToJson(Postsurveyresponse data) =>
    json.encode(data.toJson());

class Postsurveyresponse {
  Postsurveyresponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Postsurveyresponse.fromJson(Map<String, dynamic> json) =>
      Postsurveyresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
