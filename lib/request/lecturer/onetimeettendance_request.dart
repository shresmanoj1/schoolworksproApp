
class OneTimeAttendanceRequest {
  OneTimeAttendanceRequest({
    this.batch,
    this.presentStudents,
    this.absentStudents,
  });

  String? batch;
  List<dynamic>? presentStudents;
  List<dynamic>? absentStudents;

  factory OneTimeAttendanceRequest.fromJson(Map<String, dynamic> json) =>
      OneTimeAttendanceRequest(
        batch: json["batch"],
        presentStudents:
            List<dynamic>.from(json["present_students"].map((x) => x)),
        absentStudents:
            List<dynamic>.from(json["absent_students"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "batch": batch,
        "present_students": List<dynamic>.from(presentStudents!.map((x) => x)),
        "absent_students": List<dynamic>.from(absentStudents!.map((x) => x)),
      };
}
