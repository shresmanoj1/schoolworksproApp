import 'dart:convert';

UpdatedpResponse updatedpResponseFromJson(String str) =>
    UpdatedpResponse.fromJson(json.decode(str));

String updatedpResponseToJson(UpdatedpResponse data) =>
    json.encode(data.toJson());

class UpdatedpResponse {
  UpdatedpResponse({
    this.success,
    this.message,
    this.filename,
    this.authUser,
  });

  bool? success;
  String? message;
  String? filename;
  AuthUser? authUser;

  factory UpdatedpResponse.fromJson(Map<String, dynamic> json) =>
      UpdatedpResponse(
        success: json["success"],
        message: json["message"],
        filename: json["filename"],
        authUser: AuthUser.fromJson(json["authUser"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "filename": filename,
        "authUser": authUser!.toJson(),
      };
}

class AuthUser {
  AuthUser({
    this.firstname,
    this.lastname,
    this.username,
    this.userImage,
    this.address,
    this.contact,
    this.city,
    this.type,
    this.batch,
    this.email,
    this.course,
    this.bio,
    this.courseSlug,
    this.institution,
  });

  String? firstname;
  String? lastname;
  String? username;
  String? userImage;
  String? address;
  String? contact;
  String? city;
  String? type;
  String? batch;
  String? email;
  String? course;
  String? bio;
  String? courseSlug;
  String? institution;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        userImage: json["userImage"],
        address: json["address"],
        contact: json["contact"],
        city: json["city"],
        type: json["type"],
        batch: json["batch"],
        email: json["email"],
        course: json["course"],
        bio: json["bio"],
        courseSlug: json["courseSlug"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "userImage": userImage,
        "address": address,
        "contact": contact,
        "city": city,
        "type": type,
        "batch": batch,
        "email": email,
        "course": course,
        "bio": bio,
        "courseSlug": courseSlug,
        "institution": institution,
      };
}
