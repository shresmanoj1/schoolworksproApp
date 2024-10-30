import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/routine_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routineservice {
  // Future<Routineresponse> getroutine(String? batch) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + '/routines/' + batch!),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // print(response.body);
  //     return Routineresponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load ');
  //   }
  // }

  // Map<String, dynamic> _map = {};
  // bool _error = false;
  // String _errorMessage = '';

  // Map<String,dynamic> get map => _map;
  // bool get error => _error;
  // String get errorMessage => _errorMessage;

  // Future<void> get fetchRoutine async{
  //     final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   String? token = sharedPreferences.getString('token');
  //   final response = await get(
  //     Uri.parse(api_url2 + 'routines/MBA May 2020'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },);

  //     if(response.statusCode == 200){
  //       try{
  //         _map = jsonDecode(response.body);
  //         _error = false;

  //       }catch(e){
  //         _error = true;
  //         _errorMessage = e.toString();
  //         _map = {};
  //       }

  //     }
  //     else{
  //       _error = true;
  //       _errorMessage= 'Connection error';
  //       _map ={};

  //     }
  //     notifyListeners();
  // }
  // void initialValues() {
  //   _map = {};
  //   _error = false;
  //   _errorMessage='';
  //   notifyListeners();
  // }
}
