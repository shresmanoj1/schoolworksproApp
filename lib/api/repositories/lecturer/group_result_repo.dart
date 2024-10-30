import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_mark_for_slug_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_result_module.dart';
import 'package:schoolworkspro_app/response/lecturer/group_result_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_result_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_result_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_result_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';

import '../../../response/all_result_type_response.dart';
import '../../../response/groupResultStudentMarkResponse.dart';
import '../../../response/group_result_structure_response.dart';
import '../../../response/lecturer/group_result_mark_response.dart';

class GroupResultRepository {
  API api = API();

  Future<GroupResultTypeResponse> getGroupResultType(String moduleSlug) async {
    dynamic response;
    GroupResultTypeResponse res;
    try {
      response = await api.getWithToken("/group-result-type/get-for-module/$moduleSlug");

      res = GroupResultTypeResponse.fromJson(response);
    } catch (e) {
      res = GroupResultTypeResponse.fromJson(response);
    }
    return res;
  }

  Future<GroupResultMarkResponse> getResultMarks(String resultType,String moduleSlug, String batch, String id) async {
    dynamic response;
    GroupResultMarkResponse res;
    try {
      var batch_slug = batch.split(" ").join("%20");
      response = await api.getWithToken("/group-result-marks/$resultType/$moduleSlug/$batch_slug/$id");

      res = GroupResultMarkResponse.fromJson(response);

    } catch (e) {
      res = GroupResultMarkResponse.fromJson(response);
    }
    return res;
  }

  Future<GroupResultModuleResponse> getResultModule(String moduleSlug) async {
    dynamic response;
    GroupResultModuleResponse res;
    try {
      response = await api.getWithToken("/group-result/get-for-module/$moduleSlug");

      res = GroupResultModuleResponse.fromJson(response);
    } catch (e) {
      res = GroupResultModuleResponse.fromJson(response);
    }
    return res;
  }

  Future<GroupMarkForSlugResponse> getMarksForSlug(data) async {
    dynamic response;
    GroupMarkForSlugResponse res;
    try {
      response = await api.postDataWithToken(data,"/marks/get-marks-for-slugs");

      res = GroupMarkForSlugResponse.fromJson(response);
    } catch (e) {
      res = GroupMarkForSlugResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addGroupResultMark(String data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken( data,"/group-result-marks/add");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> updateIndividualMark(String data) async {
    dynamic response;
    Commonresponse res;
    try {
      print("RESULT MARKS:::::${data}");
      response = await api.postDataWithToken( data,"/group-result-marks/update-individual");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> updateAllStudentMark(String data) async {
    dynamic response;
    Commonresponse res;
    try {
      print("RESULT MARKS:::::${data}");
      response = await api.postDataWithToken( data,"/group-result-marks/update-all");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<AllResultTypeResponse> getAllResultType() async {
    dynamic response;
    AllResultTypeResponse res;
    try {
      response = await api.getWithToken("/group-result-type/all-result-type");
      res = AllResultTypeResponse.fromJson(response);
    } catch (e) {
      res = AllResultTypeResponse.fromJson(response);
    }
    return res;
  }

  Future<GroupResultStructureResponse> getGroupResultStructure(String slug) async {
    dynamic response;
    GroupResultStructureResponse res;
    try {
      response = await api.getWithToken("/group-result/all-structure/$slug");
      res = GroupResultStructureResponse.fromJson(response);
    } catch (e) {
      res = GroupResultStructureResponse.fromJson(response);
    }
    return res;
  }

  Future<GroupResultStudentMarkResponse> getGroupResultStudentMark(data) async {
    dynamic response;
    GroupResultStudentMarkResponse res;
    try {
      response = await api.postDataWithToken(json.encode(data) ,"/group-result-marks/student-marks");
      res = GroupResultStudentMarkResponse.fromJson(response);
    } catch (e) {
      res = GroupResultStudentMarkResponse.fromJson(response);
    }
    return res;
  }
}
