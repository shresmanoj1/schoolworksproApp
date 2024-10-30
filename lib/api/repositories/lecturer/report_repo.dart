import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerstudentreport_response.dart';

class ReportRepo {
  API api = API();
  Future<LecturerStudentReportResponse> getStudentReport(data, batch) async {
    API api = new API();
    dynamic response;
    LecturerStudentReportResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/tracking/search/new?query=&batch=$batch');

      res = LecturerStudentReportResponse.fromJson(response);
    } catch (e) {
      res = LecturerStudentReportResponse.fromJson(response);
    }
    return res;
  }
}
