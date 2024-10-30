import 'dart:convert';

GetAdvisorResponse getAdvisorResponseFromJson(String str) =>
    GetAdvisorResponse.fromJson(json.decode(str));

String getAdvisorResponseToJson(GetAdvisorResponse data) =>
    json.encode(data.toJson());

class GetAdvisorResponse {
  GetAdvisorResponse({
    this.success,
    this.advisor,
  });

  bool? success;
  List<dynamic>? advisor;

  factory GetAdvisorResponse.fromJson(Map<String, dynamic> json) =>
      GetAdvisorResponse(
        success: json["success"],
        advisor: List<dynamic>.from(json["advisor"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "advisor": List<dynamic>.from(advisor!.map((x) => x.toJson())),
      };
}
