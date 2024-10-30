import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/services/fees_service.dart';
import '../../../response/addproject_response.dart';
import '../../../response/parents/getfessparent_response.dart';

class FeesViewModel with ChangeNotifier {
  ApiResponse _dueDateStartApiResponse = ApiResponse.initial('Empty data');
  Addprojectresponse _dueDateStartData = Addprojectresponse();
  Addprojectresponse get dueDateStartData => _dueDateStartData;
  ApiResponse get dueDateStartApiResponse => _dueDateStartApiResponse;

  Future<void> getDueDateStartFuc(String institution) async {
    _dueDateStartApiResponse = ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      Addprojectresponse data = await FeeService().dueDataStart(institution);
      _dueDateStartData = data;

      _dueDateStartApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _dueDateStartApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }

  ApiResponse _dueDateFinishApiResponse = ApiResponse.initial('Empty data');
  GetFeesResponse _dueDateFinish = GetFeesResponse();
  GetFeesResponse get dueDateFinish => _dueDateFinish;
  ApiResponse get dueDateFinishApiResponse => _dueDateFinishApiResponse;

  Future<void> getDueDateFinishFuc(String institution) async {
    _dueDateFinishApiResponse = ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      GetFeesResponse data = await FeeService().dueDataFinish(institution);
      _dueDateFinish = data;

      _dueDateFinishApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _dueDateFinishApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }

  ApiResponse _transactionDateStartApiResponse =
      ApiResponse.initial('Empty data');
  Addprojectresponse _transactionDateStart = Addprojectresponse();
  Addprojectresponse get transactionDateStart => _transactionDateStart;
  ApiResponse get transactionDateStartApiResponse =>
      _transactionDateStartApiResponse;

  Future<void> getTransactionDateStart(String institution) async {
    _transactionDateStartApiResponse =
        ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      Addprojectresponse data = await FeeService().transactionDateStart(institution);
      _transactionDateStart = data;

      _transactionDateStartApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _transactionDateStartApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }

  ApiResponse _transactionDateFinishApiResponse =
  ApiResponse.initial('Empty data');
  GetFeesResponse _transactionDateFinish = GetFeesResponse();
  GetFeesResponse get transactionDateFinish => _transactionDateFinish;
  ApiResponse get transactionDateFinishApiResponse =>
      _transactionDateFinishApiResponse;

  Future<void> getTransactionDateFinish(String institution) async {
    _transactionDateFinishApiResponse =
        ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      GetFeesResponse data = await FeeService().transactionDaeFinish(institution);
      _transactionDateFinish = data;

      _transactionDateFinishApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _transactionDateFinishApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }
}
