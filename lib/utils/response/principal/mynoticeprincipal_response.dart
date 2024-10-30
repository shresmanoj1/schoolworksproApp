// To parse this JSON data, do
//
//     final mynoticeesponse = mynoticeesponseFromJson(jsonString);

import 'dart:convert';

Mynoticeesponse mynoticeesponseFromJson(String str) => Mynoticeesponse.fromJson(json.decode(str));

String mynoticeesponseToJson(Mynoticeesponse data) => json.encode(data.toJson());

class Mynoticeesponse {
  Mynoticeesponse({
    this.success,
    this.notices,
  });

  bool ? success;
  List<dynamic> ? notices;

  factory Mynoticeesponse.fromJson(Map<String, dynamic> json) => Mynoticeesponse(
    success: json["success"],
    notices: List<dynamic>.from(json["notices"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "notices": List<dynamic>.from(notices!.map((x) => x)),
  };
}
