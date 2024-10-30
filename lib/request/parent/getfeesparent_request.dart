class GetFeesForParentsRequest {
  GetFeesForParentsRequest({
this.institution,
    this.studentId,
  });


  String? studentId;
  String ? institution;

  Map<String, dynamic> toJson() => {

    "institution":institution,
        "studentId": studentId,
      };
}
