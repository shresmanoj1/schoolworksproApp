import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/accessedmodule_response.dart';
import 'package:schoolworkspro_app/response/logisticsstudent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessedStudentService {
  Future<LogisticsStudent> getAccessedStudent(String? batch) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('$api_url2/batch/${batch.toString()}/logistics/student/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return LogisticsStudent.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load accessed student');
    }
  }
}
