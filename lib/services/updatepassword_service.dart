import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/moredetailupdate_request.dart';
import 'package:schoolworkspro_app/request/password_updaterequest.dart';
import 'package:schoolworkspro_app/response/passwordupdate_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Updatepasswordservice {
  Future<Passwordupdateresponse> updatePassword(
      PasswordUpdateRequest passwordUpdateRequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      print("TOKEN::${token}");
      return await http
          .put(Uri.parse(api_url2 + '/users/update-password'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(passwordUpdateRequest.toJson()))
          .then((data) {
            print(api_url2 + '/users/update-password');
            print(jsonEncode(passwordUpdateRequest.toJson()));
            print("PASSWORD DATA::::${data.body}:::${data.statusCode }");
        if (data.statusCode == 200) {
          final response =
              Passwordupdateresponse.fromJson(jsonDecode(data.body));
          // print(data.body);
          return response;
        } else {
          final response =
          Passwordupdateresponse.fromJson(jsonDecode(data.body));
          return Passwordupdateresponse(
            success: false,
            message: response.message.toString(),
          );
        }
      }).catchError((e) {
        return Passwordupdateresponse(
          success: false,
          message: "Some error has occured",
        );
      });
    } on SocketException catch (e) {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    } on HttpException {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    } on FormatException {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    }
  }

  Future<Passwordupdateresponse> updateDetails(
      MoredetailUpdateRequest detailUpdateRequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse(api_url2 + '/users/update-details'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(detailUpdateRequest.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response =
              Passwordupdateresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Passwordupdateresponse(
            success: false,
            message: "Some error has occured",
          );
        }
      }).catchError((e) {
        return Passwordupdateresponse(
          success: false,
          message: "Some error has occured",
        );
      });
    } on SocketException catch (e) {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    } on HttpException {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    } on FormatException {
      return Passwordupdateresponse(
        success: false,
        message: "Some error has occured",
      );
    }
  }
}
