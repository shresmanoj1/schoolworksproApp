// To parse this JSON data, do
//
//     final documentresponse = documentresponseFromJson(jsonString);

import 'dart:convert';

Documentresponse documentresponseFromJson(String str) =>
    Documentresponse.fromJson(json.decode(str));

String documentresponseToJson(Documentresponse data) =>
    json.encode(data.toJson());

class Documentresponse {
  Documentresponse({
    this.success,
    this.documents,
  });

  bool? success;
  List<Document>? documents;

  factory Documentresponse.fromJson(Map<String, dynamic> json) =>
      Documentresponse(
        success: json["success"],
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "documents": List<dynamic>.from(documents!.map((x) => x.toJson())),
      };
}

class Document {
  Document({
    this.id,
    this.docType,
    this.docName,
  });

  String? id;
  String? docType;
  String? docName;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["_id"],
        docType: json["docType"],
        docName: json["docName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "docType": docType,
        "docName": docName,
      };
}
