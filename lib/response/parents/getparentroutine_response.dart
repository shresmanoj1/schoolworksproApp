// To parse this JSON data, do
//
//     final getparentroutineresponse = getparentroutineresponseFromJson(jsonString);

import 'dart:convert';

Getparentroutineresponse getparentroutineresponseFromJson(String str) => Getparentroutineresponse.fromJson(json.decode(str));

String getparentroutineresponseToJson(Getparentroutineresponse data) => json.encode(data.toJson());

class Getparentroutineresponse {
  Getparentroutineresponse({
    this.success,
    this.routines,
  });

  bool ? success;
  List<dynamic> ? routines;

  factory Getparentroutineresponse.fromJson(Map<String, dynamic> json) => Getparentroutineresponse(
    success: json["success"],
    routines: List<dynamic>.from(json["routines"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "routines": List<dynamic>.from(routines!.map((x) => x.toJson())),
  };
}

