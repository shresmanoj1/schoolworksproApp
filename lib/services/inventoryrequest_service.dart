import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/viewinventoryrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewInventoryRequestService extends ChangeNotifier {
  Future<Viewinventoryrequestresponse> getMyInventoryRequest() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http.get(
        Uri.parse('$api_url2/inventories/student/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).then((data) {
        if (data.statusCode == 200) {
          final response =
              Viewinventoryrequestresponse.fromJson(jsonDecode(data.body));
          // print(response.module.moduleLeader);
          return response;
        } else {
          return Viewinventoryrequestresponse(
              success: false, inventoryReq: null);
        }
      }).catchError((e) {
        return Viewinventoryrequestresponse(success: false, inventoryReq: null);
      });
    } on SocketException catch (e) {
      return Viewinventoryrequestresponse(
        success: false,
        inventoryReq: null,
      );
    } on HttpException {
      return Viewinventoryrequestresponse(success: false, inventoryReq: null);
    } on FormatException {
      return Viewinventoryrequestresponse(success: false, inventoryReq: null);
    }
  }
}
