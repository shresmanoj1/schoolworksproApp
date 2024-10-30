// To parse this JSON data, do
//
//     final moduleGroupCollaboration = moduleGroupCollaborationFromJson(jsonString);

import 'dart:convert';

ModuleGroupCollaboration moduleGroupCollaborationFromJson(String str) => ModuleGroupCollaboration.fromJson(json.decode(str));

String moduleGroupCollaborationToJson(ModuleGroupCollaboration data) => json.encode(data.toJson());

class ModuleGroupCollaboration {
  bool? success;
  List<ModuleElement>? modules;

  ModuleGroupCollaboration({
    this.success,
    this.modules,
  });

  factory ModuleGroupCollaboration.fromJson(Map<String, dynamic> json) => ModuleGroupCollaboration(
    success: json["success"],
    modules: json["modules"] == null ? null :  List<ModuleElement>.from(json["modules"].map((x) => ModuleElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "modules": modules == null ? null : List<dynamic>.from(modules!.map((x) => x.toJson())),
  };
}

class ModuleElement {
  String? id;
  List<User>? users;
  bool? isApproved;
  String? groupName;
  // List<String>? hasEdit;
  // List<String>? moduleSubGroup;
  // ModuleModule? module;
  String? batch;
  String? progress;
  // String? institution;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  ModuleElement({
    this.id,
    this.users,
    this.isApproved,
    this.groupName,
    this.progress,
    // this.moduleSubGroup,
    // this.module,
    this.batch,
    // this.createdBy,
    // this.institution,
    // this.createdAt,
    // this.updatedAt,
    this.v,
  });

  int? v;

