// To parse this JSON data, do
//
//     final dRollResponse = dRollResponseFromJson(jsonString);

import 'dart:convert';

DRollResponse dRollResponseFromJson(String str) => DRollResponse.fromJson(json.decode(str));

String dRollResponseToJson(DRollResponse data) => json.encode(data.toJson());

class DRollResponse {
  bool? success;
  List<dynamic>? droles;

  DRollResponse({
    this.success,
    this.droles,
  });

  factory DRollResponse.fromJson(Map<String, dynamic> json) => DRollResponse(
    success: json["success"],
    droles: json["droles"],
    // List<Drole>.from(json["droles"].map((x) => Drole.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "droles": droles,
    // List<dynamic>.from(droles.map((x) => x.toJson())),
  };
}

// class Drole {
//   List<Domain> domains;
//   String id;
//   String name;
//
//   Drole({
//     this.domains,
//     this.id,
//     this.name,
//   });
//
//   factory Drole.fromJson(Map<String, dynamic> json) => Drole(
//     domains: List<Domain>.from(json["domains"].map((x) => domainValues.map[x])),
//     id: json["_id"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "domains": List<dynamic>.from(domains.map((x) => domainValues.reverse[x])),
//     "_id": id,
//     "name": name,
//   };
// }

