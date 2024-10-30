// To parse this JSON data, do
//
//     final getparentequestresponse = getparentequestresponseFromJson(jsonString);

import 'dart:convert';

Getparentequestresponse getparentequestresponseFromJson(String str) => Getparentequestresponse.fromJson(json.decode(str));

String getparentequestresponseToJson(Getparentequestresponse data) => json.encode(data.toJson());

class Getparentequestresponse {
  Getparentequestresponse({
    this.success,
    this.requests,
  });

  bool ? success;
  List<dynamic> ? requests;

  factory Getparentequestresponse.fromJson(Map<String, dynamic> json) => Getparentequestresponse(
    success: json["success"],
    requests: List<dynamic>.from(json["requests"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "requests": List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}
