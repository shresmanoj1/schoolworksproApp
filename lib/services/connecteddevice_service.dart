import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/connecteddevice_response.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Connecteddeviceservice {
  Future<Connecteddeviceresponse> getdevices() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('$api_url2/logins/show'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      return Connecteddeviceresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load ');
    }
  }

  Stream<Connecteddeviceresponse> getrefreshdevice(
      Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getdevices();
    }
  }
}
