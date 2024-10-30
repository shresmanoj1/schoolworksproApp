import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/journey_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Journeyservice {
  Future<Journeyresponse> getmyjourney() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/users/getMyData'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return Journeyresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load journey');
    }
  }

  Stream<Journeyresponse> getRefreshJourney(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getmyjourney();
    }
  }
}
