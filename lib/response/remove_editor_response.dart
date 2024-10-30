// To parse this JSON data, do
//
//     final removeEditorResponse = removeEditorResponseFromJson(jsonString);

import 'dart:convert';

RemoveEditorResponse removeEditorResponseFromJson(String str) => RemoveEditorResponse.fromJson(json.decode(str));

String removeEditorResponseToJson(RemoveEditorResponse data) => json.encode(data.toJson());

class RemoveEditorResponse {
  bool? success;
  dynamic module;
  String? message;

  RemoveEditorResponse({
    this.success,
    this.module,
    this.message,
  });

  factory RemoveEditorResponse.fromJson(Map<String, dynamic> json) => RemoveEditorResponse(
    success: json["success"],
    module: json["module"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "module": module,
    "message": message,
  };
}

class RemoveEditorResponseModule {
  List<String>? users;
  bool? isApproved;
  List<String>? hasEdit;
  List<String>? moduleSubGroup;
  String? id;
  ModuleModule? module;
  String? groupName;
  String? batch;
  String? createdBy;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  RemoveEditorResponseModule({
    this.users,
    this.isApproved,
    this.hasEdit,
    this.moduleSubGroup,
    this.id,
    this.module,
    this.groupName,
    this.batch,
    this.createdBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  factory RemoveEditorResponseModule.fromJson(Map<String, dynamic> json) => RemoveEditorResponseModule(
    users: List<String>.from(json["users"].map((x) => x)),
    isApproved: json["isApproved"],
    hasEdit: List<String>.from(json["hasEdit"].map((x) => x)),
    moduleSubGroup: List<String>.from(json["moduleSubGroup"].map((x) => x)),
    id: json["_id"],
    module: ModuleModule.fromJson(json["module"]),
    groupName: json["groupName"],
    batch: json["batch"],
    createdBy: json["createdBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users!.map((x) => x)),
    "isApproved": isApproved,
    "hasEdit": List<dynamic>.from(hasEdit!.map((x) => x)),
    "moduleSubGroup": List<dynamic>.from(moduleSubGroup!.map((x) => x)),
    "_id": id,
    "module": module?.toJson(),
    "groupName": groupName,
    "batch": batch,
    "createdBy": createdBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class ModuleModule {
  String? learnType;
  List<String>? tags;
  List<String>? lessons;
  List<dynamic>? publicLessons;
  List<String>? currentBatch;
  List<String>? accessTo;
  List<dynamic>? blockedUsers;
  List<String>? usersWithAccess;
  bool? isExtra;
  List<dynamic>? branches;
  bool? isOptional;
  bool? notGraded;
  List<String>? optionalStudent;
  bool? hidden;
  bool? contribOverallAtt;
  bool? isEthicalFormRequired;
  String? id;
  String? moduleTitle;
  String? moduleDesc;
  int? duration;
  int? weeklyStudy;
  String? year;
  String? credit;
  String? benefits;
  String? moduleLeader;
  String? embeddedUrl;
  String? moduleSlug;
  String? institution;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? alias;
  List<dynamic>? headingCreditHr;

  ModuleModule({
    this.learnType,
    this.tags,
    this.lessons,
    this.publicLessons,
    this.currentBatch,
    this.accessTo,
    this.blockedUsers,
    this.usersWithAccess,
    this.isExtra,
    this.branches,
    this.isOptional,
    this.notGraded,
    this.optionalStudent,
    this.hidden,
    this.contribOverallAtt,
    this.isEthicalFormRequired,
    this.id,
    this.moduleTitle,
    this.moduleDesc,
    this.duration,
    this.weeklyStudy,
    this.year,
    this.credit,
    this.benefits,
    this.moduleLeader,
    this.embeddedUrl,
    this.moduleSlug,
    this.institution,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.alias,
    this.headingCreditHr,
  });

  factory ModuleModule.fromJson(Map<String, dynamic> json) => ModuleModule(
    learnType: json["learn_type"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    lessons: List<String>.from(json["lessons"].map((x) => x)),
    publicLessons: List<dynamic>.from(json["public_lessons"].map((x) => x)),
    currentBatch: List<String>.from(json["currentBatch"].map((x) => x)),
    accessTo: List<String>.from(json["accessTo"].map((x) => x)),
    blockedUsers: List<dynamic>.from(json["blockedUsers"].map((x) => x)),
    usersWithAccess: List<String>.from(json["usersWithAccess"].map((x) => x)),
    isExtra: json["isExtra"],
    branches: List<dynamic>.from(json["branches"].map((x) => x)),
    isOptional: json["isOptional"],
    notGraded: json["notGraded"],
    optionalStudent: List<String>.from(json["optionalStudent"].map((x) => x)),
    hidden: json["hidden"],
    contribOverallAtt: json["contribOverallAtt"],
    isEthicalFormRequired: json["isEthicalFormRequired"],
    id: json["_id"],
    moduleTitle: json["moduleTitle"],
    moduleDesc: json["moduleDesc"],
    duration: json["duration"],
    weeklyStudy: json["weekly_study"],
    year: json["year"],
    credit: json["credit"],
    benefits: json["benefits"],
    moduleLeader: json["moduleLeader"],
    embeddedUrl: json["embeddedUrl"],
    moduleSlug: json["moduleSlug"],
    institution: json["institution"],
    imageUrl: json["imageUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    alias: json["alias"],
    headingCreditHr: List<dynamic>.from(json["headingCreditHr"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "learn_type": learnType,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "lessons": List<dynamic>.from(lessons!.map((x) => x)),
    "public_lessons": List<dynamic>.from(publicLessons!.map((x) => x)),
    "currentBatch": List<dynamic>.from(currentBatch!.map((x) => x)),
    "accessTo": List<dynamic>.from(accessTo!.map((x) => x)),
    "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
    "usersWithAccess": List<dynamic>.from(usersWithAccess!.map((x) => x)),
    "isExtra": isExtra,
    "branches": List<dynamic>.from(branches!.map((x) => x)),
    "isOptional": isOptional,
    "notGraded": notGraded,
    "optionalStudent": List<dynamic>.from(optionalStudent!.map((x) => x)),
    "hidden": hidden,
    "contribOverallAtt": contribOverallAtt,
    "isEthicalFormRequired": isEthicalFormRequired,
    "_id": id,
    "moduleTitle": moduleTitle,
    "moduleDesc": moduleDesc,
    "duration": duration,
    "weekly_study": weeklyStudy,
    "year": year,
    "credit": credit,
    "benefits": benefits,
    "moduleLeader": moduleLeader,
    "embeddedUrl": embeddedUrl,
    "moduleSlug": moduleSlug,
    "institution": institution,
    "imageUrl": imageUrl,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "alias": alias,
    "headingCreditHr": List<dynamic>.from(headingCreditHr!.map((x) => x)),
  };
}
