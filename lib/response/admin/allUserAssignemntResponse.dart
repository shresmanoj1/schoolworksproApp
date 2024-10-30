// To parse this JSON data, do
//
//     final allUserAssignment = allUserAssignmentFromJson(jsonString);

import 'dart:convert';

AllUserAssignment allUserAssignmentFromJson(String str) => AllUserAssignment.fromJson(json.decode(str));

String allUserAssignmentToJson(AllUserAssignment data) => json.encode(data.toJson());

class AllUserAssignment {
  bool? success;
  List<AllAssignment>? allAssignments;

  AllUserAssignment({
    this.success,
    this.allAssignments,
  });

  factory AllUserAssignment.fromJson(Map<String, dynamic> json) => AllUserAssignment(
    success: json["success"],
    allAssignments: List<AllAssignment>.from(json["allAssignments"].map((x) => AllAssignment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allAssignments": List<dynamic>.from(allAssignments!.map((x) => x.toJson())),
  };
}

class AllAssignment {
  String? id;
  List<String>? batch;
  bool? plagarismEnabled;
  List<dynamic>? resit;
  DateTime? startDate;
  DateTime? dueDate;
  String? assignmentTitle;
  String? moduleSlug;
  String? filename;
  String? uploadedBy;
  String? institution;
  String? folderToUpload;
  DateTime? createdAt;
  DateTime? updatedAt;
  ModuleData? moduleData;
  dynamic submission;

  AllAssignment({
    this.id,
    this.batch,
    this.plagarismEnabled,
    this.resit,
    this.startDate,
    this.dueDate,
    this.assignmentTitle,
    this.moduleSlug,
    this.filename,
    this.uploadedBy,
    this.institution,
    this.folderToUpload,
    this.createdAt,
    this.updatedAt,
    this.moduleData,
    this.submission
  });

  factory AllAssignment.fromJson(Map<String, dynamic> json) => AllAssignment(
    id: json["_id"],
    batch: List<String>.from(json["batch"].map((x) => x)),
    plagarismEnabled: json["plagarismEnabled"],
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    startDate: DateTime.parse(json["startDate"]),
    dueDate: DateTime.parse(json["dueDate"]),
    assignmentTitle: json["assignmentTitle"],
    moduleSlug: json["moduleSlug"],
    filename: json["filename"],
    uploadedBy: json["uploadedBy"],
    institution: json["institution"],
    folderToUpload: json["folderToUpload"],
    submission: json["submission"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    moduleData: ModuleData.fromJson(json["moduleData"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "plagarismEnabled": plagarismEnabled,
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "startDate": startDate?.toIso8601String(),
    "dueDate": dueDate?.toIso8601String(),
    "assignmentTitle": assignmentTitle,
    "moduleSlug": moduleSlug,
    "filename": filename,
    "uploadedBy": uploadedBy,
    "institution": institution,
    "submission": submission,
    "folderToUpload": folderToUpload,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "moduleData": moduleData?.toJson(),
  };
}

class ModuleData {
  String? moduleTitle;
  String? alias;
  String? moduleSlug;

  ModuleData({
    this.moduleTitle,
    this.alias,
    this.moduleSlug,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) => ModuleData(
    moduleTitle: json["moduleTitle"],
    alias: json["alias"],
    moduleSlug: json["moduleSlug"],
  );

  Map<String, dynamic> toJson() => {
    "moduleTitle": moduleTitle,
    "alias": alias,
    "moduleSlug": moduleSlug,
  };
}
