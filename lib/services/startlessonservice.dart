import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lessontrack_request.dart';
import 'package:schoolworkspro_app/response/startlesson_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Startlessonservice {
  Future<Startlessonresponse> startlesson(
      LessonTrackRequest lessonrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/tracking/start'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(lessonrequest.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response = Startlessonresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Startlessonresponse(success: false, status: null);
        }
      }).catchError((e) {
        return Startlessonresponse(success: false, status: null);
      });
    } on SocketException catch (e) {
      return Startlessonresponse(success: false, status: null);
    } on HttpException {
      return Startlessonresponse(success: false, status: null);
    } on FormatException {
      return Startlessonresponse(success: false, status: null);
    }
  }
}
