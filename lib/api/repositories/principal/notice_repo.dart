import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/Screens/prinicpal/notice/updatemynotice_response.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/admin/admin_notice_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/principal/mynoticeprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/newsannouncement_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class NoticePrincipalRepository {
  API api = API();
  Future<Commonresponse> addnotice(data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), '/notices/add');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<AdminNoticeResponse> fetchAllNoticeAdmin() async {
    API api = API();
    dynamic response;
    AdminNoticeResponse res;
    try {
      response = await api.getWithToken('/notices/all-notices-admin');

      res = AdminNoticeResponse.fromJson(response);
    } catch (e) {
      res = AdminNoticeResponse.fromJson(response);
    }
    return res;
  }

  Future<UpdateNoticeResponse> editmynotice(data, id) async {
    dynamic response;
    UpdateNoticeResponse res;
    try {
      response = await api.putDataWithToken(jsonEncode(data), '/notices/$id');

      res = UpdateNoticeResponse.fromJson(response);
    } catch (e) {
      res = UpdateNoticeResponse.fromJson(response);
    }
    return res;
  }

  Future<Mynoticeesponse> getmynotices() async {
    API api = API();
    dynamic response;
    Mynoticeesponse res;
    try {
      response = await api.getWithToken('/notices/my-notices/all');

      res = Mynoticeesponse.fromJson(response);
    } catch (e) {
      res = Mynoticeesponse.fromJson(response);
    }
    return res;
  }

  Future<NewsAnnouncementResponse> getnewsandannouncment(
      List<Map<String, String>> params) async {
    String url = "/notices/all";
    String _addedParams = "/";
    for (var e in params) {
      _addedParams += "${e.values.first.toString()}";
    }
    url += _addedParams;
    print("URL :: " + url.toString());
    dynamic response;

    NewsAnnouncementResponse res;
    try {
      response = await api.getWithToken(url);
      print("RESPONSEssssss :: " + response.toString());
      res = NewsAnnouncementResponse.fromJson(response);
    } catch (e) {
      print('no datassss' + e.toString());

      res = NewsAnnouncementResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addNoticeWithImage(data, PickedFile? file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/notices/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri);
    request.fields['noticeTitle'] = data['noticeTitle'];
    request.fields['noticeContent'] = data['noticeContent'];
    request.fields['type'] = data['type'];

    if (data['type'] == "Lecturer" || data['type'] == "Staff") {
      request.fields['department'] = data['department'].toString();
    }
    if (data['type'] == "Batch") {
      request.fields['batch'] = data['batch'].toString();
    }

    if (data['type'] == "Club") {
      request.fields['clubName'] = data['clubName'].toString();
    }

    if (data['type'] == "Course") {
      request.fields['courseSlug'] = data['courseSlug'].toString();
    }

    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'file', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'));
      print("FILE::${request.files}");
    }

    request.headers.addAll(headers);

    print("TESTING::${request.fields}");

    return await request.send().then((data) async {
      print("testing 1::");
      print(data.statusCode);
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response = Commonresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return Commonresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      print(e);
      return Commonresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }
}
