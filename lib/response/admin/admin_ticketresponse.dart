// To parse this JSON data, do
//
//     final AdminRespondResponse = AdminRespondResponseFromJson(jsonString);

import 'dart:convert';

AdminRespondResponse AdminRespondResponseFromJson(String str) =>
    AdminRespondResponse.fromJson(json.decode(str));

String AdminRespondResponseToJson(AdminRespondResponse data) =>
    json.encode(data.toJson());

class AdminRespondResponse {
  AdminRespondResponse({
    this.success,
    this.response,
  });

  bool? success;
  dynamic response;

  factory AdminRespondResponse.fromJson(Map<String, dynamic> json) =>
      AdminRespondResponse(
        success: json["success"],
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "response": response,
      };
}
