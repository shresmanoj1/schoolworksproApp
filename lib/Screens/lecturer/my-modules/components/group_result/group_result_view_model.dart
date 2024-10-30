import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/groupResultStudentMarkResponse.dart';
import 'package:schoolworkspro_app/response/group_result_structure_response.dart';
import 'package:schoolworkspro_app/response/lecturer/group_mark_for_slug_response.dart';

import '../../../../../api/api_response.dart';
import '../../../../../api/repositories/lecturer/group_result_repo.dart';
import '../../../../../response/all_result_type_response.dart';
import '../../../../../response/lecturer/group_result_mark_response.dart';
import '../../../../../response/lecturer/group_result_module.dart';
import '../../../../../response/lecturer/group_result_type_response.dart';


class GroupResultViewModel extends ChangeNotifier {
  ApiResponse _groupResultTypeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupResultTypeApiResponse => _groupResultTypeApiResponse;
  GroupResultTypeResponse _groupResultType = GroupResultTypeResponse();
  GroupResultTypeResponse get groupResultType => _groupResultType;

  Future<void> fetchGroupResultType(String moduleSlug) async {
    _groupResultTypeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupResultTypeResponse res = await GroupResultRepository().getGroupResultType(moduleSlug);
      if (res.success == true) {
        _groupResultType = res;
        _groupResultTypeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupResultTypeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _groupResultTypeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _groupResultMarksApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupResultMarksApiResponse => _groupResultMarksApiResponse;
  GroupResultMarkResponse _groupResultMarks = GroupResultMarkResponse();
  GroupResultMarkResponse get groupResultMarks => _groupResultMarks;

  Future<void> fetchGroupResultMarks(String resultType,   String moduleSlug,   String batch,   String id) async {
    _groupResultMarksApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupResultMarkResponse res = await GroupResultRepository().getResultMarks(resultType, moduleSlug, batch, id);
      if (res.success == true) {
        _groupResultMarks = res;
        _groupResultMarksApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupResultMarksApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _groupResultMarksApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _groupResultModuleApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupResultModuleApiResponse => _groupResultModuleApiResponse;
  GroupResultModuleResponse _groupResultModule = GroupResultModuleResponse();
  GroupResultModuleResponse get groupResultModule => _groupResultModule;

  Future<void> fetchGroupResultModules(String moduleSlug) async {
    _groupResultModuleApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupResultModuleResponse res = await GroupResultRepository().getResultModule(moduleSlug);
      if (res.success == true) {
        _groupResultModule = res;
        _groupResultModuleApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupResultModuleApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR R :: " + e.toString());
      _groupResultModuleApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _groupMarksForSlugApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupMarksForSlugApiResponse => _groupMarksForSlugApiResponse;
  GroupMarkForSlugResponse _groupMarksForSlug = GroupMarkForSlugResponse();
  GroupMarkForSlugResponse get groupMarksForSlug => _groupMarksForSlug;

  Future<void> fetchGroupMarksForSlug(data) async {
    _groupMarksForSlugApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupMarkForSlugResponse res = await GroupResultRepository().getMarksForSlug(data);
      if (res.success == true) {
        _groupMarksForSlug = res;
        _groupMarksForSlugApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupMarksForSlugApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _groupMarksForSlugApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allResultTypeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allResultTypeApiResponse => _allResultTypeApiResponse;
  AllResultTypeResponse _allResultType = AllResultTypeResponse();
  AllResultTypeResponse get allResultType => _allResultType;

  Future<void> fetchAllResultType() async {
    _allResultTypeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AllResultTypeResponse res = await GroupResultRepository().getAllResultType();
      if (res.success == "true") {
        _allResultType = res;
        _allResultTypeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allResultTypeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allResultTypeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _groupResultStructureApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupResultStructureApiResponse => _groupResultStructureApiResponse;
  GroupResultStructureResponse _groupResultStructure = GroupResultStructureResponse();
  GroupResultStructureResponse get groupResultStructure => _groupResultStructure;

  Future<void> fetchGroupResultStructure(String slug) async {
    _groupResultStructureApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupResultStructureResponse res = await GroupResultRepository().getGroupResultStructure(slug);
      if (res.success == true) {
        _groupResultStructure = res;
        _groupResultStructureApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupResultStructureApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _groupResultStructureApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _groupResultStudentMarkApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get groupResultStudentMarkApiResponse => _groupResultStudentMarkApiResponse;
  GroupResultStudentMarkResponse _groupResultStudentMark = GroupResultStudentMarkResponse();
  GroupResultStudentMarkResponse get groupResultStudentMark => _groupResultStudentMark;

  Future<void> fetchGroupResultStudentMark(data) async {
    _groupResultStudentMarkApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GroupResultStudentMarkResponse res = await GroupResultRepository().getGroupResultStudentMark(data);
      if (res.success == true) {
        _groupResultStudentMark = res;
        _groupResultStudentMarkApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _groupResultStudentMarkApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR1 :: " + e.toString());
      _groupResultStudentMarkApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
