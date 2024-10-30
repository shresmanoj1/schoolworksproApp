import 'dart:convert';

class AssignSupportTicketRequest {
  AssignSupportTicketRequest({
    this.assignedTo,
    this.assignedDate,
  });

  String? assignedTo;
  DateTime? assignedDate;

  Map<String, dynamic> toJson() => {
        "assignedTo": assignedTo,
        "assignedDate": assignedDate?.toIso8601String(),
      };
}
