// To parse this JSON data, do
//
//     final postActivityRequest = postActivityRequestFromJson(jsonString);

import 'dart:convert';

PostActivityRequest postActivityRequestFromJson(String str) => PostActivityRequest.fromJson(json.decode(str));

String postActivityRequestToJson(PostActivityRequest data) => json.encode(data.toJson());

class PostActivityRequest {
  PostActivityRequest({
    this.dueDate,
    this.contents,
    this.lessonSlug,
    this.batches,
  });

  DateTime ? dueDate;
  String ? contents;
  String ? lessonSlug;
  List<String> ? batches;

  factory PostActivityRequest.fromJson(Map<String, dynamic> json) => PostActivityRequest(
    dueDate: DateTime.parse(json["dueDate"]),
    contents: json["contents"],
    lessonSlug: json["lessonSlug"],
    batches: List<String>.from(json["batches"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "dueDate": dueDate?.toIso8601String(),
    "contents": contents,
    "lessonSlug": lessonSlug,
    "batches": List<dynamic>.from(batches!.map((x) => x)),
  };
}
