import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Addnoticelecturerservice {
  Future<Commonresponse> addnotice(Map<String, dynamic> payload) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/notices/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(payload))
          .then((data) {
        print(api_url2 + '/overtime/add');
        if (data.statusCode == 200) {
          final response = Commonresponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Commonresponse(success: false, message: null);
        } else {
          return Commonresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Commonresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Commonresponse(success: false, message: null);
    } on HttpException {
      return Commonresponse(success: false, message: null);
    } on FormatException {
      return Commonresponse(success: false, message: null);
    }
  }
}
