import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/survey_request.dart';
import 'package:schoolworkspro_app/response/postsurvey_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Postsurveyservice {
  Future<Postsurveyresponse> addsurvey(Surveyrequest req) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse(api_url2 + '/survey/submit/'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(req.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response = Postsurveyresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Postsurveyresponse(
              success: false, message: "Some Error Has Occured");
        }
      }).catchError((e) {
        return Postsurveyresponse(
            success: false, message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      return Postsurveyresponse(
          success: false, message: "Some Error Has Occured");
    } on HttpException {
      return Postsurveyresponse(
          success: false, message: "Some Error Has Occured");
    } on FormatException {
      return Postsurveyresponse(
          success: false, message: "Some Error Has Occured");
    }
  }
}
