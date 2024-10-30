class ProgressStatsRequest {
  ProgressStatsRequest({
    this.institution,
    this.studentId,
  });

  String? institution;
  String? studentId;

  Map<String, dynamic> toJson() => {
        "institution": institution,
        "studentId": studentId,
      };
}
