// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:schoolworkspro_app/response/lecturer/allinventory_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/alllogistics_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../api/api.dart';
// import 'package:http/http.dart' as http;
//
// class AllLogisticsInventoryService extends ChangeNotifier {
//   AllInventorysresponse? data;
//   Future getinventory(context) async {
//     var client = http.Client();
//     // var resultModel;
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     String? token = sharedPreferences.getString('token');
//
//     var response = await client.get(
//       Uri.parse(api_url2 + 'inventories/inventory-requests/lecturer/new'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json; charset=utf-8',
//       },
//     );
//     var mJson = jsonDecode(response.body);
//     // print(response.body);
//
//     data = AllInventorysresponse.fromJson(mJson);
//     notifyListeners();
//   }
//
//
// }
