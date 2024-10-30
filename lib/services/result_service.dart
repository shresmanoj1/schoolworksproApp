import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/result_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../response/marks_response.dart';

class Resultservice {
  Future<Resultresponse> getmyresults() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    print("GET::::${api_url2 + '/results/getMyResults'}");

    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse(api_url2 + '/results/getMyResults'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body);
      return Resultresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load result');
    }
  }

  Future<MarksResponse> getMyMarks() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('https://api.schoolworkspro.com/marks/my-marks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    print("${api_url2 + '/marks/my-marks'}");

    print((response.statusCode));
    print(response.body);

    if (response.statusCode == 200) {

      // print(response.body);
      return MarksResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load result:::');
    }
  }

  Future<MarksResponse> getChildrenResults(String studentId, String institution) async {
    API api = new API();
    dynamic response;
    MarksResponse res;
    try {
      // var institutionId = ;
      response = await api.postDataWithToken(jsonEncode({"institution": institution}), '/marks/get-marks/$studentId');

      res = MarksResponse.fromJson(response);
    } catch (e) {
      res = MarksResponse.fromJson(response);
    }
    return res;
  }
}
