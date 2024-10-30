import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/coursedetail_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailservice {
  Future<CoursedetailResponse> getCoursedetail(String moduleslug) async {
    var client = http.Client();
    dynamic coursedetailmodel;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // String? abc = sharedPreferences.getString('_auth_');
    String? token = sharedPreferences.getString('token');

    try {
      print('$api_url2/courses/$moduleslug');
      var response = await client.get(
        Uri.parse('$api_url2/courses/$moduleslug'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        print("DATAAA::::${jsonMap}");

        // print(response.body);
        coursedetailmodel = CoursedetailResponse.fromJson(jsonMap);
      }
    } catch (exception) {
      print("VM CATCH ERR222222 :: " + exception.toString());
      return coursedetailmodel;
    }

    return coursedetailmodel;
  }
}
