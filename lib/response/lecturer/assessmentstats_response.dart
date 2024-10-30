// // To parse this JSON data, do
// //
// //     final assessmentStatsResponse = assessmentStatsResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// AssessmentStatsResponse assessmentStatsResponseFromJson(String str) =>
//     AssessmentStatsResponse.fromJson(json.decode(str));
//
// String assessmentStatsResponseToJson(AssessmentStatsResponse data) =>
//     json.encode(data.toJson());
//
// class AssessmentStatsResponse {
//   AssessmentStatsResponse({
//     this.success,
//     this.assessments,
//   });
//
//   bool? success;
//   List<AssessmentStatsResponseAssessment>? assessments;
//
//   factory AssessmentStatsResponse.fromJson(Map<String, dynamic> json) =>
//       AssessmentStatsResponse(
//         success: json["success"],
//         assessments: List<AssessmentStatsResponseAssessment>.from(
//             json["assessments"]
//                 .map((x) => AssessmentStatsResponseAssessment.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
//       };
// }
//
// class AssessmentStatsResponseAssessment {
//   AssessmentStatsResponseAssessment({
//     this.week,
//     this.assessments,
//   });
//
//   int? week;
//   List<AssessmentAssessment>? assessments;
//
//   factory AssessmentStatsResponseAssessment.fromJson(
//           Map<String, dynamic> json) =>
//       AssessmentStatsResponseAssessment(
//         week: json["week"],
//         assessments: List<AssessmentAssessment>.from(
//             json["assessments"].map((x) => AssessmentAssessment.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "week": week,
//         "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
//       };
// }
//
// class AssessmentAssessment {
//   AssessmentAssessment({
//     this.submissions,
//     this.id,
//     this.lessonSlug,
//     this.institution,
//     this.submissionCount,
//     this.totalCount,
//     this.lessonTitle,
//   });
//
//   List<dynamic>? submissions;
//   String? id;
//   String? lessonSlug;
//   String? institution;
//   int? submissionCount;
//   int? totalCount;
//   String? lessonTitle;
//
//   factory AssessmentAssessment.fromJson(Map<String, dynamic> json) =>
//       AssessmentAssessment(
//         submissions: List<dynamic>.from(json["submissions"].map((x) => x)),
//         id: json["_id"],
//         lessonSlug: json["lessonSlug"],
//         institution: json["institution"],
//         submissionCount: json["submissionCount"],
//         totalCount: json["totalCount"],
//         lessonTitle: json["lessonTitle"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "submissions": List<dynamic>.from(submissions!.map((x) => x)),
//         "_id": id,
//         "lessonSlug": lessonSlug,
//         "institution": institution,
//         "submissionCount": submissionCount,
//         "totalCount": totalCount,
//         "lessonTitle": lessonTitle,
//       };
// }

// To parse this JSON data, do
//
//     final assessmentStatsResponse = assessmentStatsResponseFromJson(jsonString);

import 'dart:convert';

AssessmentStatsResponse assessmentStatsResponseFromJson(String str) => AssessmentStatsResponse.fromJson(json.decode(str));

String assessmentStatsResponseToJson(AssessmentStatsResponse data) => json.encode(data.toJson());

class AssessmentStatsResponse {
  AssessmentStatsResponse({
    this.success,
    this.assessments,
  });

  bool? success;
  List<AssessmentStatsResponseAssessment>? assessments;

  factory AssessmentStatsResponse.fromJson(Map<String, dynamic> json) => AssessmentStatsResponse(
    success: json["success"],
    assessments: List<AssessmentStatsResponseAssessment>.from(json["assessments"].map((x) => AssessmentStatsResponseAssessment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
  };
}

class AssessmentStatsResponseAssessment {
  AssessmentStatsResponseAssessment({
    this.week,
    this.assessments,
  });

  int? week;
  List<AssessmentAssessment>? assessments;

  factory AssessmentStatsResponseAssessment.fromJson(Map<String, dynamic> json) => AssessmentStatsResponseAssessment(
    week: json["week"],
    assessments: List<AssessmentAssessment>.from(json["assessments"].map((x) => AssessmentAssessment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "week": week,
    "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
  };
}

class AssessmentAssessment {
  AssessmentAssessment({
    this.resit,
    this.forResitOnly,
    this.submissions,
    this.id,
    this.lessonSlug,
    this.institution,
    this.submissionCount,
    this.totalCount,
    this.lessonTitle,
  });

  List<dynamic>? resit;
  bool? forResitOnly;
  List<dynamic>? submissions;
  String? id;
  String? lessonSlug;
  String? institution;
  int? submissionCount;
  int? totalCount;
  String? lessonTitle;

  factory AssessmentAssessment.fromJson(Map<String, dynamic> json) => AssessmentAssessment(
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    forResitOnly: json["forResitOnly"],
    submissions: List<dynamic>.from(json["submissions"].map((x) => x)),
    id: json["_id"],
    lessonSlug: json["lessonSlug"],
    institution: json["institution"],
    submissionCount: json["submissionCount"],
    totalCount: json["totalCount"],
    lessonTitle: json["lessonTitle"],
  );

  Map<String, dynamic> toJson() => {
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "forResitOnly": forResitOnly,
    "submissions": List<dynamic>.from(submissions!.map((x) => x)),
    "_id": id,
    "lessonSlug": lessonSlug,
    "institution": institution,
    "submissionCount": submissionCount,
    "totalCount": totalCount,
    "lessonTitle": lessonTitle,
  };
}

