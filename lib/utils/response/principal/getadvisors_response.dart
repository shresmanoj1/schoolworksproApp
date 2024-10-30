// To parse this JSON data, do
//
//     final getAdvisorResponse = getAdvisorResponseFromJson(jsonString);

import 'dart:convert';

GetAdvisorResponse getAdvisorResponseFromJson(String str) =>
    GetAdvisorResponse.fromJson(json.decode(str));

String getAdvisorResponseToJson(GetAdvisorResponse data) =>
    json.encode(data.toJson());

class GetAdvisorResponse {
  GetAdvisorResponse({
    this.success,
    this.advisor,
  });

  bool? success;
  List<Advisor>? advisor;

  factory GetAdvisorResponse.fromJson(Map<String, dynamic> json) =>
      GetAdvisorResponse(
        success: json["success"],
        advisor:
            List<Advisor>.from(json["advisor"].map((x) => Advisor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "advisor": List<dynamic>.from(advisor!.map((x) => x.toJson())),
      };
}

class Advisor {
  Advisor({
    this.id,
    this.course,
    this.admission,
    this.paid,
    this.discount,
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
    this.source,
    this.communication,
    this.institution,
    this.feedbacks,
    this.score,
    this.followedUpBy,
    this.referral,
  });

  String? id;
  String? course;
  String? admission;
  bool? paid;
  int? discount;
  String? firstName;
  String? lastName;
  String? email;
  String? contact;
  String? address;
  String? dob;
  String? gender;
  String? city;
  String? province;
  String? school;
  String? college;
  String? background;
  String? faculty;
  String? percentage;
  String? source;
  String? communication;
  String? institution;
  String? feedbacks;
  Score? score;
  String? followedUpBy;
  String? referral;

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
        id: json["_id"] == null ? null : json['_id'],
        course: json["course"] == null ? null : json["course"],
        admission: json["admission"] == null ? null : json["admission"],
        paid: json["paid"] == null ? null : json["paid"],
        discount: json["discount"] == null ? null : json["discount"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
        contact: json["contact"] == null ? null : json["contact"],
        address: json["address"] == null ? null : json["address"],
        // dob: DateTime.parse(json["dob"]) == null
        //     ? null
        //     : DateTime.parse(json["dob"]),
        dob: json["dob"] == null ? null : json["dob"],
        gender: json["gender"] == null ? null : json["gender"],
        city: json["city"] == null ? null : json["city"],
        province: json["province"] == null ? null : json["province"],
        school: json["school"] == null ? null : json["school"],
        college: json["college"] == null ? null : json["college"],
        background: json["background"] == null ? null : json["background"],
        faculty: json["faculty"] == null ? null : json["faculty"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        source: json["source"] == null ? null : jsonEncode("source"),
        communication:
            json["communication"] == null ? null : json["communication"],
        institution: json["institution"] == null ? null : json['institution'],
        feedbacks: json["feedbacks"] == null ? null : json["feedbacks"],
        followedUpBy:
            json["followedUpBy"] == null ? null : json["followedUpBy"],
        score: json["score"] == null ? null : Score.fromJson(json["score"]),
        referral: json["referral"] == null ? null : json["referral"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id ?? null,
        "course": course ?? null,
        "admission": admission ?? null,
        "paid": paid ?? null,
        "discount": discount ?? null,
        "firstName": firstName ?? null,
        "lastName": lastName ?? null,
        "email": email ?? null,
        "contact": contact ?? null,
        "address": address ?? null,
        "dob": dob ?? null,
        "gender": gender ?? null,
        "city": city ?? null,
        "province": province ?? null,
        "school": school ?? null,
        "college": college ?? college,
        "background": background ?? null,
        "faculty": faculty ?? null,
        "percentage": percentage ?? null,
        "source": source ?? null,
        "communication": communication ?? null,
        "institution": institution,
        "feedbacks": feedbacks == null ? null : feedbacks,
        "score": score == null ? null : score!.toJson(),
        "followedUpBy": followedUpBy == null ? null : followedUpBy,
        "referral": referral == null ? null : referral,
      };
}

class Score {
  Score({
    this.obtainedScore,
    this.totalScore,
  });

  int? obtainedScore;
  int? totalScore;

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    obtainedScore: json["obtainedScore"],
    totalScore: json["totalScore"],
  );

  Map<String, dynamic> toJson() => {
    "obtainedScore": obtainedScore,
    "totalScore": totalScore,
  };
}
