import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/forgetpassword_response.dart';
import 'package:schoolworkspro_app/response/forgetpassword_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Forgetpasswordservice {
  Future<Forgetpasswordresponse> forgetpassword(
      Forgetpasswordrequest req) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/passwords/send-password-reset-email'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(req.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response =
              Forgetpasswordresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Forgetpasswordresponse(
              success: false, message: "Some Error Has Occured");
        }
      }).catchError((e) {
        return Forgetpasswordresponse(
            success: false, message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      return Forgetpasswordresponse(
          success: false, message: "Some Error Has Occured");
    } on HttpException {
      return Forgetpasswordresponse(
          success: false, message: "Some Error Has Occured");
    } on FormatException {
      return Forgetpasswordresponse(
          success: false, message: "Some Error Has Occured");
    }
  }
}
