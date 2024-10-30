import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/admin/getstaff_response.dart';

import '../../../response/payment_details_response.dart';
import '../../../response/principal/drole_response.dart';

class StaffRepository {
  API api = API();
  Future<GetStaffResponse> getstaff() async {
    API api = new API();
    dynamic response;
    GetStaffResponse res;
    try {
      response = await api.getWithToken('/users/staff');

      res = GetStaffResponse.fromJson(response);
    } catch (e) {
      res = GetStaffResponse.fromJson(response);
    }
    return res;
  }

  Future<DRollResponse> getDRoll() async {
    API api = new API();
    dynamic response;
    DRollResponse res;
    try {
      response = await api.getWithToken('/drole/all');

      res = DRollResponse.fromJson(response);
    } catch (e) {
      res = DRollResponse.fromJson(response);
    }
    return res;
  }

  Future<PaymentDetailsResponse> getDailyIncome(data) async {
    API api = new API();
    dynamic response;
    PaymentDetailsResponse res;
    try {
      print("DATA::${data}");
      response = await api.postDataWithToken(data,'/fees/get-daily-income');

      res = PaymentDetailsResponse.fromJson(response);
    } catch (e) {
      res = PaymentDetailsResponse.fromJson(response);
    }
    return res;
  }

  // Future<PaymentDetailsResponse> getDailyIncome(String date) async {
  //   String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhayI6MzQsImlhdCI6MTcxNzczMjE5N30.Iyyv_a5P_EeU16poIqRxD-uBCNcQJeDJWSBIt4ryRfc";
  //   print("https://swpadm.schoolworkspro.com/api/payments/daily-income/$date");
  //   final response = await http.get(
  //     Uri.parse("https://swpadm.schoolworkspro.com/api/payments/daily-income/$date"),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return PaymentDetailsResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load module');
  //   }
  // }
}
