import 'dart:convert';

GetAdmissionusernameresponse getAdmissionusernameresponseFromJson(String str) =>
    GetAdmissionusernameresponse.fromJson(json.decode(str));

String getAdmissionusernameresponseToJson(GetAdmissionusernameresponse data) =>
    json.encode(data.toJson());

class GetAdmissionusernameresponse {
  GetAdmissionusernameresponse({
    this.success,
    this.admission,
  });

  bool? success;
  Admission? admission;

  factory GetAdmissionusernameresponse.fromJson(Map<String, dynamic> json) =>
      GetAdmissionusernameresponse(
        success: json["success"],
        admission: Admission.fromJson(json["admission"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "admission": admission?.toJson(),
      };
}

class Admission {
  Admission({
    this.username,
  });

  String? username;

  factory Admission.fromJson(Map<String, dynamic> json) => Admission(
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
      };
}
