import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/add_project.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addprojectservice { 
  Future<Addprojectresponse> addproject(
      Addprojectrequest addprojectrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .put(Uri.parse('$api_url2/users/add-project-links'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: json.encode(addprojectrequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));

          // print(data.body);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Addprojectresponse(success: false, message: null);
        } else {
          return Addprojectresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Addprojectresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Addprojectresponse(success: false, message: null);
    } on HttpException {
      return Addprojectresponse(success: false, message: null);
    } on FormatException {
      return Addprojectresponse(success: false, message: null);
    }
  }

  Future<Addprojectresponse> deleteproject(
      Addprojectrequest addprojectrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .put(Uri.parse('$api_url2/users/remove-project-links'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: json.encode(addprojectrequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));
          // print(data.body);
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Addprojectresponse(success: false, message: null);
        } else {
          return Addprojectresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Addprojectresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Addprojectresponse(success: false, message: null);
    } on HttpException {
      return Addprojectresponse(success: false, message: null);
    } on FormatException {
      return Addprojectresponse(success: false, message: null);
    }
  }
}