  factory ModuleElement.fromJson(Map<String, dynamic> json) => ModuleElement(
    id: json["_id"],
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    isApproved: json["isApproved"],
    groupName: json["groupName"],
    // hasEdit: List<String>.from(json["hasEdit"].map((x) => x)),
    // moduleSubGroup: json["moduleSubGroup"] == null ? [] : List<String>.from(json["moduleSubGroup"].map((x) => x)),
    // module: ModuleModule.fromJson(json["module"]),
    batch: json["batch"],
    progress: json["progress"],
    // institution: json["institution"],
    // createdAt: DateTime.parse(json["createdAt"]),
    // updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
    "isApproved": isApproved,
    "groupName": groupName,
    // "hasEdit": List<dynamic>.from(hasEdit!.map((x) => x)),
    // "moduleSubGroup": List<dynamic>.from(moduleSubGroup!.map((x) => x)),
    // "module": module?.toJson(),
    "batch": batch,
    "progress": progress,
    // "institution": institution,
    // "createdAt": createdAt?.toIso8601String(),
    // "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? userImage;
  String? type;
  // String? email;
  // List<dynamic>? roles;
  // bool? isSuspended;
  // bool? dues;
  // List<dynamic>? blockedModules;
  // List<String>? modulesWithAccess;
  // bool? isPublic;
  // bool? isGuest;
  // bool? isSupportStaff;
  // String? maritalStatus;
  // String? panNumber;
  // String? pfNumber;
  // String? citNumber;
  // String? bankAccount;
  // List<dynamic>? relatedCourses;
  // String? contact;
  // String? address;
  // String? parentsContact;
  // String? course;
  // String? batch;
  // String? courseSlug;
  // String? institution;
  // String? username;
  // String? hash;
  // List<Document>? documents;
  // List<dynamic>? projectLinks;
  // List<dynamic>? salary;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // int? v;
  // bool? accessforAdmission;
  // String? parent;
  // dynamic coventryId;
  // dynamic registrationId;
  // String? city;
  // String? dob;
  // String? gender;
  // String? parentFirstName;
  // String? parentLastName;
  // String? parentsEmail;
  // String? province;
  // String? relationship;
  // String? secondaryEmail;
  // String? street;
  // String? temporaryAddress;
  // bool? disableLogin;
  // String? background;
  // String? bio;
  // String? college;
  // String? school;
  // bool? accessToExportData;
  // int? updatedTimes;
  // PastStudies? pastStudies;
  // List<dynamic>? department;
  // String? salt;
  // String? drole;
  // String? droleName;

  User({
    this.id,
    this.type,
    this.firstname,
    this.lastname,
    this.userImage,
    // this.roles,
    // this.isSuspended,
    // this.dues,
    // this.blockedModules,
    // this.modulesWithAccess,
    // this.isPublic,
    // this.isGuest,
    // this.isSupportStaff,
    // this.maritalStatus,
    // this.panNumber,
    // this.pfNumber,
    // this.citNumber,
    // this.bankAccount,
    // this.relatedCourses,
    // this.email,
    // this.contact,
    // this.address,
    // this.parentsContact,
    // this.course,
    // this.batch,
    // this.courseSlug,
    // this.institution,
    // this.username,
    // this.hash,
    // this.documents,
    // this.projectLinks,
    // this.salary,
    // this.createdAt,
    // this.updatedAt,
    // this.v,
    // this.accessforAdmission,
    // this.parent,
    // this.coventryId,
    // this.registrationId,
    // this.city,
    // this.dob,
    // this.gender,
    // this.parentFirstName,
    // this.parentLastName,
    // this.parentsEmail,
    // this.province,
    // this.relationship,
    // this.secondaryEmail,
    // this.street,
    // this.temporaryAddress,
    // this.disableLogin,
    // this.background,
    // this.bio,
    // this.college,
    // this.school,
    // this.accessToExportData,
    // this.updatedTimes,
    // this.pastStudies,
    // this.department,
    // this.salt,
    // this.drole,
    // this.droleName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    type: json["type"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    userImage: json["userImage"],
    // roles: List<dynamic>.from(json["roles"].map((x) => x)),
    // isSuspended: json["isSuspended"],
    // dues: json["dues"],
    // blockedModules: List<dynamic>.from(json["blockedModules"].map((x) => x)),
    // modulesWithAccess: List<String>.from(json["modulesWithAccess"].map((x) => x)),
    // isPublic: json["isPublic"],
    // isGuest: json["isGuest"],
    // isSupportStaff: json["isSupportStaff"],
    // maritalStatus: json["maritalStatus"],
    // panNumber: json["pan_number"],
    // pfNumber: json["pf_number"],
    // citNumber: json["cit_number"],
    // bankAccount: json["bank_account"],
    // relatedCourses: List<dynamic>.from(json["relatedCourses"].map((x) => x)),
    // email: json["email"],
    // contact: json["contact"],
    // address: json["address"],
    // parentsContact: json["parentsContact"],
    // course: json["course"],
    // batch: json["batch"],
    // courseSlug: json["courseSlug"],
    // institution: json["institution"],
    // username: json["username"],
    // hash: json["hash"],
    // documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
    // projectLinks: List<dynamic>.from(json["projectLinks"].map((x) => x)),
    // salary: List<dynamic>.from(json["salary"].map((x) => x)),
    // createdAt: DateTime.parse(json["createdAt"]),
    // updatedAt: DateTime.parse(json["updatedAt"]),
    // v: json["__v"],
    // accessforAdmission: json["accessforAdmission"],
    // parent: json["parent"],
    //
    // coventryId: json["coventryID"],
    // registrationId: json["registrationID"],
    // city: json["city"],
    // dob: json["dob"],
    // gender: json["gender"],
    // parentFirstName: json["parentFirstName"],
    // parentLastName: json["parentLastName"],
    // parentsEmail: json["parentsEmail"],
    // province: json["province"],
    // relationship: json["relationship"],
    // secondaryEmail: json["secondaryEmail"],
    // street: json["street"],
    // temporaryAddress: json["temporaryAddress"],
    // disableLogin: json["disableLogin"],
    // background: json["background"],
    // bio: json["bio"],
    // college: json["college"],
    // school: json["school"],
    // accessToExportData: json["accessToExportData"],
    // updatedTimes: json["updatedTimes"],
    // pastStudies: PastStudies.fromJson(json["pastStudies"]),
    // department: List<dynamic>.from(json["department"].map((x) => x)),
    // salt: json["salt"],
    // drole: json["drole"],
    // droleName: json["droleName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "firstname": firstname,
    "lastname": lastname,
    "userImage": userImage,
    // "roles": List<dynamic>.from(roles!.map((x) => x)),
    // "isSuspended": isSuspended,
    // "dues": dues,
    // "blockedModules": List<dynamic>.from(blockedModules!.map((x) => x)),
    // "modulesWithAccess": List<dynamic>.from(modulesWithAccess!.map((x) => x)),
    // "isPublic": isPublic,
    // "isGuest": isGuest,
    // "isSupportStaff": isSupportStaff,
    // "maritalStatus": maritalStatus,
    // "pan_number": panNumber,
    // "pf_number": pfNumber,
    // "cit_number": citNumber,
    // "bank_account": bankAccount,
    // "relatedCourses": List<dynamic>.from(relatedCourses!.map((x) => x)),
    // "email": email,
    // "contact": contact,
    // "address": address,
    // "parentsContact": parentsContact,
    // "course": course,
    // "batch": batch,
    // "courseSlug": courseSlug,
    // "institution": institution,
    // "username": username,
    // "hash": hash,
    // "documents": List<dynamic>.from(documents!.map((x) => x.toJson())),
    // "projectLinks": List<dynamic>.from(projectLinks!.map((x) => x)),
    // "salary": List<dynamic>.from(salary!.map((x) => x)),
    // "createdAt": createdAt?.toIso8601String(),
    // "updatedAt": updatedAt?.toIso8601String(),
    // "__v": v,
    // "accessforAdmission": accessforAdmission,
    // "parent": parent,
    // "coventryID": coventryId,
    // "registrationID": registrationId,
    // "city": city,
    // "dob": dob,
    // "gender": gender,
    // "parentFirstName": parentFirstName,
    // "parentLastName": parentLastName,
    // "parentsEmail": parentsEmail,
    // "province": province,
    // "relationship": relationship,
    // "secondaryEmail": secondaryEmail,
    // "street": street,
    // "temporaryAddress": temporaryAddress,
    // "disableLogin": disableLogin,
    // "background": background,
    // "bio": bio,
    // "college": college,
    // "school": school,
    // "accessToExportData": accessToExportData,
    // "updatedTimes": updatedTimes,
    // "pastStudies": pastStudies?.toJson(),
    // "department": List<dynamic>.from(department!.map((x) => x)),
    // "salt": salt,
    // "drole": drole,
    // "droleName": droleName,
  };
}

// class Document {
//   String? id;
//   String? docType;
//   String? docName;
//
//   Document({
//     this.id,
//     this.docType,
//     this.docName,
//   });
//
//   factory Document.fromJson(Map<String, dynamic> json) => Document(
//     id: json["_id"],
//     docType: json["docType"],
//     docName: json["docName"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "docType": docType,
//     "docName": docName,
//   };
// }

// class PastStudies {
//   List<dynamic>? batches;
//   List<String>? courses;
//
//   PastStudies({
//     this.batches,
//     this.courses,
//   });
//
//   factory PastStudies.fromJson(Map<String, dynamic> json) => PastStudies(
//     batches: List<dynamic>.from(json["batches"].map((x) => x)),
//     courses: List<String>.from(json["courses"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "batches": List<dynamic>.from(batches!.map((x) => x)),
//     "courses": List<dynamic>.from(courses!.map((x) => x)),
//   };
// }
