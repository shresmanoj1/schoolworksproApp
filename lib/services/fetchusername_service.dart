import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/response/getadmissionusername_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchAdmissionusernameservice {
  Future<GetAdmissionusernameresponse> fetchusername(
      Institutionrequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/users/admission'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              GetAdmissionusernameresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return GetAdmissionusernameresponse(
            admission: null,
            success: false,
          );
        }
      }).catchError((e) {
        return GetAdmissionusernameresponse(
          admission: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return GetAdmissionusernameresponse(
        admission: null,
        success: false,
      );
    } on HttpException {
      return GetAdmissionusernameresponse(
        admission: null,
        success: false,
      );
    } on FormatException {
      return GetAdmissionusernameresponse(
        admission: null,
        success: false,
      );
    }
  }
}
