import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/inventory_request.dart';
import 'package:schoolworkspro_app/response/addinventory_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Addinventoryservice {
  Future<Addinventoryresponse> addInventoryRequest(
      InventoryRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse('$api_url2/inventories/newrequests/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addinventoryresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Addinventoryresponse(
              inventory: null,
              success: false,
              message: "Some Error Has Occured");
        }
      }).catchError((e) {
        return Addinventoryresponse(
            inventory: null, success: false, message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      return Addinventoryresponse(
          inventory: null, success: false, message: "Some Error Has Occured");
    } on HttpException {
      return Addinventoryresponse(
          inventory: null, success: false, message: "Some Error Has Occured");
    } on FormatException {
      return Addinventoryresponse(
          inventory: null, success: false, message: "Some Error Has Occured");
    }
  }
}
