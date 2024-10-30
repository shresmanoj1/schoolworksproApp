import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/course_response.dart';
import 'package:schoolworkspro_app/response/particularmoduleresponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/hive_utils.dart';

class CourseService {
  Future<CourseResponse> getCourse() async {
    var client = http.Client();
    var coursemodel;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? abc = sharedPreferences.getString('_auth_');
    String? token = sharedPreferences.getString('token');

    // Map json = jsonDecode(sharedPreferences.getString('_auth_').toString());
    // String _auth_ = jsonEncode(json);
    try {
      var response = await client.get(
        Uri.parse(api_url2 + '/courses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // 'Charset': 'utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        // print(response.body);

        coursemodel = CourseResponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return coursemodel;
    }

    return coursemodel;
  }

  // Future<CourseResponse> getCourse() async {
  //   CourseResponse res;
  //   dynamic response;
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //     Box box = HiveUtils.box;
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(api_url2 + 'courses'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json; charset=utf-8',
  //       },
  //     );
  //
  //     if(response.statusCode == 200){
  //       res = CourseResponse.fromJson(jsonDecode(response.body));
  //
  //       box.put("courses", res.toJson());
  //     }
  //
  //   } catch (e) {
  //     response = await box.get("courses");
  //     res = CourseResponse.fromJson(response);
  //   }
  //   res = CourseResponse.fromJson(response);
  //   return res;
  //   // try {
  //   //   if (response.statusCode == 200) {
  //   //     return CourseResponse.fromJson(jsonDecode(response.body));
  //   //   } else {
  //   //     throw Exception('Failed to load ');
  //   //   }
  //   // } catch (e) {
  //   //   return CourseResponse.fromJson(jsonDecode(response.body));
  //   //   // TODO
  //   // }
  //   // return res;
  // }

}
