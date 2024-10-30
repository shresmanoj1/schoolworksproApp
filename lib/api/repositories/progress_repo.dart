import 'dart:convert';
import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
import 'package:schoolworkspro_app/response/switchrole_response.dart';

import '../api.dart';

class ProgressRepo {
  API api = API();

  Future<GetProgressForStatsResponse> getProgressReport(String email,String batch) async {
    // print("DATA :: " + data.toString());
    dynamic response =
    await api.getWithToken('/lecturer-progress/mine/$email/$batch');
    // print("RAW RESPONSE :: "+ response.toString());
    GetProgressForStatsResponse res = GetProgressForStatsResponse.fromJson(response);
    return res;
  }
}

