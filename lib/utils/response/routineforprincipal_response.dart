// To parse this JSON data, do
//
//     final routineForPrincipalStats = routineForPrincipalStatsFromJson(jsonString);

import 'dart:convert';

RoutineForPrincipalStats routineForPrincipalStatsFromJson(String str) => RoutineForPrincipalStats.fromJson(json.decode(str));

String routineForPrincipalStatsToJson(RoutineForPrincipalStats data) => json.encode(data.toJson());

class RoutineForPrincipalStats {
  RoutineForPrincipalStats({
    this.success,
    this.routines,
  });

  bool ? success;
  List<dynamic> ? routines;

  factory RoutineForPrincipalStats.fromJson(Map<String, dynamic> json) => RoutineForPrincipalStats(
    success: json["success"],
    routines: List<dynamic>.from(json["routines"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "routines": List<dynamic>.from(routines!.map((x) => x)),
  };
}
