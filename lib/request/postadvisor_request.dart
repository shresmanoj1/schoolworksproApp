// To parse this JSON data, do
//
//     final postAdvisorRequest = postAdvisorRequestFromJson(jsonString);

import 'dart:convert';

PostAdvisorRequest postAdvisorRequestFromJson(String str) => PostAdvisorRequest.fromJson(json.decode(str));

String postAdvisorRequestToJson(PostAdvisorRequest data) => json.encode(data.toJson());

class PostAdvisorRequest {
  PostAdvisorRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.contact,
    this.address,
    this.dob,
    this.gender,
    this.city,
    this.province,
    this.school,
    this.college,
    this.background,
    this.faculty,
    this.percentage,
    this.course,
    this.source,
    this.communication,
  });

  String ? firstName;
  String ? lastName;
  String ? email;
  String ? contact;
  String ? address;
  DateTime ? dob;
  String ? gender;
  String ? city;
  String ? province;
  String ? school;
  String ? college;
  String ? background;
  String ? faculty;
  String ? percentage;
  String ? course;
  String ? source;
  String ? communication;

  factory PostAdvisorRequest.fromJson(Map<String, dynamic> json) => PostAdvisorRequest(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    contact: json["contact"],
    address: json["address"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    city: json["city"],
    province: json["province"],
    school: json["school"],
    college: json["college"],
    background: json["background"],
    faculty: json["faculty"],
    percentage: json["percentage"],
    course: json["course"],
    source: json["source"],
    communication: json["communication"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "contact": contact == null ? null : contact,
    "address": address == null ? null : address,
    "dob": dob == null ? null :dob,
    "gender": gender == null ? null : gender,
    "city": city == null ? null : city,
    "province": province == null ? null : province,
    "school": school == null ? null :school,
    "college": college == null ? null : college,
    "background": background == null ? null : background,
    "faculty": faculty == null ? null : faculty,
    "percentage": percentage == null ? null : percentage,
    "course": course == null ? null : course,
    "source": source == null ? null : source,
    "communication": communication == null ? null : communication,
  };
}
