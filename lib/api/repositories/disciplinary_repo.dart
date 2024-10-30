import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/api_exception.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/disciplinary_response.dart';
import 'package:schoolworkspro_app/response/principal/editact_response.dart';
import 'package:schoolworkspro_app/response/principal/sisciplinary_level_details.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Screens/lecturer/Morelecturer/student_stats/components/disciplinary_stats.dart';
import '../../config/preference_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class DisciplinaryRepo {
  final SharedPreferences localStorage = PreferenceUtils.instance;
  Future<DisciplinaryResponse> getdisciplinary() async {
    API api = new API();
    final SharedPreferences localStorage = PreferenceUtils.instance;

    dynamic response;
    DisciplinaryResponse res;
    try {
      response = await api.getWithToken('/disciplinary-actions/');
      res = DisciplinaryResponse.fromJson(response);
    } catch (e) {
      res = DisciplinaryResponse.fromJson(response);
    }
    return res;
  }

  Future<DisciplinaryLevelDetailsResponse>
      getDisciplinaryHistoryLevelDetails(String id) async {
    API api = new API();

    dynamic response;
    DisciplinaryLevelDetailsResponse res;
    try {
      response = await api.getWithToken(
          "/disciplinary-history/get-level-details/$id");
      res = DisciplinaryLevelDetailsResponse.fromJson(response);
    } catch (e) {
      res = DisciplinaryLevelDetailsResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postact(data) async {
    API api = new API();

    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/disciplinary-actions/');
      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postDisciplinaryHistory(
      PostDisciplinaryHistoryRequest data) async {
    final Dio dio = Dio();

    print("[POST] :: $api_url2/disciplinary-history/");

    var token = localStorage.getString('token');

    String? fileName2 = data.file != null ?  data.file!.path.split('/').last : "";
    String dateName = data.date!.split(' ').first;

    print("YESSS:::");

    print(data.misconducts);


    FormData formData = FormData.fromMap({
      "file": data.file != null ? await MultipartFile.fromFile(data.file!.path,
          filename: fileName2) : null,
      "level": data.level,
      "remarks": data.remarks,
      "date": dateName,
      "misconducts": data.misconducts,
      "actions": data.actions,
      "username": data.username,
      "filename": ""
    });

    try {
      final Response response = await dio.post(
        "${api_url2}/disciplinary-history/",
        data: formData,
        options: Options(
          contentType: 'application/json',
          headers: <String, String>{
            'Authorization': 'Bearer ${token!}'
          },
        ),
      );
      print("check:::::::::");
      if (response.statusCode == 200) {
        print("20000::::::");
        print(response.data);
        return Commonresponse.fromJson(response.data);
      } else {
        throw ApiException(response.data);
        return Future.error("Application process failed!");
      }
    } on SocketException {
      throw ApiException("No Internet Connection");
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print("RESPOSE ERR :: " + e.toString());
      return Future.error(e.toString());
    }
  }

  Future<Commonresponse> postDisciplinaryHistoryWithoutImage(PostDisciplinaryHistoryRequest data) async {
    API api = new API();

    dynamic response;
    Commonresponse res;

    print("USERERRRNAMEEE:::::${data.username}");


    PostDisciplinaryHistoryRequest requestData = PostDisciplinaryHistoryRequest(
      level: data.level,
      remarks: data.remarks,
      date: data.date,
      misconducts: data.misconducts,
      actions: data.actions,
      username: data.username,
      filename: null,
      file: null
    );

    String data22 = jsonEncode({
      "level": data.level,
      "remarks": data.remarks,
      "date": data.date,
      "misconducts": data.misconducts,
      "actions": data.actions,
      "username": data.username,
    });

    print("USERERRRNAMEEE:::::${data22}");
    try {
      response = await api.postDataWithToken(data22,'/disciplinary-history/');
      print("RESPNOE::::$response");

      res = Commonresponse.fromJson(response);
      print(res.toJson());
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<EditActResponse> editAct(String id) async {
    API api = new API();

    dynamic response;
    EditActResponse res;
    try {
      response = await api.putWithToken('/disciplinary-actions/$id');
      res = EditActResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = EditActResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> deleteact(String id) async {
    API api = new API();

    dynamic response;
    Commonresponse res;
    try {
      response =
          await api.deleteWithToken('/disciplinary-actions/$id');
      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> disciplinaryStudentRemarkRepo(data) async {
    API api = new API();

    dynamic response;
    Commonresponse res;
    try {
      response =
      await api.postDataWithToken(jsonEncode(data), '/offense-reports/add-new');
      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  // Future<Commonresponse> disciplinaryStudentRemarkRepo(
  //    String remark, String username, String file) async {
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   print("[POST]:::${'$api_url2/offense-reports/add-new'}");
  //
  //   var postUri = Uri.parse('$api_url2/offense-reports/add-new');
  //   Map<String, String> headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var request = http.MultipartRequest("POST", postUri);
  //   request.fields['username'] = username;
  //   request.fields['remarks'] = remark;
  //   if (file != "") {
  //     request.files.add(http.MultipartFile.fromBytes(
  //         'file', await File.fromUri(Uri.parse(file)).readAsBytes(),
  //         contentType: MediaType('image', 'jpg'), filename: 'image.jpg'));
  //   }
  //   request.headers.addAll(headers);
  //
  //   return await request.send().then((data) async {
  //     print("[RESPONSE]:::${data.statusCode}:::${data.stream}");
  //     if (data.statusCode == 200) {
  //       var responseData = await data.stream.toBytes();
  //       var responseString = String.fromCharCodes(responseData);
  //       final response =
  //       Commonresponse.fromJson(jsonDecode(responseString));
  //
  //       return response;
  //     } else {
  //       return Commonresponse(
  //         success: false,
  //         message: "Some error has occured",
  //       );
  //     }
  //   }).catchError((e) {
  //     print(e);
  //     return Commonresponse(
  //       success: false,
  //       message: "Some error has occured",
  //     );
  //   });
  // }
}
