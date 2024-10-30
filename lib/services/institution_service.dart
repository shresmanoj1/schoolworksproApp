import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/hive_utils.dart';

class InstitutionService {
  Future<InstitutionDetailForIdResponse> getInstitutionDetail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    var model;

    print(api_url2 + '/institutions/find-one');

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/institutions/find-one'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);

      model =
          InstitutionDetailForIdResponse.fromJson(jsonDecode(response.body));

      // box.put("institutions/find-one", jsonDecode(response.body));
      return model;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // model = await box.get("institutions/find-one");
      throw Exception('Failed to load institution detail');
    }
  }

  // Future<InstitutionDetailForIdResponse> getInstitutionDetail() async {
  //   var client = http.Client();
  //   var model;
  //   Box box = HiveUtils.box;
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   try {
  //     var response = await client.get(
  //       Uri.parse(api_url2 + 'institutions/find-one'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         // 'Charset': 'utf-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = jsonDecode(jsonString);
  //
  //       // print(model.body);
  //       await box.put("institutions/find-one", model.body);
  //       model = InstitutionDetailForIdResponse.fromJson(jsonMap);
  //     }
  //   } catch (exception) {
  //     model = await box.get("institutions/find-one");
  //     return model;
  //   }
  //
  //   return model;
  // }
}
