import 'dart:convert';

Mylearningresponse mylearningresponseFromJson(String str) =>
    Mylearningresponse.fromJson(json.decode(str));

String mylearningresponseToJson(Mylearningresponse data) =>
    json.encode(data.toJson());

class Mylearningresponse {
  Mylearningresponse({
    this.success,
    this.modules,
    this.message,
  });

  String ? message;
  bool? success;
  List<Module>? modules;

  factory Mylearningresponse.fromJson(Map<String, dynamic> json) =>
      Mylearningresponse(
        success: json["success"],
        message: json["message"],
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
      };
}

class Module {
  Module({
    this.learnType,
    this.tags,
    this.currentBatch,
    this.accessTo,
    this.blockedUsers,
    this.usersWithAccess,
    this.isExtra,
    this.id,
    this.moduleTitle,
    this.moduleDesc,
    this.duration,
    this.weeklyStudy,
    this.year,
    this.benefits,
    this.moduleLeader,
    this.embeddedUrl,
    this.imageUrl,
    this.moduleSlug,
    this.progress,
  });

  String? learnType;
  List<String>? tags;
  List<String>? currentBatch;
  List<String>? accessTo;
  List<String>? blockedUsers;
  List<String>? usersWithAccess;
  bool? isExtra;
  String? id;
  String? moduleTitle;
  String? moduleDesc;
  dynamic duration;
  dynamic weeklyStudy;
  String? year;
  String? benefits;
  String? moduleLeader;
  String? embeddedUrl;
  String? imageUrl;
  String? moduleSlug;
  dynamic progress;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        learnType: json["learn_type"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        currentBatch: List<String>.from(json["currentBatch"].map((x) => x)),
        accessTo: List<String>.from(json["accessTo"].map((x) => x)),
        blockedUsers: List<String>.from(json["blockedUsers"].map((x) => x)),
        usersWithAccess:
            List<String>.from(json["usersWithAccess"].map((x) => x)),
        isExtra: json["isExtra"],
        id: json["_id"],
        moduleTitle: json["moduleTitle"],
        moduleDesc: json["moduleDesc"],
        duration: json["duration"],
        weeklyStudy: json["weekly_study"],
        year: json["year"],
        benefits: json["benefits"],
        moduleLeader: json["moduleLeader"],
        embeddedUrl: json["embeddedUrl"],
        imageUrl: json["imageUrl"],
        moduleSlug: json["moduleSlug"],
        progress: json["progress"],
      );

  Map<String, dynamic> toJson() => {
        "learn_type": learnType,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "currentBatch": List<dynamic>.from(currentBatch!.map((x) => x)),
        "accessTo": List<dynamic>.from(accessTo!.map((x) => x)),
        "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
        "usersWithAccess": List<dynamic>.from(usersWithAccess!.map((x) => x)),
        "isExtra": isExtra,
        "_id": id,
        "moduleTitle": moduleTitle,
        "moduleDesc": moduleDesc,
        "duration": duration,
        "weekly_study": weeklyStudy,
        "year": year,
        "benefits": benefits,
        "moduleLeader": moduleLeader,
        "embeddedUrl": embeddedUrl,
        "imageUrl": imageUrl,
        "moduleSlug": moduleSlug,
        "progress": progress,
      };
}
