import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/request/DateRequest.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/batch_repository.dart';
import 'package:schoolworkspro_app/api/repositories/principal/advisor_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/attendance_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/course_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/leave_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/module_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/routine_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/staff_repo.dart';
import 'package:schoolworkspro_app/response/admin/getstaff_response.dart';
import 'package:schoolworkspro_app/response/allclassroom_response.dart';
import 'package:schoolworkspro_app/response/alllecturer_response.dart';
import 'package:schoolworkspro_app/response/course_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:schoolworkspro_app/response/principal/approvedleave_response.dart';
import 'package:schoolworkspro_app/response/principal/attendancereport_response.dart';
import 'package:schoolworkspro_app/response/principal/getadvisors_response.dart';
import 'package:schoolworkspro_app/response/principal/getallmodule_response.dart';
import 'package:schoolworkspro_app/response/principal/getleaveprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/staffattendanceprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/student_logs_screen.dart';
import '../../api/repositories/principal/assign_to_staff_repo.dart';
import '../../api/repositories/user_repository.dart';
import '../../response/lecturer/batchpercourse_response.dart';
import '../../response/lecturer/staff_type_response.dart';
import '../../response/payment_details_response.dart';
import '../../response/principal/accessed_modules_response.dart';
import '../../response/principal/allattendanceprincipal_response.dart';
import '../../response/principal/assign_to_response.dart';
import '../../response/principal/batch_wise_attendance_response.dart';
import '../../response/principal/drole_response.dart';
import '../../response/principal/student_daily_attendance_response.dart';

class PrinicpalCommonViewModel extends ChangeNotifier {
  ApiResponse _statsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get statsApiResponse => _statsApiResponse;
  int _totalAttendance = 0;
  int _totalPresent = 0;
  int _totalStudents = 0;
  int _remainingAttendance = 0;
  List<Attendance> _attendances = <Attendance>[];
  List<Attendance> get attendances => _attendances;

  List<AttendanceTaken> _attendanceTaken = <AttendanceTaken>[];
  List<AttendanceTaken> get attendanceTaken => _attendanceTaken;

  List<AttendanceNotTaken> _attendanceNotTaken = <AttendanceNotTaken>[];
  List<AttendanceNotTaken> get attendanceNotTaken => _attendanceNotTaken;

  int get totalAttendance => _totalAttendance;
  int get totalPresent => _totalPresent;
  int get totalStudents => _totalStudents;
  int get remainingAttendance => _remainingAttendance;

