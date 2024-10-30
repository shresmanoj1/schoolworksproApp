import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/insideactivity_response.dart';
import 'package:schoolworkspro_app/response/lecturer/submissionstats_response.dart';

import '../../../response/lecturer/assessmentstats_response.dart';
import '../../../response/submission_check_respose.dart';

class AssessmentStatsRepository{
  Future<AssessmentStatsResponse> getassessmentStats(data) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    AssessmentStatsResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), Endpoints.assessmentStats);


      res = AssessmentStatsResponse.fromJson(response);
    } catch (e) {
      res = AssessmentStatsResponse.fromJson(response);
    }
    return res;
  }


  Future<AssessmentStatsResponse> getsubmissionstats2(data) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    AssessmentStatsResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), Endpoints.assessmentStats);

      res = AssessmentStatsResponse.fromJson(response);
    } catch (e) {
      res = AssessmentStatsResponse.fromJson(response);
    }
    return res;
  }

  Future<SubmissionStatsResponse> getSubmissionstats(String id, String batch) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    SubmissionStatsResponse res;
    try {
      response = await api.getWithToken("/assessments/all-submissions/$id/$batch");

      res = SubmissionStatsResponse.fromJson(response);
    } catch (e) {
      res = SubmissionStatsResponse.fromJson(response);
    }
    return res;
  }

  Future<SubmissionCheckResponse> getSubmissionCheckStudent(String id, String batch) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    SubmissionCheckResponse res;
    try {
      response = await api.getWithToken("/submissionCheck/$id/$batch");

      res = SubmissionCheckResponse.fromJson(response);
    } catch (e) {
      res = SubmissionCheckResponse.fromJson(response);
    }
    return res;
  }


  Future<InsideActivityResponse> getinsideactivity(String lessonSlug) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    InsideActivityResponse res;
    try {
      response = await api.getWithToken("/assessments/$lessonSlug");

      res = InsideActivityResponse.fromJson(response);
    } catch (e) {
      res = InsideActivityResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addFeedback(String feedback,String id) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    Commonresponse res;
    try {
      String data = jsonEncode({"feedback": feedback});
      response = await api.putDataWithToken(data, "/submissions/add/feedback/$id");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

}