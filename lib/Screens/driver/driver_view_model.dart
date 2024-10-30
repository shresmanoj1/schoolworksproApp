import 'package:flutter/material.dart';

import '../../api/api_response.dart';
import '../../response/driver/getbus_response.dart';
import '../../response/driver/getlstudentist_bus.dart';
import '../../services/driver/getbus_service.dart';

class DriverViewModel extends ChangeNotifier {
  ApiResponse _busListApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get busListApiResponse => _busListApiResponse;
  GetBusResponse _busList = GetBusResponse();
  GetBusResponse get busList => _busList;

  Future<void> fetchBusList() async {
    _busListApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBusResponse res = await BusService().getBusList();

      if (res.success == true) {
        _busList = res;
        _busListApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _busListApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _busListApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentListApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentListApiResponse => _studentListApiResponse;
  StudentBusListResponse _studentList = StudentBusListResponse();
  StudentBusListResponse get studentList => _studentList;

  Future<void> fetchBusStudent(String id) async {
    _studentListApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentBusListResponse res = await BusService().getBusStudentList(id);

      if (res.success == true) {
        _studentList = res;
        _studentListApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentListApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _studentListApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
