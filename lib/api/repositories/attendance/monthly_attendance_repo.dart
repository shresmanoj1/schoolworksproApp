import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/getmessage_response.dart';
import 'package:schoolworkspro_app/response/monthly_onetimeattendance_response.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';

import '../../../response/attendancedetail_response.dart';
import '../../../response/overall_attendance_response.dart';

class MonthlyAttendanceRepo {
  Future<OneTimeAttendanceMonthlyResponse> getReport(data) async {
    API api = new API();

    dynamic response;
    OneTimeAttendanceMonthlyResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/attendance/monthlyReport');

      res = OneTimeAttendanceMonthlyResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      // print("asas"+response.toString());
      res = OneTimeAttendanceMonthlyResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<AttendanceDetailResponse> getAttendanceReport(
      String username, data) async {
    API api = API();

    dynamic response;
    AttendanceDetailResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/parents/child-absent-details/$username');

      res = AttendanceDetailResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = AttendanceDetailResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }


  Future<OverallAttendanceResponse> getOverallAttendanceReport(data) async {
    API api = API();

    dynamic response;
    OverallAttendanceResponse res;
    try {
      print("[user name]:::${data}");
      response = await api.postDataWithToken(jsonEncode(data), '/users/overall-att');

      print("[RESPONSE]::${response}");

      res = OverallAttendanceResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = OverallAttendanceResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
