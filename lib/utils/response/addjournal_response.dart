// To parse this JSON data, do
//
//     final addJournalresponse = addJournalresponseFromJson(jsonString);

import 'dart:convert';

AddJournalresponse addJournalresponseFromJson(String str) =>
    AddJournalresponse.fromJson(json.decode(str));

String addJournalresponseToJson(AddJournalresponse data) =>
    json.encode(data.toJson());

class AddJournalresponse {
  AddJournalresponse({
    this.success,
    this.message,
    this.journal,
    this.file,
  });

  bool? success;
  String? message;
  dynamic journal;
  dynamic file;

  factory AddJournalresponse.fromJson(Map<String, dynamic> json) =>
      AddJournalresponse(
        success: json["success"],
        message: json["message"],
        journal: json["journal"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "journal": journal,
        "file": file,
      };
}
