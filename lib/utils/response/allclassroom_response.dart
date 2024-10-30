// To parse this JSON data, do
//
//     final getAllClassRoomResponse = getAllClassRoomResponseFromJson(jsonString);

import 'dart:convert';

GetAllClassRoomResponse getAllClassRoomResponseFromJson(String str) => GetAllClassRoomResponse.fromJson(json.decode(str));

String getAllClassRoomResponseToJson(GetAllClassRoomResponse data) => json.encode(data.toJson());

class GetAllClassRoomResponse {
  GetAllClassRoomResponse({
    this.success,
    this.classrooms,
  });

  bool ? success;
  List<String> ? classrooms;

  factory GetAllClassRoomResponse.fromJson(Map<String, dynamic> json) => GetAllClassRoomResponse(
    success: json["success"],
    classrooms: List<String>.from(json["classrooms"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "classrooms": List<dynamic>.from(classrooms!.map((x) => x)),
  };
}
