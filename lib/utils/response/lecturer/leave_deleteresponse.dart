import 'dart:convert';

LeaveDeleteResponse leaveDeleteResponseFromJson(String str) =>
    LeaveDeleteResponse.fromJson(json.decode(str));

String leaveDeleteResponseToJson(LeaveDeleteResponse data) =>
    json.encode(data.toJson());

class LeaveDeleteResponse {
  LeaveDeleteResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory LeaveDeleteResponse.fromJson(Map<String, dynamic> json) =>
      LeaveDeleteResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
