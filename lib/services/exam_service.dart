import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/getalluser_response.dart';
import 'package:schoolworkspro_app/response/getexam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerexam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/viewexamattendance_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ExamService {
  // Future<GetExamResponse> getExamDetails() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + '/exams/my-exams'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return GetExamResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to fetch data');
  //   }
  // }

  Future<LecturerGetExamResponse> getTodaysExam() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/exams/get-exam/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return LecturerGetExamResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch data');
    }
  }

  Future<ViewExamAttendanceResponse> examAttendance(id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/exam-attendance/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ViewExamAttendanceResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch data');
    }
  }
}
