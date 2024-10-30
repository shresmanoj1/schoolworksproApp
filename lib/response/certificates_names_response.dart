// To parse this JSON data, do
//
//     final certificateNamesResponse = certificateNamesResponseFromJson(jsonString);

import 'dart:convert';

CertificateNamesResponse certificateNamesResponseFromJson(String str) =>
    CertificateNamesResponse.fromJson(json.decode(str));

String certificateNamesResponseToJson(CertificateNamesResponse data) =>
    json.encode(data.toJson());

class CertificateNamesResponse {
  CertificateNamesResponse({
    this.success,
    this.certificates,
  });

  bool? success;
  List<Certificate>? certificates;

  factory CertificateNamesResponse.fromJson(Map<String, dynamic> json) =>
      CertificateNamesResponse(
        success: json["success"],
        certificates: List<Certificate>.from(
            json["certificates"].map((x) => Certificate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "certificates":
            List<dynamic>.from(certificates!.map((x) => x.toJson())),
      };
}

class Certificate {
  Certificate({
    this.id,
    this.builderName,
  });

  String? id;
  String? builderName;

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        id: json["_id"],
        builderName: json["builderName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "builderName": builderName,
      };
}
