import 'dart:convert';

String overtimeRequestToJson(OvertimeRequest data) =>
    json.encode(data.toJson());

class OvertimeRequest {
  OvertimeRequest({
    this.endDate,
    this.purpose,
    this.startDate,
  });

  String? endDate;
  String? purpose;
  String? startDate;

  Map<String, dynamic> toJson() => {
        "endDate": endDate,
        "purpose": purpose,
        "startDate": startDate,
      };
}
