// To parse this JSON data, do
//
//     final getExamResponse = getExamResponseFromJson(jsonString);

import 'dart:convert';

GetExamResponse getExamResponseFromJson(String str) =>
    GetExamResponse.fromJson(json.decode(str));

String getExamResponseToJson(GetExamResponse data) =>
    json.encode(data.toJson());

class GetExamResponse {
  GetExamResponse({
    this.success,
    this.allExam,
  });

  bool? success;
  List<dynamic>? allExam;

  factory GetExamResponse.fromJson(Map<String, dynamic> json) =>
      GetExamResponse(
        success: json["success"],
        allExam:
            List<dynamic>.from(json["allExam"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allExam": List<dynamic>.from(allExam!.map((x) => x)),
      };
}

