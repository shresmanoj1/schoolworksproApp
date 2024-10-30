// To parse this JSON data, do
//
//     final logisticFeedbackRequest = logisticFeedbackRequestFromJson(jsonString);

import 'dart:convert';

LogisticFeedbackRequest logisticFeedbackRequestFromJson(String str) => LogisticFeedbackRequest.fromJson(json.decode(str));

String logisticFeedbackRequestToJson(LogisticFeedbackRequest data) => json.encode(data.toJson());

class LogisticFeedbackRequest {
  LogisticFeedbackRequest({
    this.feedback,
  });

  Feedback ? feedback;

  factory LogisticFeedbackRequest.fromJson(Map<String, dynamic> json) => LogisticFeedbackRequest(
    feedback: Feedback.fromJson(json["feedback"]),
  );

  Map<String, dynamic> toJson() => {
    "feedback": feedback?.toJson(),
  };
}

class Feedback {
  Feedback({
    this.feedback,
    this.postedBy,
  });

  String ? feedback;
  String ? postedBy;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    feedback: json["feedback"],
    postedBy: json["postedBy"],
  );

  Map<String, dynamic> toJson() => {
    "feedback": feedback,
    "postedBy": postedBy,
  };
}
