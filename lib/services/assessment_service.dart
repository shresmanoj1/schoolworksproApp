import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/assessment_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Assessmentservice {
  Future<Assessmentresponse> getAssessment(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse('$api_url2/assessments/my-assessments/$moduleSlug'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return Assessmentresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load assessment');
    }
  }
  // Future<Lessonresponse> getLesson(String moduleSlug) async {
  //   var client = http.Client();
  //   dynamic lessonModel;
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();

  //   String? token = sharedPreferences.getString('token');
  //   try {
  //     var response = await client.get(
  //       Uri.parse(api_url2 + 'lessons/' + moduleSlug + '/weekly/public'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json; charset=utf-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = jsonDecode(jsonString);

  //       lessonModel = Lessonresponse.fromJson(jsonMap);
  //     }
  //   } catch (exception) {
  //     return lessonModel;
  //   }

  //   return lessonModel;
  // }
}
