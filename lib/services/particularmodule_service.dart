import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/particularmoduleresponse.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/rating_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Particularmoduleservice {
  // Future<Particularmoduleresponse> getParticularModule(
  //     String moduleSlug) async {
  //   var client = http.Client();
  //   dynamic particularmodule;
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString("token");
  //
  //   try {
  //     var response = await client.post(
  //       Uri.parse(api_url2 + 'modules/' + moduleSlug),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Charset': 'utf-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = jsonDecode(jsonString);
  //
  //       // print(response.body);
  //       particularmodule = Particularmoduleresponse.fromJson(jsonMap);
  //     }
  //   } catch (exception) {
  //     return particularmodule;
  //   }
  //
  //   return particularmodule;
  // }

  // Future<Particularmoduleresponse> getParticularModule(
  //     String moduleSlug) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString("token");
  //   final response = await http.post(
  //     Uri.parse(api_url2 + '/modules/$moduleSlug'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //       'Charset': 'utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return Particularmoduleresponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load modules');
  //   }
  // }

  Future<Ratingresponse> fetchRatings(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString("token");
    final response = await http.get(
      Uri.parse(api_url2 + '/ratings/average-rating/' + moduleSlug),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return Ratingresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ');
    }
  }
}
