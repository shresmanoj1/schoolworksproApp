import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/exam_repo.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/grade_repository.dart';
import 'package:schoolworkspro_app/response/lecturer/getgradesheading_response.dart';
import 'package:schoolworkspro_app/response/showexam_dropdown.dart';

import '../../../../../response/lecturer/view_grades_response.dart';

class GradeViewModel extends ChangeNotifier {
  ApiResponse _headingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get headingApiResponse => _headingApiResponse;
  MarksHeading _heading = new MarksHeading();
  MarksHeading get heading => _heading;

  bool _hasData = false;

  bool get hasData => _hasData;

  Future<void> fetchheadings(String moduleSlug) async {
    _headingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetGradesHeadingResponse res =
          await GradeRepository().getHeadings(moduleSlug);

      if (res.success == true && res.marksHeading != null) {
        _hasData = true;
        _heading = res.marksHeading!;

        _headingApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        print("MARKS:::::" + res.marksHeading.toString());
        _hasData = false;
        _heading = new MarksHeading();
        _headingApiResponse = ApiResponse.error(res.success.toString());
        notifyListeners();
      }
    } catch (e) {
      print("VM CATCH ERR11122 :: " + e.toString());
      _headingApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _marksHeadingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get marksHeadingApiResponse => _marksHeadingApiResponse;
  MarksHeading _marksHeading = new MarksHeading();
  MarksHeading get marksHeading => _marksHeading;

  bool _hasMarksHeading = false;

  bool get hasMarksHeading => _hasMarksHeading;

  Future<void> fetchMarksHeadings(String moduleSlug, String batchSlug, String examType, String institution) async {
    _marksHeadingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetGradesHeadingResponse res =
      await GradeRepository().getMarksHeadings( moduleSlug,  batchSlug,  examType, institution);

      if (res.success == true && res.marksHeading != null) {
        _hasMarksHeading = true;
        _marksHeading = res.marksHeading!;

        _marksHeadingApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        print("MARKS:::::" + res.marksHeading.toString());
        _hasMarksHeading = false;
        _marksHeading = new MarksHeading();
        _marksHeadingApiResponse = ApiResponse.error(res.success.toString());
        notifyListeners();
      }
    } catch (e) {
      print("VM CATCH ERR11122 :: " + e.toString());
      _marksHeadingApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _viewGradeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get viewGradeApiResponse => _viewGradeApiResponse;
  List<ViewGradesResponseMark> _studentGrade = <ViewGradesResponseMark>[];
  List<ViewGradesResponseMark> get studentGrade => _studentGrade;

  bool _hasData2 = false;

  bool get hasData2 => _hasData2;

  Future<void> fetchViewStudentGrade(
      String moduleSlug, String batch, String examSlug, String institution) async {
    _viewGradeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ViewGradesResponse res = await GradeRepository()
          .getviewStudentGrade(moduleSlug, batch, examSlug, institution);
      if (res.success == true) {
        _hasData2 = true;


        _studentGrade = res.marks!;

        _viewGradeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _hasData2 = false;
        _viewGradeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _viewGradeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _examTitleApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examTitleApiResponse => _examTitleApiResponse;
  List<Exam> _exams = <Exam>[];
  List<Exam> get exams => _exams;

  Future<void> fetchexamsfordropdown(String moduleSlug) async {
    _examTitleApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ShowExamsDropDownResponse res =
          await ExamRepository().getExamforDropdown(moduleSlug);

      _exams = res.exams!;
      _examTitleApiResponse = ApiResponse.error(res.success.toString());
      notifyListeners();
    } catch (e) {
      print("VM CATCH ERR11 :: " + e.toString());
      _examTitleApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
