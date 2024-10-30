import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/response/lecturer/lectureractivity_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';

class LecturerActivityService {
  Future<LecturerActivityResponse> getmodules(
      Map<String, dynamic> request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/lecturers/find-by-email'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              LecturerActivityResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return LecturerActivityResponse(
            assessments: null,
            success: false,
          );
        }
      }).catchError((e) {
        return LecturerActivityResponse(
          assessments: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return LecturerActivityResponse(
        assessments: null,
        success: false,
      );
    } on HttpException {
      return LecturerActivityResponse(
        assessments: null,
        success: false,
      );
    } on FormatException {
      return LecturerActivityResponse(
        assessments: null,
        success: false,
      );
    }
  }
}
