import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/attendance_repository.dart';
import 'package:schoolworkspro_app/response/attendance_editable_response.dart';
import 'package:schoolworkspro_app/response/lecturer/attendance_lecturerresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/check_attendance.dart';
import 'package:schoolworkspro_app/response/lecturer/class_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/classteachergetclass_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudentformarking_response.dart';
import 'package:schoolworkspro_app/response/lecturer/student_filter_leave_response.dart';
import 'package:schoolworkspro_app/response/lecturer/student_leave_response.dart';
import 'package:schoolworkspro_app/response/scanned_document_response.dart';
import 'package:schoolworkspro_app/services/lecturer/get_attendanceservice.dart';

class AttendanceViewModel extends ChangeNotifier {
  ApiResponse _classApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get classApiResponse => _classApiResponse;
  List<String> _classes = <String>[];
  List<String> get classes => _classes;

  Future<void> fetchclass() async {
    _classApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ClassTecherGetClassResponse res = await AttendanceRepository().getClass();
      if (res.success == true) {
        _classes = res.classes!;

        _classApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _classApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _classApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _checkApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get checkApiResponse => _checkApiResponse;
  bool _status = false;
  bool get Status => _status;

  Future<void> checkAttendance(slug, batch, String attendanceType) async {
    _checkApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      CheckAttendanceResponse res = await AttendanceRepository()
          .checkAttendances(slug, batch, attendanceType);
      if (res.success == true) {
        _status = res.attendanceStatus!;

        _checkApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _checkApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _checkApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _classTypeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get classTypeApiResponse => _classTypeApiResponse;
  ClassTypeResponse _classType = ClassTypeResponse();
  ClassTypeResponse get classType => _classType;

  Future<void> fetchClassType(batch, module) async {
    _classTypeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ClassTypeResponse res =
          await AttendanceRepository().getClassType(batch, module);

      if (res.success == true) {
        _classType = res;
        _classTypeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _classTypeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR222222 :: " + e.toString());
      _classTypeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentLeaveApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentLeaveApiResponse => _studentLeaveApiResponse;
  List<StudentLeaf> _studentLeave = <StudentLeaf>[];
  List<StudentLeaf> get studentLeave => _studentLeave;

  Future<void> fetchStudentLeave(data) async {
    _studentLeaveApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentLeaveResponse res =
          await AttendanceRepository().getStudentLeave(data);
      if (res.success == true) {
        _studentLeave = res.studentLeaves!;
        _studentLeaveApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentLeaveApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _studentLeaveApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentFilterLeaveApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get studentFilterLeaveApiResponse =>
      _studentFilterLeaveApiResponse;
  StudentFilterLeaveResponse _studentFilterLeave = StudentFilterLeaveResponse();
  StudentFilterLeaveResponse get studentFilterLeave => _studentFilterLeave;

  Future<void> fetchStudentFilterLeave(data) async {
    _studentFilterLeaveApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentFilterLeaveResponse res =
          await AttendanceRepository().getStudentFilterLeave(data);
      if (res.success == true) {
        _studentFilterLeave = res;
        _studentFilterLeaveApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentFilterLeaveApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _studentFilterLeaveApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentOnlyForAttendanceListApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get studentOnlyForAttendanceListApiResponse =>
      _studentOnlyForAttendanceListApiResponse;
  List<dynamic> _studentOnlyForAttendanceList = <dynamic>[];
  List<dynamic> get studentOnlyForAttendanceList =>
      _studentOnlyForAttendanceList;

  Future<void> fetchStudentOnlyForAttendance(String classSlug) async {
    _studentOnlyForAttendanceListApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetStudentForMarkingResponse res =
          await AttendanceRepository().studentOnlyForAttendance(classSlug);
      if (res.success == true) {
        _studentOnlyForAttendanceList = res.students!;

        _studentOnlyForAttendanceListApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentOnlyForAttendanceListApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _studentOnlyForAttendanceListApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _scannedAttendanceListApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get scannedAttendanceListApiResponse =>
      _scannedAttendanceListApiResponse;
  List<dynamic> _scannedAttendanceList = <dynamic>[];
  List<dynamic> get scannedAttendanceList => _scannedAttendanceList;

  Future<void> fetchScannedAttendance(request) async {
    _scannedAttendanceListApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ScannedAttendanceResponse res =
          await AttendanceRepository().getScannedAttendance(request);
      if (res.success == true) {
        _scannedAttendanceList = res.scannedAttendance!;

        _scannedAttendanceListApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _scannedAttendanceListApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _scannedAttendanceListApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _attendanceEditableApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get attendanceEditableApiResponse =>
      _attendanceEditableApiResponse;
  AttendanceEditableResponse _editableAttendance = AttendanceEditableResponse();
  AttendanceEditableResponse get editableAttendance => _editableAttendance;

  Future<void> checkAttendanceEditable(String id) async {
    _attendanceEditableApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AttendanceEditableResponse res =
          await AttendanceRepository().getCheckAttendanceEditable(id);
      if (res.success == true) {
        _editableAttendance = res;

        _attendanceEditableApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _attendanceEditableApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _attendanceEditableApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
