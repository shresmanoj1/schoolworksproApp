import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/penalize_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api/endpoints.dart';
import '../../response/admin/disciplinary_history_request.dart';
import '../../response/common_response.dart';

class Penalizeservice {
  Future<Addprojectresponse> penalize(PenalizeRequest loginRequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/offense-reports/add-new'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));

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

  Future<Addprojectresponse> postStudentDisciplinaryActHistory(String data) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/offense-reports/add-new'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
          body: data,)
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));

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

  API api = new API();

  // Future<Commonresponse> postDisciplinaryHistory(DisciplinaryHistoryRequest data, List<String> files) async {
  //   dynamic response;
  //   Commonresponse res;
  //
  //   try {
  //     dynamic response = await api.postDataWithTokenAndFiles(data, Endpoints.disciplineHistory, [
  //       {"files": files}
  //     ]);
  //     res = Commonresponse.fromJson(response);
  //     print("RESS::${res.toJson()}");
  //   } catch (e) {
  //     print("CATCH:::: ${e.toString()}");
  //     res = Commonresponse.fromJson(response);
  //   }
  //   return res;
  // }

// Future<Addprojectresponse> penalize(
  //     String remarks, String username) async {
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   var postUri = Uri.parse(api_url2 + 'offense-reports/add-new');
  //   Map<String, String> headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var request = http.MultipartRequest("POST", postUri)
  //     ..fields['remarks'] = remarks
  //     ..fields['username'] = username
  //     // ..files.add(http.MultipartFile.fromBytes(
  //     //     'picture', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
  //     //     contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
  //     ..headers.addAll(headers);
  //   print(api_url2 + 'offense-reports/add-new');
  //   print(username);
  //   print(remarks);
  //   return await request.send().then((data) async {
  //     if (data.statusCode == 200) {
  //       var responseData = await data.stream.toBytes();
  //       var responseString = String.fromCharCodes(responseData);
  //       final response =
  //       Addprojectresponse.fromJson(jsonDecode(responseString));
  //
  //
  //
  //       // print(response.message);
  //       // String userData = jsonEncode(response.message);
  //       // sharedPreferences.setString("user", userData);
  //
  //       return response;
  //     } else {
  //       return Addprojectresponse(
  //         success: false,
  //         message: "Some error has occured",
  //       );
  //     }
  //   }).catchError((e) {
  //     // print(e);
  //     return Addprojectresponse(
  //       success: false,
  //       message: "Some error has occured",
  //     );
  //   });
  // }
}
