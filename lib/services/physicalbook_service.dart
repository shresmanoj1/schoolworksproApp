import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/physicalbook_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Physicalbookservice {
  Future<Physicalbookresponse> getphysicalbooks() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    print("GETTT::::::${api_url2 + '/library/physical/all/1'}");
    final response = await http.get(
      Uri.parse(api_url2 + '/library/physical/all/1'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );


    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Physicalbookresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load physical books');
    }
  }
}
