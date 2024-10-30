// To parse this JSON data, do
//
//     final StudentGradingRequest = StudentGradingRequestFromJson(jsonString);

import 'dart:convert';

StudentGradingRequest StudentGradingRequestFromJson(String str) =>
    StudentGradingRequest.fromJson(json.decode(str));

String StudentGradingRequestToJson(StudentGradingRequest data) =>
    json.encode(data.toJson());

class StudentGradingRequest {
  StudentGradingRequest({
    this.marks,
    this.batch,
    this.moduleSlug,
    this.courseSlug,
    this.examSlug,
  });

  List<Mark>? marks;
  String? batch;
  String? moduleSlug;
  String? courseSlug;
  String? examSlug;

  factory StudentGradingRequest.fromJson(Map<String, dynamic> json) =>
      StudentGradingRequest(
        marks: List<Mark>.from(json["marks"].map((x) => Mark.fromJson(x))),
        batch: json["batch"],
        moduleSlug: json["moduleSlug"],
        courseSlug: json["courseSlug"],
        examSlug: json["examSlug"],
      );

  Map<String, dynamic> toJson() => {
        "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
        "batch": batch,
        "moduleSlug": moduleSlug,
        "courseSlug": courseSlug,
        "examSlug": examSlug,
      };
}

class Mark {
  Mark({this.username, this.isAbsent, this.data, this.name, this.params});

  String? username;
  String? name;
  List<Datum>? data;
  bool? isAbsent;
  Map<String, dynamic>? params;

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        name: json["name"],
        username: json["username"],
        isAbsent: json["isAbsent"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        params: Map<String, dynamic>.from(json["params"]),
      );

  // Map<String, dynamic> toJson() => {
  //   "name": name,
  //   "username": username,
  //   "isAbsent": isAbsent,
  //   "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  //   "params": params??{},
  // };
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {
      "name": name,
      "username": username,
      "isAbsent": isAbsent,
      "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };

    if (params != null) {
      jsonData.addAll(params!);
    }
    if (jsonData['isAbsent'] == null) {
      jsonData.remove('isAbsent');
    }
    if (jsonData['username'] == null) {
      jsonData.remove('username');
    }
    if (jsonData["name"] == null) {
      jsonData.remove("name");
    }

    return jsonData;
  }
}

class Datum {
  Datum({this.heading, this.marks, this.id});

  String? heading;
  dynamic marks;
  String? id;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        heading: json["heading"],
        marks: json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "marks": marks,
      };
}
