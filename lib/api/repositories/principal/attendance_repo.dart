import 'dart:convert';

import 'package:schoolworkspro_app/Screens/request/DateRequest.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/principal/allattendanceprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/attendancereport_response.dart';
import 'package:schoolworkspro_app/response/principal/staffattendanceprincipal_response.dart';

import '../../../response/lecturer/staff_type_response.dart';
import '../../../response/principal/accessed_modules_response.dart';
import '../../../response/principal/batch_wise_attendance_response.dart';
import '../../../response/principal/onetime_attendance_count_response.dart';
import '../../../response/principal/student_daily_attendance_response.dart';

class AttendanceRepository {
  Future<AttendanceReportforPrincipalResponse>
      getstudentattendancedaily() async {
    API api = new API();
    dynamic response;
    AttendanceReportforPrincipalResponse res;
    try {
      response = await api.getWithToken('/attendance/attendance-status-today');

      res = AttendanceReportforPrincipalResponse.fromJson(response);
    } catch (e) {
      res = AttendanceReportforPrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<GetAllAttendancePrincipalResponse> getAllAttendance(data) async {
    API api = API();
    dynamic response;
    GetAllAttendancePrincipalResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/attendance/attendanceReport');

      res = GetAllAttendancePrincipalResponse.fromJson(response);
    } catch (e) {
      res = GetAllAttendancePrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<BatchWiseAttendanceResponse> getAllBatchWiseAttendance(data) async {
    API api = API();
    dynamic response;
    BatchWiseAttendanceResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/attendance/batch-wise-attendance');

      res = BatchWiseAttendanceResponse.fromJson(response);
      print(res.toJson());
    } catch (e) {
      res = BatchWiseAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<AccessedModulesResponse> getAccessedModules(data) async {
    API api = API();
    dynamic response;
    AccessedModulesResponse res;
    try {
      print("BATCH:::${data}");
      response =
          await api.postDataWithToken(jsonEncode(data), '/modules/moduleList');

      res = AccessedModulesResponse.fromJson(response);
    } catch (e) {
      res = AccessedModulesResponse.fromJson(response);
    }
    return res;
  }

  Future<StaffAttendancePrincipalResponse> getAllAttendanceforstaffs(
      DateRequest data) async {
    API api = API();
    dynamic response;
    StaffAttendancePrincipalResponse res;
    try {
      response = await api.postDataWithToken(
          dateRequestToJson(data), '/staffAttendance/getAttendance');

      res = StaffAttendancePrincipalResponse.fromJson(response);
    } catch (e) {
      print('error ayo' + e.toString());
      res = StaffAttendancePrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<AttendanceReportforPrincipalResponse>
      getStudentOneTimeAttendanceDaily() async {
    API api = new API();
    dynamic response;
    AttendanceReportforPrincipalResponse res;
    try {
      response =
          await api.getWithToken('/attendance/overall-attendance-status-today');

      res = AttendanceReportforPrincipalResponse.fromJson(response);
    } catch (e) {
      res = AttendanceReportforPrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<StudentDailyAttendanceResponse> getAbsentStudentDailyAttendanceReport(
      String date, String batch, String course, String module) async {
    API api = API();
    dynamic response;
    StudentDailyAttendanceResponse res;
    try {
      var now = DateTime.now();
      String formattedDate = now.toString().substring(0, 10);
      response = await api.getWithToken(
          '/attendance/daily-student-attendance?course=$course&attendanceDate=$formattedDate&batch=$batch&module=$module');



      res = StudentDailyAttendanceResponse.fromJson(response);
    } catch (e) {
      res = StudentDailyAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<StaffResponse> getStaffType() async {
    API api = API();
    dynamic response;
    StaffResponse res;
    try {
      response = await api.getWithToken('/users/all-staff-data');



      res = StaffResponse.fromJson(response);
    } catch (e) {
      res = StaffResponse.fromJson(response);
    }
    return res;
  }
}
