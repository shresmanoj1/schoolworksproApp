// To parse this JSON data, do
//
//     final AllLogisticsresponse = AllLogisticsresponseFromJson(jsonString);

import 'dart:convert';

AllLogisticsresponse AllLogisticsresponseFromJson(String str) =>
    AllLogisticsresponse.fromJson(json.decode(str));

String AllLogisticsresponseToJson(AllLogisticsresponse data) =>
    json.encode(data.toJson());

class AllLogisticsresponse {
  AllLogisticsresponse({
    this.success,
    this.allLogistics,
  });

  bool? success;
  List<dynamic>? allLogistics;

  factory AllLogisticsresponse.fromJson(Map<String, dynamic> json) =>
      AllLogisticsresponse(
        success: json["success"],
        allLogistics: List<dynamic>.from(json["allLogistics"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allLogistics":
            List<dynamic>.from(allLogistics!.map((x) => x.toJson())),
      };
}
