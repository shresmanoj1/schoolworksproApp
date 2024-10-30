import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/addassessment_request.dart';
import 'package:schoolworkspro_app/request/lecturer/postactivity_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addactivityservice {
  Future<Commonresponse> postAssessment(AddAssessmentRequest request) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse('${api_url2}/assessments/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Commonresponse.fromJson(jsonDecode(data.body));

          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Commonresponse(
            success: false,
            message: "some error has occured",
          );
        } else {
          return Commonresponse(
            success: false,
            message: "some error has occured",
          );
        }
      }).catchError((e) {
        return Commonresponse(
          success: false,
          message: "some error has occured",
        );
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    } on HttpException {
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    } on FormatException {
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    }
  }

  Future<Commonresponse> updateAssessment(
      AddAssessmentRequest request, String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      print("REQUEST:::${request.toJson()}");
      return await http
          .put(Uri.parse('${api_url2}/assessments/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Commonresponse.fromJson(jsonDecode(data.body));

          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Commonresponse(
            success: false,
            message: "some error has occured",
          );
        } else {
          return Commonresponse(
            success: false,
            message: "some error has occured",
          );
        }
      }).catchError((e) {
        return Commonresponse(
          success: false,
          message: "some error has occured",
        );
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    } on HttpException {
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    } on FormatException {
      return Commonresponse(
        success: false,
        message: "some error has occured",
      );
    }
  }
}
