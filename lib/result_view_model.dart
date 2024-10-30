import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/exam_repo.dart';
import 'package:schoolworkspro_app/response/overall_new_result_response.dart';
import 'package:schoolworkspro_app/response/parents/getexam_parent_response.dart';

class ResultViewModel extends ChangeNotifier {
  ApiResponse _resultApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get resultApiResponse => _resultApiResponse;
  List<OverallResult> _overallResult = <OverallResult>[];
  List<OverallResult> get overallResult => _overallResult;

  Future<void> fetchOverAllResult(examSlug) async {
    _resultApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OverallNewResultResponse res =
          await ExamRepository().displayresultToStudent(examSlug);
      if (res.success == true) {
        _overallResult = res.overallResult!;

        _resultApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _resultApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _resultApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _parentResultApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get parentResultApiResponse => _parentResultApiResponse;
  List<OverallResult> _parentResult = <OverallResult>[];
  List<OverallResult> get parentResult => _parentResult;

  ApiResponse _examForParentsResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examForParentsResponse => _examForParentsResponse;
  List<AllExam> _examParents = <AllExam>[];
  List<AllExam> get examParents => _examParents;

  Future<void> fetchExamForParents(username, instituion) async {
    _examForParentsResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetExamParentResponse res =
          await ExamRepository().getExamFromCourseParents(username, instituion);
      if (res.success == true) {
        _examParents = res.allExams!;

        _examForParentsResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _examForParentsResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _examForParentsResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchresultforParent(examSlug, username) async {
    _parentResultApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OverallNewResultResponse res =
          await ExamRepository().displayresultToParent(examSlug, username);
      if (res.success == true) {
        _parentResult = res.overallResult!;

        _parentResultApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _parentResultApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _parentResultApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
