import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturercheckprogress_response.dart';

class MarkCompleteRepository{
  API api = API();
  Future<Commonresponse> markcomplete(data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), '/lecturer-progress/');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<LecturerCheckProgressResponse> checkprogress(String slug) async {
    API api = new API();
    dynamic response;
    LecturerCheckProgressResponse res;
    try {
      response = await api.getWithToken('/lecturer-progress/$slug');

      res = LecturerCheckProgressResponse.fromJson(response);
    } catch (e) {
      res = LecturerCheckProgressResponse.fromJson(response);
    }
    return res;
  }
}