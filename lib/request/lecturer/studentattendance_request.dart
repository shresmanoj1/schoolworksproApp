class StudentAttendanceRequest {
  StudentAttendanceRequest({
    this.moduleSlug,
    this.batch,
    this.presentStudents,
    this.absentStudents,
    this.attendanceType,
  });

  // if one time attendance chan bhane moduleSlug: "School"
  // if module wise cha bhane moduleSlug: "module_slug"

  String? moduleSlug;
  String? batch;
  String? attendanceType;
  List<dynamic>? presentStudents;
  List<dynamic>? absentStudents;

  Map<String, dynamic> toJson() => {
        "moduleSlug": moduleSlug,
        "batch": batch,
        "attendanceType": attendanceType,
        "present_students": List<dynamic>.from(presentStudents!.map((x) => x)),
        "absent_students": List<dynamic>.from(absentStudents!.map((x) => x)),
      };
}
