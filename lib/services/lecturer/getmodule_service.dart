import 'dart:convert';
import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/get_modulerequest.dart';
import 'package:schoolworkspro_app/request/lecturer/lecturer_access.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ModuleServiceLecturer {
  Future<Findbyemailresponse> getmodules(Getmodulerequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("URL::::${api_url2 + '/lecturers/find-by-email'}");

    try {
      return await http
          .post(Uri.parse(api_url2 + '/lecturers/find-by-email'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Findbyemailresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Findbyemailresponse(
            lecturer: null,
            success: false,
          );
        }
      }).catchError((e) {
        return Findbyemailresponse(
          lecturer: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return Findbyemailresponse(
        lecturer: null,
        success: false,
      );
    } on HttpException {
      return Findbyemailresponse(
        lecturer: null,
        success: false,
      );
    } on FormatException {
      return Findbyemailresponse(
        lecturer: null,
        success: false,
      );
    }
  }

  Future<LecturerModuleDetailResponse> module_detail(
      LecturerAccess request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/modules/check/lecturer-access'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              LecturerModuleDetailResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return LecturerModuleDetailResponse(
            module: null,
            success: false,
          );
        }
      }).catchError((e) {
        return LecturerModuleDetailResponse(
          module: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return LecturerModuleDetailResponse(
        module: null,
        success: false,
      );
    } on HttpException {
      return LecturerModuleDetailResponse(
        module: null,
        success: false,
      );
    } on FormatException {
      return LecturerModuleDetailResponse(
        module: null,
        success: false,
      );
    }
  }
}
