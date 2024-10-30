import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/attendancedetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceDetailService {
  Future<AttendanceDetailResponse> attendanceDetail(
      Map<String, dynamic> request, String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse('${api_url2}/parents/child-absent-details/$username'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              AttendanceDetailResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AttendanceDetailResponse(allAttendance: null, success: false);
        }
      }).catchError((e) {
        return AttendanceDetailResponse(allAttendance: null, success: false);
      });
    } on SocketException catch (e) {
      return AttendanceDetailResponse(allAttendance: null, success: false);
    } on HttpException {
      return AttendanceDetailResponse(allAttendance: null, success: false);
    } on FormatException {
      return AttendanceDetailResponse(allAttendance: null, success: false);
    }
  }
}
