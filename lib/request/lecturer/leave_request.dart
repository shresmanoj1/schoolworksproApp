import 'dart:convert';

class LeaveRequest {
  LeaveRequest(
      {this.content,
      this.endDate,
      this.leaveTitle,
      this.leaveType,
      this.startDate,
      this.allDay});

  String? content;
  String? endDate;
  String? leaveTitle;
  String? leaveType;
  String? startDate;
  bool? allDay;

  Map<String, dynamic> toJson() => {
        "content": content,
        "endDate": endDate,
        "leaveTitle": leaveTitle,
        "leaveType": leaveType,
        "startDate": startDate,
        "allDay": allDay
      };
}
