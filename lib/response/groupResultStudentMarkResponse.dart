// To parse this JSON data, do
//
//     final groupResultStudentMarkResponse = groupResultStudentMarkResponseFromJson(jsonString);

import 'dart:convert';

GroupResultStudentMarkResponse groupResultStudentMarkResponseFromJson(String str) => GroupResultStudentMarkResponse.fromJson(json.decode(str));

String groupResultStudentMarkResponseToJson(GroupResultStudentMarkResponse data) => json.encode(data.toJson());

class GroupResultStudentMarkResponse {
  bool? success;
  List<StudentList>? studentList;

  GroupResultStudentMarkResponse({
    this.success,
    this.studentList,
  });

  factory GroupResultStudentMarkResponse.fromJson(Map<String, dynamic> json) => GroupResultStudentMarkResponse(
    success: json["success"],
    studentList: json["studentList"] == null ? [] : List<StudentList>.from(json["studentList"].map((x) => StudentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "studentList": List<dynamic>.from(studentList!.map((x) => x.toJson())),
  };
}

class StudentList {
  String? id;
  String? course;
  String? batch;
  String? email;
  String? username;
  String? firstname;
  String? lastname;
  String? studentId;
  String? coventryId;
  List<StudentListMark>? marks;

  StudentList({
    this.id,
    this.course,
    this.batch,
    this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.studentId,
    this.coventryId,
    this.marks,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
    id: json["_id"],
    course: json["course"],
    batch: json["batch"],
    email: json["email"],
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    studentId: json["studentId"],
    coventryId: json["coventryID"],
    marks: List<StudentListMark>.from(json["marks"].map((x) => StudentListMark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "course": course,
    "batch": batch,
    "email": email,
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "studentId": studentId,
    "coventryID": coventryId,
    "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
  };
}

class StudentListMark {
  String? status;
  List<MarkMark>? marks;
  String? resultType;
  String? moduleSlug;
  String? batch;
  String? groupResult;
  String? overall;
  String? calculatedOverall;
  String? addedBy;
  String? institution;
  String? remarks;
  ModuleData? moduleData;

  StudentListMark({
    this.status,
    this.marks,
    this.resultType,
    this.moduleSlug,
    this.batch,
    this.groupResult,
    this.overall,
    this.calculatedOverall,
    this.addedBy,
    this.institution,
    this.remarks,
    this.moduleData,
  });

  factory StudentListMark.fromJson(Map<String, dynamic> json) => StudentListMark(
    status: json["status"],
    marks: List<MarkMark>.from(json["marks"].map((x) => MarkMark.fromJson(x))),
    resultType: json["resultType"],
    moduleSlug: json["moduleSlug"],
    batch: json["batch"],
    groupResult: json["groupResult"],
    overall: json["overall"],
    calculatedOverall: json["calculatedOverall"],
    addedBy: json["addedBy"],
    institution: json["institution"],
    remarks: json["remarks"],
    moduleData: ModuleData.fromJson(json["moduleData"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
    "resultType": resultType,
    "moduleSlug": moduleSlug,
    "batch": batch,
    "groupResult": groupResult,
    "overall": overall,
    "calculatedOverall": calculatedOverall,
    "addedBy": addedBy,
    "institution": institution,
    "remarks": remarks,
    "moduleData": moduleData?.toJson(),
  };
}

class MarkMark {
  String? id;
  String? title;
  String? groupType;
  List<Heading>? headings;
  num? total;
  num? calculatedTotal;

  MarkMark({
    this.id,
    this.title,
    this.groupType,
    this.headings,
    this.total,
    this.calculatedTotal,
  });

  factory MarkMark.fromJson(Map<String, dynamic> json) => MarkMark(
    id: json["_id"],
    title: json["title"],
    groupType: json["groupType"],
    headings: List<Heading>.from(json["headings"].map((x) => Heading.fromJson(x))),
    total: json["total"].toDouble(),
    calculatedTotal: json["calculatedTotal"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "groupType": groupType,
    "headings": List<dynamic>.from(headings!.map((x) => x.toJson())),
    "total": total,
    "calculatedTotal": calculatedTotal,
  };
}

class Heading {
  String? id;
  dynamic title;
  num? marks;
  num? calculatedMarks;

  Heading({
    this.id,
    this.title,
    this.marks,
    this.calculatedMarks,
  });

  factory Heading.fromJson(Map<String, dynamic> json) => Heading(
    id: json["_id"],
    title: json["title"],
    marks: json["marks"].toDouble(),
    calculatedMarks: json["calculatedMarks"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "marks": marks,
    "calculatedMarks": calculatedMarks,
  };
}

class ModuleData {
  String? moduleTitle;

  ModuleData({
    this.moduleTitle,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) => ModuleData(
    moduleTitle: json["moduleTitle"],
  );

  Map<String, dynamic> toJson() => {
    "moduleTitle": moduleTitle,
  };
}
