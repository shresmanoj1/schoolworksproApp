import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/attendancereport_request.dart';
import 'package:schoolworkspro_app/response/lecturer/attendancereport_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatchforattendance_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceReportService {
  Future<GetBatchForAttendanceResponse> getallbatch(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/modules/$moduleSlug/batches'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      // print(response.body);
      return GetBatchForAttendanceResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load batches');
    }
  }

  Future<AttendanceReportResponse> getAttendanceReport(
      AttendanceReportRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/attendance/attendanceReport'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              AttendanceReportResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AttendanceReportResponse(
            allAttendance: null,
            success: false,
          );
        }
      }).catchError((e) {
        return AttendanceReportResponse(
          allAttendance: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return AttendanceReportResponse(
        allAttendance: null,
        success: false,
      );
    } on HttpException {
      return AttendanceReportResponse(
        allAttendance: null,
        success: false,
      );
    } on FormatException {
      return AttendanceReportResponse(
        allAttendance: null,
        success: false,
      );
    }
  }
}
