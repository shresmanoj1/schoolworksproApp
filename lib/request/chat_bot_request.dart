// To parse this JSON data, do
//
//     final chatBotRequesst = chatBotRequesstFromJson(jsonString);

import 'dart:convert';

ChatBotRequesst chatBotRequesstFromJson(String str) =>
    ChatBotRequesst.fromJson(json.decode(str));

String chatBotRequesstToJson(ChatBotRequesst data) =>
    json.encode(data.toJson());

class ChatBotRequesst {
  ChatBotRequesst({
    this.metadata,
    this.sender,
    this.message,
  });

  Metadata? metadata;
  String? sender;
  String? message;

  factory ChatBotRequesst.fromJson(Map<String, dynamic> json) =>
      ChatBotRequesst(
        metadata: Metadata.fromJson(json["metadata"]),
        sender: json["sender"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata?.toJson(),
        "sender": sender,
        "message": message,
      };
}

class Metadata {
  Metadata({
    this.firstname,
    this.studentId,
    this.batch,
    this.institution,
    this.courseSlug,
    this.token,
  });

  String? firstname;
  String? studentId;
  String? batch;
  String? institution;
  String? courseSlug;
  String? token;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        firstname: json["firstname"],
        studentId: json["studentId"],
        batch: json["batch"],
        institution: json["institution"],
        courseSlug: json["courseSlug"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "studentId": studentId,
        "batch": batch,
        "institution": institution,
        "courseSlug": courseSlug,
        "token": token,
      };
}
