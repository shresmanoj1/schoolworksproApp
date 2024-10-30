// To parse this JSON data, do
//
//     final GetFeesResponse = GetFeesResponseFromJson(jsonString);

import 'dart:convert';

GetFeesResponse GetFeesResponseFromJson(String str) =>
    GetFeesResponse.fromJson(json.decode(str));

String GetFeesResponseToJson(GetFeesResponse data) =>
    json.encode(data.toJson());

class GetFeesResponse {
  GetFeesResponse({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory GetFeesResponse.fromJson(Map<String, dynamic> json) =>
      GetFeesResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.payments,
    this.studentDetail,
  });

  List<dynamic>? payments;
  dynamic studentDetail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payments: List<dynamic>.from(json["payments"].map((x) => x)),
        studentDetail: json["studentDetail"],
      );

  Map<String, dynamic> toJson() => {
        "payments": List<dynamic>.from(payments!.map((x) => x)),
        "studentDetail": studentDetail,
      };
}
