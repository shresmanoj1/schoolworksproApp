import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/parent/attendance_request.dart';
import 'package:schoolworkspro_app/request/parent/progress_request.dart';
import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
import 'package:schoolworkspro_app/response/parents/childattendance_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildAttendanceService {
  Future<ChildAttendanceResponse> getchildattendance(
      Attendancerequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/parents/child-attendance'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {

          final response =
              ChildAttendanceResponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return ChildAttendanceResponse(success: false, allAttendance: null);
        } else {
          return ChildAttendanceResponse(success: false, allAttendance: null);
        }
      }).catchError((e) {
        return ChildAttendanceResponse(success: false, allAttendance: null);
      });
    } on SocketException catch (e) {
      return ChildAttendanceResponse(success: false, allAttendance: null);
    } on HttpException {
      return ChildAttendanceResponse(success: false, allAttendance: null);
    } on FormatException {
      return ChildAttendanceResponse(success: false, allAttendance: null);
    }
  }
}
