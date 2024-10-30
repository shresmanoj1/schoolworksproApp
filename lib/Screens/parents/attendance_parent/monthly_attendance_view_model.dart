import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/attendance/monthly_attendance_repo.dart';
import 'package:schoolworkspro_app/response/monthly_onetimeattendance_response.dart';

import '../../../response/attendancedetail_response.dart';
import '../../../response/overall_attendance_response.dart';

class MonthlyAttendanceViewModel extends ChangeNotifier {
  ApiResponse reportApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get resultApiResponse => reportApiResponse;
  List<Datum> _overallResult = <Datum>[];
  List<Datum> get overallResult => _overallResult;

  Future<void> fetchMonthlyReport(data) async {
    reportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OneTimeAttendanceMonthlyResponse res =
          await MonthlyAttendanceRepo().getReport(data);
      if (res.success == true) {
        _overallResult = res.data!;

        reportApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        reportApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      reportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentAbsentReportApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentAbsentReportApiResponse => _studentAbsentReportApiResponse;
  AttendanceDetailResponse _absentReport = AttendanceDetailResponse();
  AttendanceDetailResponse get absentReport => _absentReport;

  Future<void> fetchAbsentReport(String username,data) async {
    _studentAbsentReportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AttendanceDetailResponse res = await MonthlyAttendanceRepo().getAttendanceReport(username ,data);
      if (res.success == true) {
        _absentReport = res;

        _studentAbsentReportApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentAbsentReportApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _studentAbsentReportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _overallAttendanceReportApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get overallAttendanceReportApiResponse => _overallAttendanceReportApiResponse;
  OverallAttendanceResponse _overallAttendance = OverallAttendanceResponse();
  OverallAttendanceResponse get overallAttendance => _overallAttendance;

  Future<void> fetchOverallAttendanceReport(data) async {
    _overallAttendanceReportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OverallAttendanceResponse res = await MonthlyAttendanceRepo().getOverallAttendanceReport(data);
      if (res.success == true) {
        _overallAttendance = res;

        _overallAttendanceReportApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _overallAttendanceReportApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _overallAttendanceReportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
