// To parse this JSON data, do
//
//     final resultresponse = resultresponseFromJson(jsonString);

import 'dart:convert';

Resultresponse resultresponseFromJson(String str) =>
    Resultresponse.fromJson(json.decode(str));

String resultresponseToJson(Resultresponse data) => json.encode(data.toJson());

class Resultresponse {
  Resultresponse({
    this.success,
    this.results,
  });

  bool? success;
  List<Result>? results;

  factory Resultresponse.fromJson(Map<String, dynamic> json) => Resultresponse(
        success: json["success"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.cuStudentId,
    this.studentId,
    this.fullname,
    this.subject,
    this.status,
    this.course,
    this.cw,
    this.ex,
    this.mm,
    this.cr,
    this.gd,
    this.institution,
  });

  String? id;
  String? cuStudentId;
  String? studentId;
  String? fullname;
  String? subject;
  String? status;
  String? course;
  String? cw;
  String? ex;
  String? mm;
  String? cr;
  String? gd;
  String? institution;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"] == null ? null : json["_id"],
        cuStudentId:
            json["CU Student ID"] == null ? null : json["CU Student ID"],
        studentId: json["student_id"] == null ? null : json["student_id"],
        fullname: json["Fullname"] == null ? null : json["Fullname"],
        subject: json["Subject"] == null ? null : json["Subject"],
        status: json["Status"] == null ? null : json["Status"],
        course: json["Course"] == null ? null : json["Course"],
        cw: json["Cw"] == null ? null : json["Cw"],
        ex: json["Ex"] == null ? null : json["Ex"],
        mm: json["Mm"] == null ? null : json["Mm"],
        cr: json["Cr"] == null ? null : json["Cr"],
        gd: json["Gd"] == null ? null : json["Gd"],
        institution: json["institution"] == null ? null : json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "CU Student ID": cuStudentId == null ? null : cuStudentId,
        "student_id": studentId == null ? null : studentId,
        "Fullname": fullname == null ? null : fullname,
        "Subject": subject == null ? null : subject,
        "Status": status == null ? null : status,
        "Course": course == null ? null : course,
        "Cw": cw == null ? null : cw,
        "Ex": ex == null ? null : ex,
        "Mm": mm == null ? null : mm,
        "Cr": cr == null ? null : cr,
        "Gd": gd == null ? null : gd,
        "institution": institution == null ? null : institution,
      };
}
