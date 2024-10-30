// To parse this JSON data, do
//
//     final addHomeworkRequest = addHomeworkRequestFromJson(jsonString);

import 'dart:convert';

import '../../response/lecturer/group_result_mark_response.dart';

GroupAllMarksRequest groupAllMarksRequestFromJson(String str) => GroupAllMarksRequest.fromJson(json.decode(str));

String addHomeworkRequestToJson(GroupAllMarksRequest data) => json.encode(data.toJson());

class GroupAllMarksRequest {
  GroupAllMarksRequest({
    this.groupType,
    this.headings,
    this.title
  });


  String? groupType;
  String? title;
  List<Heading>? headings;

  factory GroupAllMarksRequest.fromJson(Map<String, dynamic> json) => GroupAllMarksRequest(
    groupType: json["groupType"],
    title: json["title"],
    headings: List<Heading>.from(json["headings"].map((x) => Heading.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "groupType": groupType,
    "title": title,
    "headings": List<dynamic>.from(headings!.map((x) => x.toJson())),
  };
}


class Heading{
  String? title;
  String? marks;
  String? examSlug;
  Heading({this.title, this.marks, this.examSlug});

  factory Heading.fromJson(Map<String, dynamic> json) => Heading(
    title: json["title"],
    marks: json["marks"],
    examSlug: json["examSlug"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "marks": marks,
    "examSlug": examSlug,
  };
}
