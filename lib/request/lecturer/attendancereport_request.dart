import 'dart:convert';

class AttendanceReportRequest {
  AttendanceReportRequest({
    this.batch,
    this.moduleSlug,
  });

  String? batch;
  String? moduleSlug;

  Map<String, dynamic> toJson() => {
        "batch": batch,
        "moduleSlug": moduleSlug,
      };
}
