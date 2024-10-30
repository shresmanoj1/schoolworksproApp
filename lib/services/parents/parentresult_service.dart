import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/parent/progress_request.dart';
import 'package:schoolworkspro_app/request/parent/result_header.dart';
import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
import 'package:schoolworkspro_app/response/parents/getresultparent_response.dart';
import 'package:schoolworkspro_app/response/result_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parentresultservice {
  Future<Resultresponse> getallresults(
      Parentresultheader request, String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/results/$username'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          print(data.body);

          final response = Resultresponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Resultresponse(success: false, results: null);
        } else {
          return Resultresponse(success: false, results: null);
        }
      }).catchError((e) {
        return Resultresponse(success: false, results: null);
      });
    } on SocketException catch (e) {
      return Resultresponse(success: false, results: null);
    } on HttpException {
      return Resultresponse(success: false, results: null);
    } on FormatException {
      return Resultresponse(success: false, results: null);
    }
  }
}
