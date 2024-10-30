import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/miscellaneous_repo.dart';
import 'package:schoolworkspro_app/response/lecturer/batch_exam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/get_misc__form_response.dart';
import 'package:schoolworkspro_app/response/lecturer/misc_variable_response.dart';

import '../../../api/api_response.dart';

class MiscellaneousViewModel extends ChangeNotifier {
  ApiResponse _availableExamApiResponse = ApiResponse.initial("Empty Data");

  ApiResponse get availableExamApiResponse => _availableExamApiResponse;
  List<Exam> _availableExams = <Exam>[];

  List<Exam> get availableExams => _availableExams;

  Future<void> fetchExamForBatch(String batch) async {
    _availableExamApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      BatchExamResponse res = await MiscellaneousRepo().getExams(batch);

      if (res.success == true) {
        _availableExams = res.exam!;
        _availableExamApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _availableExamApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _availableExamApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _variableApiResponse = ApiResponse.initial("Empty Data");

  ApiResponse get variableApiResponse => _variableApiResponse;
  List<Variable> _availableVariable = <Variable>[];

  List<Variable> get availableVariable => _availableVariable;

  Future<void> fetchVariable() async {
    _variableApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      MiscVariableResponse res = await MiscellaneousRepo().getVariables();

      if (res.success == true) {
        _availableVariable = res.variables!;
        _variableApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _variableApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _variableApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  // fetch data
  ApiResponse _getMiscDataApiResponse = ApiResponse.initial("Empty Data");

  ApiResponse get getMiscDataApiResponse => _getMiscDataApiResponse;
  List<dynamic> _availableMiscData = <dynamic>[];

  List<dynamic> get availableMiscData => _availableMiscData;

  Future<void> fetchSavedMiscData(String exam) async {
    _getMiscDataApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Map<String, dynamic> res =
          await MiscellaneousRepo().getSavedResults(exam);

      if (res["success"] == true) {
        _availableMiscData = res['result'];
        _getMiscDataApiResponse =
            ApiResponse.completed(res['success'].toString());
        notifyListeners();
      } else {
        _getMiscDataApiResponse = ApiResponse.error(res['success'].toString());
      }
    } catch (e) {
      print(e.toString());
      _variableApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _institutionApiResponse = ApiResponse.initial("Empty Data");

  ApiResponse get institutionApiResponse => _institutionApiResponse;
  dynamic _availableInstitution = [];

  dynamic get availableInstitution => _availableInstitution;

  Future<void> fetchInstitution() async {
    _institutionApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Map<String, dynamic> res =
          await MiscellaneousRepo().getInstitutionDetails();

      if (res["success"] == true) {
        _availableInstitution = res['institution'];

        _institutionApiResponse =
            ApiResponse.completed(res['success'].toString());
        notifyListeners();
      } else {
        _institutionApiResponse = ApiResponse.error(res['success'].toString());
      }
    } catch (e) {
      print(e.toString());
      _institutionApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