  Future<void> fetchdailystats() async {
    _statsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AttendanceReportforPrincipalResponse res =
          await AttendanceRepository().getstudentattendancedaily();
      if (res.success == true) {
        _totalAttendance = res.totalAttendance!.toInt();
        _totalPresent = res.totalPresent!.toInt();
        _totalStudents = res.totalStudents!.toInt();
        _remainingAttendance = res.remainingAttendance!.toInt();
        _attendances = res.attendances!;
        _attendanceTaken = res.attendanceTaken!;
        _attendanceNotTaken = res.attendanceNotTaken!;

        _statsApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _statsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _statsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _modulesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get modulesApiResponse => _modulesApiResponse;
  List<Module> _modules = <Module>[];
  List<Module> get modules => _modules;

  Future<void> fetchAllModules() async {
    _modulesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllModulesPrincipalResponse res =
          await ModuleRepositoryPrincipal().getAllModules();
      if (res.success == true) {
        _modules = res.modules!;

        _modulesApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _modulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _modulesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _assignedBatchesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignedBatchesApiResponse => _assignedBatchesApiResponse;
  List<String> _assignedBatches = <String>[];
  List<String> get assignedBatches => _assignedBatches;

  Future<void> fetchAssignedModules(String slug) async {
    _assignedBatchesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBatchResponse res =
          await ModuleRepositoryPrincipal().getassignedbatches(slug);
      if (res.success == true) {
        _assignedBatches = res.batcharr!;

        _assignedBatchesApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignedBatchesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _assignedBatchesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allAttendanceApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allAttendanceApiResponse => _allAttendanceApiResponse;
  List<AllAttendance> _allAttendance = <AllAttendance>[];
  List<AllAttendance> get allAttendance => _allAttendance;

  Future<void> fetchallattendance(data) async {
    _allAttendanceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllAttendancePrincipalResponse res =
          await AttendanceRepository().getAllAttendance(data);
      if (res.success == true) {
        _allAttendance = res.allAttendance!;

        _allAttendanceApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allAttendanceApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allAttendanceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allAttendancestaffsApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get allAttendancestaffsApiResponse =>
      _allAttendancestaffsApiResponse;
  List<AttendanceDatum> _attendanceStaff = <AttendanceDatum>[];
  List<AttendanceDatum> get attendanceStaff => _attendanceStaff;
  int _presentCount = 0;
  int get presentCount => _presentCount;

  Future<void> fetchallattendanceforstaffs(DateRequest data) async {
    _allAttendancestaffsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StaffAttendancePrincipalResponse res =
          await AttendanceRepository().getAllAttendanceforstaffs(data);
      if (res.success == true) {
        _attendanceStaff = res.attendanceData!;
        for (int i = 0; i < _attendanceStaff.length; i++) {
          if (_attendanceStaff[i].attendance == 1) {
            _presentCount = presentCount + 1;
          }
        }

        _allAttendancestaffsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allAttendancestaffsApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allAttendancestaffsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _leavetypeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get leavetypeApiResponse => _leavetypeApiResponse;
  List<Leave> _leavetype = <Leave>[];
  List<Leave> get leavetype => _leavetype;

  Future<void> fetchleaveType() async {
    _leavetypeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetLeavePrincipalResponse res = await LeaveRepository().getleavetype();
      if (res.success == true) {
        _leavetype = res.leave!;
        _leavetypeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _leavetypeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _leavetypeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _approvedLeaveApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get approvedLeaveApiResponse => _approvedLeaveApiResponse;
  List<Leaf> _approvedLeave = <Leaf>[];
  List<Leaf> get approvedLeave => _approvedLeave;

  Future<void> fetchApprovedLeaves() async {
    _approvedLeaveApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ApprovedLeaveResponse res = await LeaveRepository().getApprovedleave();
      if (res.success == true) {
        _approvedLeave = res.leaves!;

        _approvedLeaveApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _approvedLeaveApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _approvedLeaveApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _advisorApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get advisorApiResponse => _advisorApiResponse;
  List<Advisor> _advisor = <Advisor>[];
  List<Advisor> get advisor => _advisor;

  Future<void> fetchadvisor() async {
    _advisorApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAdvisorResponse res = await AdvisorRepository().getAdvisor();
      if (res.success == true) {
        _advisor = res.advisor!;

        _advisorApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _advisorApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _advisorApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _courseApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get courseApiResponse => _courseApiResponse;
  List<Course> _courses = <Course>[];
  List<Course> get courses => _courses;

  Future<void> fetchCourses() async {
    _courseApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      CourseResponse res = await CourseRepository().getCourse();
      if (res.success == true) {
        _courses = res.courses!;

        _courseApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _courseApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _courseApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _staffApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get staffApiResponse => _staffApiResponse;
  List<dynamic> _staffs = <Course>[];
  List<dynamic> get staffs => _staffs;

  Future<void> fetchstaffs() async {
    _staffApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetStaffResponse res = await StaffRepository().getstaff();
      if (res.success == true) {
        _staffs = res.users!;

        _staffApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _staffApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _staffApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _dRollApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get dRollApiResponse => _dRollApiResponse;
  List<dynamic> _dRolls = <Course>[];
  List<dynamic> get dRolls => _dRolls;

  Future<void> fetchDRolls() async {
    _dRollApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      DRollResponse res = await StaffRepository().getDRoll();
      if (res.success == true) {
        _dRolls = res.droles!;

        _dRollApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _dRollApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _dRollApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allteacherApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allteacherApiResponse => _allteacherApiResponse;
  List<Lecturer> _allteacher = <Lecturer>[];
  List<Lecturer> get allteacher => _allteacher;

  Future<void> fetchallteacher() async {
    _allteacherApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllLecturerResponse res = await RoutineRepository().getallteacher();
      if (res.success == true) {
        _allteacher = res.lecturers!;

        _allteacherApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allteacherApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allteacherApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allroomApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allroomApiResponse => _allroomApiResponse;
  List<String> _allroom = <String>[];
  List<String> get allroom => _allroom;

  Future<void> fetchallclass(data) async {
    _allroomApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllClassRoomResponse res =
          await RoutineRepository().getallclassroom(data);
      if (res.success == true) {
        _allroom = res.classrooms!;

        _allroomApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allroomApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allroomApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _assignToApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignToApiResponse => _assignToApiResponse;
  List<Staff> _staff = <Staff>[];
  List<Staff> get staff => _staff;

  Future<void> fetchAssignedToStaff() async {
    _assignToApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignToResponse res = await AssignedToStaffRepository().getStaff();
      if (res.success == true) {
        _staff = res.staff!;

        _assignToApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignToApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _assignToApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentAttendanceStatsApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get studentAttendanceStatsApiResponse =>
      _studentAttendanceStatsApiResponse;

  AttendanceReportforPrincipalResponse _studentAttendance =
      AttendanceReportforPrincipalResponse();
  AttendanceReportforPrincipalResponse get studentAttendance =>
      _studentAttendance;

  Future<void> fetchStudentDailyAttendanceCount() async {
    _studentAttendanceStatsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AttendanceReportforPrincipalResponse res =
          await AttendanceRepository().getStudentOneTimeAttendanceDaily();
      if (res.success == true) {
        _studentAttendance = res;

        _studentAttendanceStatsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentAttendanceStatsApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRrrrRRR :: " + e.toString());
      _studentAttendanceStatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _absentStudentsReportApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get absentStudentsReportApiResponse =>
      _absentStudentsReportApiResponse;

  StudentDailyAttendanceResponse _absentStudents =
      StudentDailyAttendanceResponse();
  StudentDailyAttendanceResponse get absentStudents => _absentStudents;

  List<dynamic> _allAbsentStudents = <dynamic>[];
  List<dynamic> get allAbsentStudents => _allAbsentStudents;

  List<dynamic> _allDailePresentStudentStudents = <dynamic>[];
  List<dynamic> get allDailePresentStudentStudents => _allDailePresentStudentStudents;

  Future<void> fetchAbsentStudentDailyAttendance(String date, String batch, String course, String module) async {
    _absentStudentsReportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentDailyAttendanceResponse res = await AttendanceRepository()
          .getAbsentStudentDailyAttendanceReport(date, batch, course, module);
      if (res.success == true) {
        _absentStudents = res;
        _allAbsentStudents.clear();
        _allDailePresentStudentStudents.clear();

        for (var dailyAttendance in res.dailyStdAttendance) {
          _allAbsentStudents.addAll(
            dailyAttendance["absentStudents"]?.map((student) => {
              "full_name": student["firstname"] + " " + student["lastname"],
              "course": student["course"],
              "username": student["username"],
              "batch": dailyAttendance["batch"],
              "status": "Absent",
              "moduleData": {
                "moduleTitle": dailyAttendance["moduleData"]["moduleTitle"],
                "alias": dailyAttendance["moduleData"]["alias"],
              }
            }).toList() ??
                [],
          );

          _allDailePresentStudentStudents.addAll(
            dailyAttendance["presentStudents"]?.map((student) => {
              "full_name": student["firstname"] + " " + student["lastname"],
              "course": student["course"],
              "username": student["username"],
              "batch": dailyAttendance["batch"],
              "status": "Present",
              "moduleData": {
                "moduleTitle": dailyAttendance["moduleData"]["moduleTitle"],
                "alias": dailyAttendance["moduleData"]["alias"],
              }
            }).toList() ??
                [],
          );
        }

        _absentStudentsReportApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _absentStudentsReportApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRRRR :: $e");
      _absentStudentsReportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _courseBatchApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get courseBatchApiResponse => _courseBatchApiResponse;
  BatchpercourseResponse _courseBatch = BatchpercourseResponse();
  BatchpercourseResponse get courseBatch => _courseBatch;

  Future<void> fetchCourseBatch(String courseSlug) async {
    _courseBatchApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      BatchpercourseResponse res =
          await BatchRepository().getCourseBatch(courseSlug);
      if (res.success == true) {
        _courseBatch = res;
        _courseBatchApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _courseBatchApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _courseBatchApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allBatchAttendanceApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get allBatchAttendanceApiResponse =>
      _allBatchAttendanceApiResponse;
  BatchWiseAttendanceResponse _allBatchAttendance =
      BatchWiseAttendanceResponse();
  BatchWiseAttendanceResponse get allBatchAttendance => _allBatchAttendance;

  Future<void> fetchAllBatchWiseAttendance(data) async {
    _allBatchAttendanceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      BatchWiseAttendanceResponse res =
          await AttendanceRepository().getAllBatchWiseAttendance(data);
      if (res.success == true) {
        _allBatchAttendance = res;

        _allBatchAttendanceApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allBatchAttendanceApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _allBatchAttendanceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _accessModulesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get accessModulesApiResponse => _accessModulesApiResponse;
  AccessedModulesResponse _accessModules = AccessedModulesResponse();
  AccessedModulesResponse get accessModules => _accessModules;

  Future<void> fetchAccessedModules(data) async {
    _accessModulesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AccessedModulesResponse res =
          await AttendanceRepository().getAccessedModules(data);
      if (res.success == true) {
        _accessModules = res;
        _accessModulesApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _accessModulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _accessModules = AccessedModulesResponse();
      print("VM CATCH ERR MODULE :: $e");
      _accessModulesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  List<dynamic> backendPermissions = [];
  List<dynamic> get getBackendPermissions => backendPermissions;

  bool hasPermission(List<dynamic> staticPerms) {
    if (staticPerms.isEmpty) return true;
    bool hasPerm = staticPerms.any((per) => backendPermissions.contains(per));
    return hasPerm;
  }

  ApiResponse _myPermissionsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myPermissionsApiResponse => _myPermissionsApiResponse;

  Future<void> fetchMyPermissions() async {
    _myPermissionsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      dynamic res = await UserRepository().getMyPermission();

      if (res["success"] == true) {
        backendPermissions = res["permissions"];
        _myPermissionsApiResponse =
            ApiResponse.completed(res["success"].toString());
        notifyListeners();
      } else {
        _myPermissionsApiResponse =
            ApiResponse.error(res["success"].toString());
      }
    } catch (e) {
      print("VM CATCH ERR PERMISSION :: $e");
      _myPermissionsApiResponse = ApiResponse.error(e.toString());
    }
  }

  ApiResponse _staffTypeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get staffTypeApiResponse => _staffTypeApiResponse;
  StaffResponse _staffType = StaffResponse();
  StaffResponse get staffType => _staffType;

  Future<void> fetchStaffTypes() async {
    _staffTypeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StaffResponse res = await AttendanceRepository().getStaffType();
      if (res.success == true) {
        _staffType = res;
        _staffTypeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _staffTypeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _staffTypeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _dailyIncomeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get dailyIncomeApiResponse => _dailyIncomeApiResponse;
  PaymentDetailsResponse _dailyIncome = PaymentDetailsResponse();
  PaymentDetailsResponse get dailyIncome => _dailyIncome;

  Future<void> fetchDailyIncome(data) async {
    _dailyIncomeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      PaymentDetailsResponse res = await StaffRepository().getDailyIncome(data);
      if (res.data?.success == true) {
        _dailyIncome = res;
        _dailyIncomeApiResponse = ApiResponse.completed(res.data?.success.toString());
        notifyListeners();
      } else {
        _dailyIncomeApiResponse = ApiResponse.error(res.data?.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _dailyIncomeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentLogsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentLogsApiResponse => _studentLogsApiResponse;
  StudentLogsResponse _studentLogs = StudentLogsResponse();
  StudentLogsResponse get studentLogs => _studentLogs;

  Future<void> fetchStudentLogs(String username) async {
    _studentLogsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentLogsResponse res = await UserRepository().getStudentLogs(username);
      if (res.success == true) {
        _studentLogs = res;
        _studentLogsApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentLogsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _studentLogsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
