import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/response/paymentmethod_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodService {
  // Future<Paymentmethodresponse> getpaymentMethod() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + 'paymentmethod'),
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
  //     return Paymentmethodresponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load payment method');
  //   }
  // }

  Future<Paymentmethodresponse> getpaymentMethod(
      Institutionrequest institution) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/paymentmethod'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(institution))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              Paymentmethodresponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Paymentmethodresponse(
              success: false, message: null, payment: null);
        } else {
          return Paymentmethodresponse(
              success: false, message: null, payment: null);
        }
      }).catchError((e) {
        return Paymentmethodresponse(
            success: false, message: null, payment: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Paymentmethodresponse(
          success: false, message: null, payment: null);
    } on HttpException {
      return Paymentmethodresponse(
          success: false, message: null, payment: null);
    } on FormatException {
      return Paymentmethodresponse(
          success: false, message: null, payment: null);
    }
  }
}
