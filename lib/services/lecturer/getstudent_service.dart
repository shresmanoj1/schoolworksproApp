import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudent_batchresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentFetchService {
  Future<GetStudentByBatchResponse> getAllStudent(String batch) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    print(token);

    print("$api_url2/batch/$batch/student");
    final response = await http.get(
      Uri.parse(api_url2 + '/batch/$batch/student'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return GetStudentByBatchResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load students');
    }
  }
}
