import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/attendance_leave_type_response.dart';
import 'package:schoolworkspro_app/response/lecturer/check_attendance.dart';
import 'package:schoolworkspro_app/response/lecturer/classteachergetclass_response.dart';
import 'package:schoolworkspro_app/response/lecturer/student_filter_leave_response.dart';
import 'package:schoolworkspro_app/response/lecturer/student_leave_response.dart';

import '../../../response/attendance_editable_response.dart';
import '../../../response/common_response.dart';
import '../../../response/encrypt_student_qr_response.dart';
import '../../../response/lecturer/class_type_response.dart';
import '../../../response/lecturer/getstudentformarking_response.dart';
import '../../../response/lecturer/leave_response.dart';
import '../../../response/scanned_document_response.dart';

class AttendanceRepository {
  API api = API();
  Future<ClassTecherGetClassResponse> getClass() async {
    API api = new API();
    dynamic response;
    ClassTecherGetClassResponse res;
    try {
      response = await api.getWithToken('/lecturers/get-classes');

      res = ClassTecherGetClassResponse.fromJson(response);
    } catch (e) {
      res = ClassTecherGetClassResponse.fromJson(response);
    }
    return res;
  }

  // attendance/checkAttended/$moduleSlug/$batch

  Future<CheckAttendanceResponse> checkAttendances(moduleSlug, batch, attendanceType) async {
    dynamic response;
    CheckAttendanceResponse res;
    String type = jsonEncode({"attendanceType": attendanceType });
    print("TYPE::::::${type}");
    try {
      var batch_slug = batch.split(" ").join("%20");
      response = await api
          .postDataWithToken(type, '/attendance/checkAttended/$moduleSlug/$batch_slug');

      res = CheckAttendanceResponse.fromJson(response);
    } catch (e) {
      res = CheckAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<LeaveTypeResponse> AttendanceleaveType() async {
    dynamic response;
    LeaveTypeResponse res;
    try {
      // var batch_slug = batch.split(" ").join("%20");
      response = await api
          .getWithToken('/leavecategory/get-leave/');

      res = LeaveTypeResponse.fromJson(response);
    } catch (e) {
      res = LeaveTypeResponse.fromJson(response);
    }
    return res;
  }

  Future<ClassTypeResponse> getClassType(String module, String batch) async {
    dynamic response;
    ClassTypeResponse res;
    try {
      response = await api.getWithToken('/routines/today-class-types/$module/$batch');

      res = ClassTypeResponse.fromJson(response);
    } catch (e) {
      res = ClassTypeResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postQrAttendance(String data) async {
    print("helloo::::::::");
    API api = new API();
    dynamic response;
    Commonresponse res;

    print("DATA:::::$data");

    try {
      response = await api.postDataWithToken(data ,'/student-attendance');

      print(response);

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postAllDayStudentQrAttendance(String data) async {
    print("helloo::::::::");
    API api = new API();
    dynamic response;
    Commonresponse res;

    print("DATA:::::$data");

    try {
      response = await api.postDataWithToken(data ,'/student-attendance/new');

      print(response);

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<StudentLeaveResponse> getStudentLeave(data) async {
    dynamic response;
    StudentLeaveResponse res;
    try {
      print("REQUEST:::::${data}");
      response = await api.postDataWithToken(data ,'/leaves/students');

      res = StudentLeaveResponse.fromJson(response);
    } catch (e) {
      res = StudentLeaveResponse.fromJson(response);
    }
    return res;
  }

  Future<StudentFilterLeaveResponse> getStudentFilterLeave(data) async {
    dynamic response;
    StudentFilterLeaveResponse res;
    try {
      print("REQUEST:::::${data}");
      response = await api.postDataWithToken(data ,'/leaves/filter/students');

      res = StudentFilterLeaveResponse.fromJson(response);
    } catch (e) {
      res = StudentFilterLeaveResponse.fromJson(response);
    }
    return res;
  }

  Future<EncryptStudentQrResponse> postEncryptStudentQr(data) async {
    print("helloo::::::::");
    API api = new API();
    dynamic response;
    EncryptStudentQrResponse res;

    print(data);

    try {
      response = await api.postDataWithToken(data ,'/student-attendance/generate-qr');

      print(response);

      res = EncryptStudentQrResponse.fromJson(response);
    } catch (e) {
      res = EncryptStudentQrResponse.fromJson(response);
    }
    return res;
  }

  Future<GetStudentForMarkingResponse> studentOnlyForAttendance(String classSlug) async {
    dynamic response;
    GetStudentForMarkingResponse res;
    try {
      response = await api.getWithToken('/batch/$classSlug/student-for-attendance');

      res = GetStudentForMarkingResponse.fromJson(response);
    } catch (e) {
      res = GetStudentForMarkingResponse.fromJson(response);
    }
    return res;
  }

  Future<AttendanceEditableResponse> getCheckAttendanceEditable(String id) async {
    API api = new API();
    dynamic response;
    AttendanceEditableResponse res;
    try {
      response = await api.putDataWithToken(null,'/attendance/check-editable/$id');

      res = AttendanceEditableResponse.fromJson(response);
    } catch (e) {
      res = AttendanceEditableResponse.fromJson(response);
    }
    return res;
  }

  Future<ScannedAttendanceResponse> getScannedAttendance(request) async {
    API api = new API();
    dynamic response;
    ScannedAttendanceResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(request),'/attendance/scanned-attendance');

      res = ScannedAttendanceResponse.fromJson(response);
    } catch (e) {
      res = ScannedAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<LeaveResponse> getLecturerLeaveReport(String username) async {
    API api = new API();
    dynamic response;
    LeaveResponse res;
    try {
      response = await api.getWithToken('/leaves/$username');

      res = LeaveResponse.fromJson(response);
    } catch (e) {
      res = LeaveResponse.fromJson(response);
    }
    return res;
  }
}
