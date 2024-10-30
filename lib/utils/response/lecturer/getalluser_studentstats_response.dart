// To parse this JSON data, do
//
//     final getAllUserStudentStatsResponse = getAllUserStudentStatsResponseFromJson(jsonString);

import 'dart:convert';

GetAllUserStudentStatsResponse getAllUserStudentStatsResponseFromJson(
        String str) =>
    GetAllUserStudentStatsResponse.fromJson(json.decode(str));

String getAllUserStudentStatsResponseToJson(
        GetAllUserStudentStatsResponse data) =>
    json.encode(data.toJson());

class GetAllUserStudentStatsResponse {
  GetAllUserStudentStatsResponse({
    this.success,
    this.users,
  });

  bool? success;
  List<dynamic>? users;

  factory GetAllUserStudentStatsResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUserStudentStatsResponse(
        success: json["success"],
        users: List<dynamic>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}
//
// class User {
//   User({
//     this.type,
//     this.roles,
//     this.isSuspended,
//     this.blockedModules,
//     this.modulesWithAccess,
//     this.isPublic,
//     this.isGuest,
//     this.id,
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.contact,
//     this.address,
//     this.parentsContact,
//     this.course,
//     this.batch,
//     this.courseSlug,
//     this.institution,
//     this.documents,
//     this.projectLinks,
//     this.salary,
//     this.createdAt,
//     this.hash,
//     this.username,
//     this.coventryId,
//     this.userImage,
//     this.parent,
//     this.gender,
//     this.isUpdated,
//     this.background,
//     this.bio,
//     this.city,
//     this.college,
//     this.province,
//     this.school,
//     this.phone2,
//   });
//
//   Type type;
//   List<dynamic> roles;
//   bool isSuspended;
//   List<String> blockedModules;
//   List<String> modulesWithAccess;
//   bool isPublic;
//   bool isGuest;
//   String id;
//   String firstname;
//   String lastname;
//   String email;
//   String contact;
//   String address;
//   String parentsContact;
//   Course course;
//   String batch;
//   CourseSlug courseSlug;
//   Institution institution;
//   List<Document> documents;
//   List<dynamic> projectLinks;
//   List<dynamic> salary;
//   DateTime createdAt;
//   String hash;
//   String username;
//   String coventryId;
//   String userImage;
//   Parent parent;
//   Gender gender;
//   bool isUpdated;
//   Background background;
//   String bio;
//   String city;
//   String college;
//   String province;
//   String school;
//   String phone2;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     type: typeValues.map[json["type"]],
//     roles: List<dynamic>.from(json["roles"].map((x) => x)),
//     isSuspended: json["isSuspended"],
//     blockedModules: List<String>.from(json["blockedModules"].map((x) => x)),
//     modulesWithAccess: List<String>.from(json["modulesWithAccess"].map((x) => x)),
//     isPublic: json["isPublic"],
//     isGuest: json["isGuest"],
//     id: json["_id"],
//     firstname: json["firstname"],
//     lastname: json["lastname"],
//     email: json["email"],
//     contact: json["contact"] == null ? null : json["contact"],
//     address: json["address"] == null ? null : json["address"],
//     parentsContact: json["parentsContact"] == null ? null : json["parentsContact"],
//     course: courseValues.map[json["course"]],
//     batch: json["batch"] == null ? null : json["batch"],
//     courseSlug: courseSlugValues.map[json["courseSlug"]],
//     institution: institutionValues.map[json["institution"]],
//     documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
//     projectLinks: List<dynamic>.from(json["projectLinks"].map((x) => x)),
//     salary: List<dynamic>.from(json["salary"].map((x) => x)),
//     createdAt: DateTime.parse(json["createdAt"]),
//     hash: json["hash"],
//     username: json["username"],
//     coventryId: json["coventryID"] == null ? null : json["coventryID"],
//     userImage: json["userImage"] == null ? null : json["userImage"],
//     parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
//     gender: json["gender"] == null ? null : genderValues.map[json["gender"]],
//     isUpdated: json["isUpdated"] == null ? null : json["isUpdated"],
//     background: json["background"] == null ? null : backgroundValues.map[json["background"]],
//     bio: json["bio"] == null ? null : json["bio"],
//     city: json["city"] == null ? null : json["city"],
//     college: json["college"] == null ? null : json["college"],
//     province: json["province"] == null ? null : json["province"],
//     school: json["school"] == null ? null : json["school"],
//     phone2: json["phone2"] == null ? null : json["phone2"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": typeValues.reverse[type],
//     "roles": List<dynamic>.from(roles.map((x) => x)),
//     "isSuspended": isSuspended,
//     "blockedModules": List<dynamic>.from(blockedModules.map((x) => x)),
//     "modulesWithAccess": List<dynamic>.from(modulesWithAccess.map((x) => x)),
//     "isPublic": isPublic,
//     "isGuest": isGuest,
//     "_id": id,
//     "firstname": firstname,
//     "lastname": lastname,
//     "email": email,
//     "contact": contact == null ? null : contact,
//     "address": address == null ? null : address,
//     "parentsContact": parentsContact == null ? null : parentsContact,
//     "course": courseValues.reverse[course],
//     "batch": batch == null ? null : batch,
//     "courseSlug": courseSlugValues.reverse[courseSlug],
//     "institution": institutionValues.reverse[institution],
//     "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
//     "projectLinks": List<dynamic>.from(projectLinks.map((x) => x)),
//     "salary": List<dynamic>.from(salary.map((x) => x)),
//     "createdAt": createdAt.toIso8601String(),
//     "hash": hash,
//     "username": username,
//     "coventryID": coventryId == null ? null : coventryId,
//     "userImage": userImage == null ? null : userImage,
//     "parent": parent == null ? null : parent.toJson(),
//     "gender": gender == null ? null : genderValues.reverse[gender],
//     "isUpdated": isUpdated == null ? null : isUpdated,
//     "background": background == null ? null : backgroundValues.reverse[background],
//     "bio": bio == null ? null : bio,
//     "city": city == null ? null : city,
//     "college": college == null ? null : college,
//     "province": province == null ? null : province,
//     "school": school == null ? null : school,
//     "phone2": phone2 == null ? null : phone2,
//   };
// }
//
// enum Background { MANAGEMENT, SCIENCE, OTHERS, BACKGROUND_SCIENCE, EMPTY, HUMANAITIES, TEST, MANAGEMENT_TEST8, BACKGROUND_MANAGEMENT, BACKGROUND }
//
// final backgroundValues = EnumValues({
//   ".": Background.BACKGROUND,
//   "Management": Background.BACKGROUND_MANAGEMENT,
//   "science": Background.BACKGROUND_SCIENCE,
//   "": Background.EMPTY,
//   "humanaities": Background.HUMANAITIES,
//   "management": Background.MANAGEMENT,
//   "management test8": Background.MANAGEMENT_TEST8,
//   "others": Background.OTHERS,
//   "Science": Background.SCIENCE,
//   "test": Background.TEST
// });
//
// enum Course { B_SC_HONS_COMPUTING, B_SC_HONS_ETHICAL_HACKING_AND_CYBERSECURITY }
//
// final courseValues = EnumValues({
//   "BSc (Hons) Computing": Course.B_SC_HONS_COMPUTING,
//   "BSc (Hons) Ethical Hacking and Cybersecurity": Course.B_SC_HONS_ETHICAL_HACKING_AND_CYBERSECURITY
// });
//
// enum CourseSlug { BSC_HONS_COMPUTING, BSC_HONS_ETHICAL_HACKING_AND_CYBERSECURITY }
//
// final courseSlugValues = EnumValues({
//   "bsc-hons-computing": CourseSlug.BSC_HONS_COMPUTING,
//   "bsc-hons-ethical-hacking-and-cybersecurity": CourseSlug.BSC_HONS_ETHICAL_HACKING_AND_CYBERSECURITY
// });
//
// class Document {
//   Document({
//     this.id,
//     this.docType,
//     this.docName,
//   });
//
//   String id;
//   DocType docType;
//   String docName;
//
//   factory Document.fromJson(Map<String, dynamic> json) => Document(
//     id: json["_id"],
//     docType: docTypeValues.map[json["docType"]],
//     docName: json["docName"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "docType": docTypeValues.reverse[docType],
//     "docName": docName,
//   };
// }
//
// enum DocType { CITIZENSHIP, SEE_CERTIFICATE, SCHOOL_CHARACTER_CERTIFICATE, HSEB_TRANSCRIPT, HSEB_CHARACTER_CERTIFICATE, SEE_SLC_MARKSHEET }
//
// final docTypeValues = EnumValues({
//   "Citizenship": DocType.CITIZENSHIP,
//   "HSEB Character Certificate": DocType.HSEB_CHARACTER_CERTIFICATE,
//   "HSEB Transcript": DocType.HSEB_TRANSCRIPT,
//   "School Character Certificate": DocType.SCHOOL_CHARACTER_CERTIFICATE,
//   "SEE Certificate": DocType.SEE_CERTIFICATE,
//   "SEE/SLC Marksheet": DocType.SEE_SLC_MARKSHEET
// });
//
// enum Gender { MALE, FEMALE, EMPTY, GENDER_MALE, PURPLE_MALE, GENDER_FEMALE, MALE_TEST2, OTHERS }
//
// final genderValues = EnumValues({
//   "": Gender.EMPTY,
//   "Female": Gender.FEMALE,
//   "female ": Gender.GENDER_FEMALE,
//   "MALE": Gender.GENDER_MALE,
//   "Male": Gender.MALE,
//   "Male test2": Gender.MALE_TEST2,
//   "Others": Gender.OTHERS,
//   "male": Gender.PURPLE_MALE
// });
//
// enum Institution { SOFTWARICA }
//
// final institutionValues = EnumValues({
//   "softwarica": Institution.SOFTWARICA
// });
//
// class Parent {
//   Parent({
//     this.id,
//     this.username,
//   });
//
//   String id;
//   String username;
//
//   factory Parent.fromJson(Map<String, dynamic> json) => Parent(
//     id: json["_id"],
//     username: json["username"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "username": username,
//   };
// }
//
// enum Type { STUDENT }
//
// final typeValues = EnumValues({
//   "Student": Type.STUDENT
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
