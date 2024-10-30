import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserdetailService {
  Future<Userdetailresponse> getuserdetail() async {
    var client = http.Client();
    var userdetailmodel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    String? cookie = sharedPreferences.getString('cookie');
    String? server = sharedPreferences.getString('server');

    try {
      var response = await client.get(
        Uri.parse(api_url2 + '/users/my-details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        // print(response.body);
        userdetailmodel = Userdetailresponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return userdetailmodel;
    }

    return userdetailmodel;
  }

  Stream<Userdetailresponse> getRefreshprofile(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getuserdetail();
    }
  }
}
