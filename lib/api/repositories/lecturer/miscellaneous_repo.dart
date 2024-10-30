import 'dart:convert';

import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/batch_exam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/get_misc__form_response.dart';
import 'package:schoolworkspro_app/response/lecturer/misc_variable_response.dart';
import 'package:schoolworkspro_app/response/lecturer/misc_variable_response.dart';
import 'package:schoolworkspro_app/response/lecturer/misc_variable_response.dart';
import 'package:schoolworkspro_app/response/lecturer/misc_variable_response.dart';
import '../../api.dart';

class MiscellaneousRepo {
  API api = API();

  Future<BatchExamResponse> getExams(String batch) async {
    dynamic response;
    BatchExamResponse res;
    try {
      response = await api.getWithToken('/exams/batch-exam/$batch');

      res = BatchExamResponse.fromJson(response);
    } catch (e) {
      res = BatchExamResponse.fromJson(response);
    }
    return res;
  }

  Future<MiscVariableResponse> getVariables() async {
    dynamic response;
    MiscVariableResponse res;
    try {
      response = await api.getWithToken('/builder/get-variables-new');

      res = MiscVariableResponse.fromJson(response);
    } catch (e) {
      res = MiscVariableResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> saveResultMisc(Map<String, dynamic> data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/marks/save-result-misc');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Map<String, dynamic>> getSavedResults(String exam) async {
    dynamic response;
    Map<String, dynamic> res;
    try {
      response = await api.getWithToken('/marks/get-result-misc/$exam');

      res = response;
    } catch (e) {
      res = response;
    }
    return res;
  }

  Future<Map<String, dynamic>> getInstitutionDetails() async {
    dynamic response;
    Map<String, dynamic> res;
    try {
      response = await api.getWithToken('/institutions/find-one');

      res = response;
    } catch (e) {
      res = response;
    }
    return res;
  }
}
