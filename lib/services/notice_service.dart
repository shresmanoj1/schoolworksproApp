import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/notice_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeService {
  // Future<Noticeresponse> getNotice() async {
  //   var client = http.Client();
  //   var alertModel;
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString("token");
//
//     try {
//       var response = await client.get(
//         Uri.parse(api_url2 + '/notices/all-notices/1'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json; charset=utf-8',
//         },
//       );
//       if (response.statusCode == 200) {
//         var jsonString = response.body;
//         var jsonMap = jsonDecode(jsonString);
//
//         // print(response.body);
//         alertModel = Noticeresponse.fromJson(jsonMap);
//       }
//     } catch (exception) {
//       return alertModel;
//     }
//
//     return alertModel;
//   }
//
  Future<Noticeresponse> getNoticeAdmin() async {
    var client = http.Client();
    var adminNoticeModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString("token");

    try {
      var response = await client.get(
        Uri.parse(api_url2 + '/notices/all/1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        // print(response.body);
        adminNoticeModel = Noticeresponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return adminNoticeModel;
    }

    return adminNoticeModel;
  }
}
