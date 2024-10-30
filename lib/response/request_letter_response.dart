// To parse this JSON data, do
//
//     final requestLetterResponse = requestLetterResponseFromJson(jsonString);

import 'dart:convert';

RequestLetterResponse requestLetterResponseFromJson(String str) =>
    RequestLetterResponse.fromJson(json.decode(str));

String requestLetterResponseToJson(RequestLetterResponse data) =>
    json.encode(data.toJson());

class RequestLetterResponse {
  RequestLetterResponse({
    this.success,
    this.message,
    this.letters,
  });

  bool? success;
  String? message;
  List<Letter>? letters;

  factory RequestLetterResponse.fromJson(Map<String, dynamic> json) =>
      RequestLetterResponse(
        success: json["success"],
        message: json["message"],
        letters:
            List<Letter>.from(json["letters"].map((x) => Letter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "letters": List<dynamic>.from(letters!.map((x) => x.toJson())),
      };
}

class Letter {
  Letter({
    this.referenceNo,
    this.issued,
    this.id,
    this.letterType,
    this.signee,
    this.content,
    this.requestedBy,
    this.institution,
    this.parent,
    this.createdAt,
    this.updatedAt,
    this.certificate,
  });

  String? referenceNo;
  bool? issued;
  String? id;
  String? letterType;
  String? signee;
  String? content;
  String? requestedBy;
  String? institution;
  String? parent;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? certificate;

  factory Letter.fromJson(Map<String, dynamic> json) => Letter(
        referenceNo: json["referenceNo"],
        issued: json["issued"],
        id: json["_id"],
        letterType: json["letterType"],
        signee: json["signee"],
        content: json["content"],
        requestedBy: json["requestedBy"],
        institution: json["institution"],
        parent: json["parent"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        certificate: json["certificate"],
      );

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "issued": issued,
        "_id": id,
        "letterType": letterType,
        "signee": signee,
        "content": content,
        "requestedBy": requestedBy,
        "institution": institution,
        "parent": parent,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "certificate": certificate,
      };
}
