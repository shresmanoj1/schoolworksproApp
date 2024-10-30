import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lessontrack_request.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessonstatus_response.dart';
import 'package:schoolworkspro_app/response/markascompleteresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lessonservice {
  Future<Lessonresponse> getLesson(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/lessons/' + moduleSlug + '/weekly/public'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Lessonresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load lesson');
    }
  }

  Future<Markascompleteresponse> marklessoncomplete(
      LessonTrackRequest lessonrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/tracking/mark-as-complete'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(lessonrequest.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response =
              Markascompleteresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Markascompleteresponse(success: false, lessonStatus: null);
        }
      }).catchError((e) {
        return Markascompleteresponse(success: false, lessonStatus: null);
      });
    } on SocketException catch (e) {
      return Markascompleteresponse(success: false, lessonStatus: null);
    } on HttpException {
      return Markascompleteresponse(success: false, lessonStatus: null);
    } on FormatException {
      return Markascompleteresponse(success: false, lessonStatus: null);
    }
  }

  Future<LessonstatusResponse> getlessonstatus(
      LessonTrackRequest lessonrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/tracking/lesson-status'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(lessonrequest.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response = LessonstatusResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return LessonstatusResponse(success: false, lessonStatus: null);
        }
      }).catchError((e) {
        return LessonstatusResponse(success: false, lessonStatus: null);
      });
    } on SocketException catch (e) {
      return LessonstatusResponse(success: false, lessonStatus: null);
    } on HttpException {
      return LessonstatusResponse(success: false, lessonStatus: null);
    } on FormatException {
      return LessonstatusResponse(success: false, lessonStatus: null);
    }
  }
}
