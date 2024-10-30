import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/institution_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/modules_repository.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:schoolworkspro_app/request/lecturer/get_modulerequest.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IDCardLecturerViewModel extends ChangeNotifier {
  final SharedPreferences localStorage = PreferenceUtils.instance;

  ApiResponse _institutionApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get institutionApiResponse => _institutionApiResponse;
  dynamic _institution;
  dynamic get institution => _institution;

  Future<void> fetchInstitution() async {
    _institutionApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      InstitutionDetailForIdResponse res =
          await InstitutionRepository().getinstitution();
      if (res.success == true) {
        _institution = res.institution;

        _institutionApiResponse = ApiResponse.completed(res.success.toString());
      } else {
        _institutionApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _institutionApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
