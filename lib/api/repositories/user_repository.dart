import 'dart:convert';

import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';

import '../../response/attendance_response.dart';
import '../../response/authenticateduser_response.dart';
import '../../response/event_response.dart';
import '../../response/notice_response.dart';
import '../../response/principal/student_logs_screen.dart';
import '../../response/routine_response.dart';
import '../../response/student_bus_response.dart';
import '../../response/updatedetail_response.dart';
import '../../response/user_detail.dart';
import '../api.dart';

class UserRepository {
  API api = API();

  Future<LoginResponse> login(data) async {
    dynamic response = await api.postData(data, Endpoints.login);
    LoginResponse res = LoginResponse.fromJson(response);
    return res;
  }

  Future<Authenticateduserresponse> fetchAuthenticatedUser() async {
    dynamic response;
    Authenticateduserresponse res;
    try {
      response = await api.getWithToken(Endpoints.authenticatedUserdetails);
      res = Authenticateduserresponse.fromJson(response);
    } catch (e) {
      res = Authenticateduserresponse.fromJson(response);
    }
    return res;
  }

  Future<Userdetailresponse> fetchUsersDetails() async {
    dynamic response;
    Userdetailresponse res;
    try {
      response = await api.getWithToken(Endpoints.getMyDetails);

      res = Userdetailresponse.fromJson(response);
    } catch (e) {
      res = Userdetailresponse.fromJson(response);
    }
    return res;
  }

  Future<UpdatedetailResponse> updateUserDetails(data) async {
    dynamic response;
    UpdatedetailResponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), Endpoints.updateUserDetails);
      res = UpdatedetailResponse.fromJson(response);
    } catch (e) {
      res = UpdatedetailResponse.fromJson(response);
    }
    return res;
  }

  Future<Eventresponse> getAllEvents() async {
    dynamic response;
    Eventresponse res;
    try {
      response = await api.getWithToken(Endpoints.events);
      res = Eventresponse.fromJson(response);
    } catch (e) {
      res = Eventresponse.fromJson(response);
    }
    return res;
  }

  Future<Noticeresponse> getNotice(String page) async {
    dynamic response;
    Noticeresponse res;
    try {
      response = await api.getWithToken(Endpoints.notices + page.toString());
      res = Noticeresponse.fromJson(response);
    } catch (e) {
      res = Noticeresponse.fromJson(response);
    }
    return res;
  }

  Future<dynamic> getMyPermission() async {
    dynamic response;
    dynamic res;
    try {
      response = await api.getWithToken("/drole/my-permissions");
      res = response;

    } catch (e) {
    }
    return res;
  }

  Future<Routineresponse> getStudentRoutine(String batch) async {
    dynamic response;
    Routineresponse res;
    try {
      response = await api.getWithToken("/routines/$batch");
      res = Routineresponse.fromJson(response);
    } catch (e) {
      res = Routineresponse.fromJson(response);
    }
    return res;
  }

  Future<Attendanceresponse> getStudentSubjectWiseAttendance() async {
    dynamic response;
    Attendanceresponse res;
    try {
      response = await api.getWithToken("/attendance/myAttendance");
      res = Attendanceresponse.fromJson(response);
    } catch (e) {
      res = Attendanceresponse.fromJson(response);
    }
    return res;
  }

  Future<StudentBusResponse> getBusStudent() async {
    dynamic response;
    StudentBusResponse res;
    try {
      response = await api.getWithToken('/bus/my-bus/mine');
      print(response);
      res = StudentBusResponse.fromJson(response);
    } catch (e) {
      res = StudentBusResponse.fromJson(response);
    }
    return res;
  }

  Future<StudentLogsResponse> getStudentLogs(String username) async {
    dynamic response;
    StudentLogsResponse res;
    try {
      response = await api.getWithToken('/record/get-record/$username');
      print(response);
      res = StudentLogsResponse.fromJson(response);
    } catch (e) {
      res = StudentLogsResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addStudentLogs(data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(data, '/record/add');
      print(response);
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> updateStudentLogs(String id, data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(data, '/record/update-record/$id');
      print(response);
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }
}
