import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/setpassword_request.dart';
import 'package:schoolworkspro_app/request/usernameverification_request.dart';
import 'package:schoolworkspro_app/response/usernameverification_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signupservice {
  Future<Usernameverificationresponse> checkusername(
      Usernameverificationrequest checkRequest) async {
    try {
      return await http
          .post(Uri.parse(api_url2 + '/verification/signup'),
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(checkRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              Usernameverificationresponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Usernameverificationresponse(success: false, message: null);
        } else {
          return Usernameverificationresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Usernameverificationresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      return Usernameverificationresponse(success: false, message: null);
    } on HttpException {
      return Usernameverificationresponse(success: false, message: null);
    } on FormatException {
      return Usernameverificationresponse(success: false, message: null);
    }
  }

  Future<Usernameverificationresponse> setpassword(
      Setpasswordrequest passwordRequest) async {
    try {
      return await http
          .post(Uri.parse(api_url2 + '/verification/set-password'),
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(passwordRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              Usernameverificationresponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Usernameverificationresponse(success: false, message: null);
        } else {
          return Usernameverificationresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Usernameverificationresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      return Usernameverificationresponse(success: false, message: null);
    } on HttpException {
      return Usernameverificationresponse(success: false, message: null);
    } on FormatException {
      return Usernameverificationresponse(success: false, message: null);
    }
  }
}
