// To parse this JSON data, do
//
//     final findallinstitutionresponse = findallinstitutionresponseFromJson(jsonString);

import 'dart:convert';

Findallinstitutionresponse findallinstitutionresponseFromJson(String str) =>
    Findallinstitutionresponse.fromJson(json.decode(str));

String findallinstitutionresponseToJson(Findallinstitutionresponse data) =>
    json.encode(data.toJson());

class Findallinstitutionresponse {
  Findallinstitutionresponse({
    this.success,
    this.institutions,
  });

  bool? success;
  List<Institution>? institutions;

  factory Findallinstitutionresponse.fromJson(Map<String, dynamic> json) =>
      Findallinstitutionresponse(
        success: json["success"],
        institutions: List<Institution>.from(
            json["institutions"].map((x) => Institution.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "institutions":
            List<dynamic>.from(institutions!.map((x) => x.toJson())),
      };
}

class Institution {
  Institution({
    this.id,
    this.name,
    this.alias,
    this.footerLogo,
    this.facebook,
    this.linkedin,
    this.instagram,
    this.website,
  });

  String? id;
  String? name;
  String? alias;
  String? footerLogo;
  String? facebook;
  String? linkedin;
  String? instagram;
  String? website;

  factory Institution.fromJson(Map<String, dynamic> json) => Institution(
        id: json["_id"],
        name: json["name"],
        alias: json["alias"],
        footerLogo: json["footerLogo"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        instagram: json["instagram"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "alias": alias,
        "footerLogo": footerLogo,
        "facebook": facebook,
        "linkedin": linkedin,
        "instagram": instagram,
        "website": website,
      };
}
