// To parse this JSON data, do
//
//     final institutionDetailForIdResponse = institutionDetailForIdResponseFromJson(jsonString);

import 'dart:convert';

InstitutionDetailForIdResponse institutionDetailForIdResponseFromJson(
        String str) =>
    InstitutionDetailForIdResponse.fromJson(json.decode(str));

String institutionDetailForIdResponseToJson(
        InstitutionDetailForIdResponse data) =>
    json.encode(data.toJson());

class InstitutionDetailForIdResponse {
  InstitutionDetailForIdResponse({
    this.success,
    this.institution,
  });

  bool? success;
  dynamic institution;

  factory InstitutionDetailForIdResponse.fromJson(Map<dynamic, dynamic> json) =>
      InstitutionDetailForIdResponse(
        success: json["success"],
        institution: json["institution"],
      );

  Map<dynamic, dynamic> toJson() => {
        "success": success,
        "institution": institution,
      };
}
//
// class Institution {
//   Institution({
//     this.footerLogo,
//     this.image,
//     this.type,
//     this.isResidential,
//     this.pricePerUser,
//     this.branches,
//     this.package,
//     this.id,
//     this.name,
//     this.alias,
//     this.pageHeader,
//     this.pageCaption,
//     this.ctaCaption,
//     this.address,
//     this.contact,
//     this.email,
//     this.moodleLink,
//     this.facebook,
//     this.linkedin,
//     this.instagram,
//     this.website,
//     this.institutionType,
//     this.isAdmissionOpen,
//   });
//
//   String footerLogo;
//   String image;
//   String type;
//   bool isResidential;
//   String pricePerUser;
//   List<dynamic> branches;
//   String package;
//   String id;
//   String name;
//   String alias;
//   String pageHeader;
//   String pageCaption;
//   String ctaCaption;
//   String address;
//   String contact;
//   String email;
//   String moodleLink;
//   String facebook;
//   String linkedin;
//   String instagram;
//   String website;
//   String institutionType;
//   bool isAdmissionOpen;
//
//   factory Institution.fromJson(Map<String, dynamic> json) => Institution(
//     footerLogo: json["footerLogo"],
//     image: json["image"],
//     type: json["type"],
//     isResidential: json["isResidential"],
//     pricePerUser: json["pricePerUser"],
//     branches: List<dynamic>.from(json["branches"].map((x) => x)),
//     package: json["package"],
//     id: json["_id"],
//     name: json["name"],
//     alias: json["alias"],
//     pageHeader: json["pageHeader"],
//     pageCaption: json["pageCaption"],
//     ctaCaption: json["ctaCaption"],
//     address: json["address"],
//     contact: json["contact"],
//     email: json["email"],
//     moodleLink: json["moodleLink"],
//     facebook: json["facebook"],
//     linkedin: json["linkedin"],
//     instagram: json["instagram"],
//     website: json["website"],
//     institutionType: json["institutionType"],
//     isAdmissionOpen: json["isAdmissionOpen"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "footerLogo": footerLogo,
//     "image": image,
//     "type": type,
//     "isResidential": isResidential,
//     "pricePerUser": pricePerUser,
//     "branches": List<dynamic>.from(branches.map((x) => x)),
//     "package": package,
//     "_id": id,
//     "name": name,
//     "alias": alias,
//     "pageHeader": pageHeader,
//     "pageCaption": pageCaption,
//     "ctaCaption": ctaCaption,
//     "address": address,
//     "contact": contact,
//     "email": email,
//     "moodleLink": moodleLink,
//     "facebook": facebook,
//     "linkedin": linkedin,
//     "instagram": instagram,
//     "website": website,
//     "institutionType": institutionType,
//     "isAdmissionOpen": isAdmissionOpen,
//   };
// }
