import 'dart:convert';

Issuedbookresponse issuedbookresponseFromJson(String str) => Issuedbookresponse.fromJson(json.decode(str));

String issuedbookresponseToJson(Issuedbookresponse data) => json.encode(data.toJson());

class Issuedbookresponse {
  Issuedbookresponse({
    this.success,
    this.issueHistory,
  });

  bool ? success;
  List<dynamic> ? issueHistory;

  factory Issuedbookresponse.fromJson(Map<String, dynamic> json) => Issuedbookresponse(
    success: json["success"],
    issueHistory: List<dynamic>.from(json["issue_history"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "issue_history": List<dynamic>.from(issueHistory!.map((x) => x)),
  };
}

// class IssueHistory {
//   IssueHistory({
//     this.returned,
//     this.softDelete,
//     this.approved,
//     this.id,
//     this.bookSlug,
//     this.username,
//     this.issueDate,
//     this.dueDate,
//     this.institution,
//     this.renewedHistory,
//     this.createdAt,
//   });
//
//   bool returned;
//   bool softDelete;
//   bool approved;
//   String id;
//   String bookSlug;
//   String username;
//   DateTime issueDate;
//   DateTime dueDate;
//   String institution;
//   List<dynamic> renewedHistory;
//   DateTime createdAt;
//
//   factory IssueHistory.fromJson(Map<String, dynamic> json) => IssueHistory(
//     returned: json["returned"],
//     softDelete: json["soft_delete"],
//     approved: json["approved"],
//     id: json["_id"],
//     bookSlug: json["book_slug"],
//     username: json["username"],
//     issueDate: DateTime.parse(json["issue_date"]),
//     dueDate: DateTime.parse(json["due_date"]),
//     institution: json["institution"],
//     renewedHistory: List<dynamic>.from(json["renewed_history"].map((x) => x)),
//     createdAt: DateTime.parse(json["createdAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "returned": returned,
//     "soft_delete": softDelete,
//     "approved": approved,
//     "_id": id,
//     "book_slug": bookSlug,
//     "username": username,
//     "issue_date": issueDate.toIso8601String(),
//     "due_date": dueDate.toIso8601String(),
//     "institution": institution,
//     "renewed_history": List<dynamic>.from(renewedHistory.map((x) => x)),
//     "createdAt": createdAt.toIso8601String(),
//   };
// }
