// To parse this JSON data, do
//
//     final getAllClubResponse = getAllClubResponseFromJson(jsonString);

import 'dart:convert';

GetAllClubResponse getAllClubResponseFromJson(String str) => GetAllClubResponse.fromJson(json.decode(str));

String getAllClubResponseToJson(GetAllClubResponse data) => json.encode(data.toJson());

class GetAllClubResponse {
  GetAllClubResponse({
    this.success,
    this.clubs,
  });

  bool ? success;
  List<Club> ? clubs;

  factory GetAllClubResponse.fromJson(Map<String, dynamic> json) => GetAllClubResponse(
    success: json["success"],
    clubs: List<Club>.from(json["clubs"].map((x) => Club.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "clubs": List<dynamic>.from(clubs!.map((x) => x.toJson())),
  };
}

class Club {
  Club({
    this.id,
    this.isVacancyOpen,
    this.clubName,
    this.clubDescription,
    this.coverPhoto,
    this.clubSlug,
  });

  String ? id;
  bool ? isVacancyOpen;
  String ? clubName;
  String ? clubDescription;
  String ? coverPhoto;
  String ? clubSlug;

  factory Club.fromJson(Map<String, dynamic> json) => Club(
    id: json["_id"],
    isVacancyOpen: json["isVacancyOpen"],
    clubName: json["clubName"],
    clubDescription: json["clubDescription"],
    coverPhoto: json["coverPhoto"],
    clubSlug: json["clubSlug"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isVacancyOpen": isVacancyOpen,
    "clubName": clubName,
    "clubDescription": clubDescription,
    "coverPhoto": coverPhoto,
    "clubSlug": clubSlug,
  };
}
