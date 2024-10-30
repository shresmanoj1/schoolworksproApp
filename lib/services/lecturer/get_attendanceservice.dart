import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/activity_response.dart';
import 'package:schoolworkspro_app/response/lecturer/attendance_lecturerresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/check_attendance.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAttendanceService extends ChangeNotifier{


  // Future<CheckAttendanceResponse> getStudentAttendance(
  //     String moduleSlug, String batch) async {
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   // var module = moduleSlug.split(" ").join("%20");
  //
  //   print('$api_url2/attendance/checkAttended/$moduleSlug/$batch');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + '/attendance/checkAttended/$moduleSlug/$batch'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // print(response.body);
  //     // print(response.body);
  //     return CheckAttendanceResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load attendance');
  //   }
  // }

  Future<AttendancelecturerResponse> getAttendance(
      String moduleSlug, String batch) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    print("POST::::${api_url2 + '/attendance/$moduleSlug/$batch'}");

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/attendance/$moduleSlug/$batch'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print("RESPONSE BODY::::${response.body}");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      // print(response.body);
      return AttendancelecturerResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load attendance');
    }
  }

  CheckAttendanceResponse ? data;

  // Future<CheckAttendanceResponse> checkifattendanceprovider(String moduleSlug, String batch, context) async {
  //   var client = http.Client();
  //
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   var response = await client.get(
  //     Uri.parse(api_url2 + 'attendance/checkAttended/$moduleSlug/$batch'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     return CheckAttendanceResponse.fromJson(jsonDecode(response.body));
  //
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load attendance');
  //   }
  //
  // }

  Future<CheckAttendanceResponse> checkIfAttendanceDone(
      String moduleSlug, String batch) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/attendance/checkAttended/$moduleSlug/$batch'),
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
      return CheckAttendanceResponse.fromJson(jsonDecode(response.body));


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to check attendance');
    }
  }

  // Stream<AttendancelecturerResponse> getrefreshattendance(
  //     Duration refreshTime, String moduleSlug, String batch) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await getAttendance(moduleSlug, batch);
  //   }
  // }

  Stream<CheckAttendanceResponse> getRefreshCheckIfAttendance(
      Duration refreshTime, String moduleSlug, String batch) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await checkIfAttendanceDone(moduleSlug, batch);
    }
  }
}