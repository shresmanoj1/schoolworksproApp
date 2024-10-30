import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/batch_repository.dart';
import 'package:schoolworkspro_app/api/repositories/disciplinary_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/club_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/routine_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/api/repositories/progress_repo.dart';
import 'package:schoolworkspro_app/response/certificates_names_response.dart';
import 'package:schoolworkspro_app/response/disciplinary_response.dart';
import 'package:schoolworkspro_app/response/getallbatch_response.dart';
import 'package:schoolworkspro_app/response/getallclub_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
import 'package:schoolworkspro_app/response/principal/activity_log_response.dart';
import 'package:schoolworkspro_app/response/principal/assignedrequestforstats_response.dart';
import 'package:schoolworkspro_app/response/principal/available_lecturer_routine_response.dart';
import 'package:schoolworkspro_app/response/principal/leaveforstats_principal.dart';
import 'package:schoolworkspro_app/response/principal/overtimeforstats_response.dart';
import 'package:schoolworkspro_app/response/principal/supportstaff_response.dart';
import 'package:schoolworkspro_app/response/routineforprincipal_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';
import '../../response/accessedmodule_response.dart';

import '../../response/admin/department_response.dart';
import '../../response/admin/get_all_active_students_response.dart';
import '../../response/lecturer/get_all_student_response.dart';
import '../../response/principal/filter_routine_response.dart';
import '../../response/principal/sisciplinary_level_details.dart';

class StatsCommonViewModel extends ChangeNotifier {
  ApiResponse _leavestatsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get leavestatsApiResponse => _leavestatsApiResponse;
  List<Leave> _leavestats = <Leave>[];
  List<Leave> get leavestats => _leavestats;

  int _approvedCount = 0;
  int get approvedCount => _approvedCount;

  int _deniedCount = 0;
  int get deniedCount => _deniedCount;

  int _pendingCount = 0;
  int get pendingCount => _pendingCount;

  Future<void> fetchleavereport(String username) async {
    _leavestatsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LeaveForStatsPrincipal res =
          await StatsRepository().getleavestats(username);
      if (res.success == true) {
        _leavestats = res.leave!;
        _approvedCount = res.approvedCount!;
        _deniedCount = res.deniedCount!;
        _pendingCount = res.pendingCount!;

        _leavestatsApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _leavestatsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _leavestatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _assignedRequestApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignedRequestApiResponse => _assignedRequestApiResponse;
  List<dynamic> _assignedRequest = <dynamic>[];
  List<dynamic> get assignedRequest => _assignedRequest;

  int _approved = 0;
  int get approved => _approved;

  int _backlog = 0;
  int get backlog => _backlog;

  int _pending = 0;
  int get pending => _pending;

  int _resolved = 0;
  int get resolved => _resolved;

  Future<void> fetchassignedrequest(String username) async {
    _assignedRequestApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignedRequestForStatsResponse res =
          await StatsRepository().getassignedrequest(username);
      if (res.success == true) {
        _approved = res.approved!;
        _pending = res.pending!;
        _backlog = res.backlog!;
        _resolved = res.resolved!;
        _assignedRequest = res.requests!;

        _assignedRequestApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignedRequestApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _assignedRequestApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _overtimestatsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get overtimestatsApiResponse => _overtimestatsApiResponse;

  List<dynamic> _overtime = <dynamic>[];
  List<dynamic> get overtime => _overtime;

  int _approvedOvertime = 0;
  int get approvedOvertime => _approvedOvertime;

  int _deniedOvertime = 0;
  int get deniedOvertime => _deniedOvertime;

  int _pendingOvertime = 0;
  int get pendingOvertime => _pendingOvertime;
  Future<void> fetchovertime(String username) async {
    _overtimestatsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OvertimeForStatsResponse res =
          await StatsRepository().getovertime(username);
      if (res.success == true) {
        _overtime = res.overtime!;
        _pendingOvertime = res.pendingCount!;
        _deniedOvertime = res.deniedCount!;
        _approvedOvertime = res.approvedCount!;

        _overtimestatsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _overtimestatsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _overtimestatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _logsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get logsApiResponse => _logsApiResponse;
  List<MonthlyAttendance> _monthlyAttendance = <MonthlyAttendance>[];
  List<MonthlyAttendance> get monthlyAttendance => _monthlyAttendance;

  Future<void> fetchactivitylogs(data, String username) async {
    _logsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ActivityLogsResponse res =
          await StatsRepository().getlogs(data, username);
      if (res.success == true) {
        _monthlyAttendance = res.monthlyAttendance!;

        _logsApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _logsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _logsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _supportstaffApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get supportstaffApiResponse => _supportstaffApiResponse;
  List<String> _supportStaff = <String>[];
  List<String> get supportStaff => _supportStaff;

  Future<void> fetchsupportstaffs(String username) async {
    _supportstaffApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetSupportStaffResponse res =
          await StatsRepository().getsupportstaffs(username);
      if (res.success == true) {
        _supportStaff = res.staff!.batches!;

        _supportstaffApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _supportstaffApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _supportstaffApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allbatchtaffApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allbatchtaffApiResponse => _allbatchtaffApiResponse;
  List<AllBatch> _allbatches = <AllBatch>[];
  List<AllBatch> get allbatches => _allbatches;

  Future<void> fetchAllBatch() async {
    _allbatchtaffApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllBatchResponse res = await BatchRepository().getAllBatch();
      if (res.success == true) {
        _allbatches = res.allBatch!;

        _allbatchtaffApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allbatchtaffApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allbatchtaffApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allclubApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allclubApiResponse => _allclubApiResponse;
  List<Club> _allclub = <Club>[];
  List<Club> get allclub => _allclub;

  Future<void> fetchAllClub() async {
    _allclubApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllClubResponse res = await ClubRepository().getallclub();
      if (res.success == true) {
        _allclub = res.clubs!;

        _allclubApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allclubApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allclubApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _departmentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get departmentApiResponse => _departmentApiResponse;
  List<String> _department = <String>[];
  List<String> get department => _department;

  Future<void> fetchDepartments() async {
    _departmentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      DepartmentResponse res = await ClubRepository().getDepartment();
      if (res.success == true) {
        _department = res.departments!;

        _departmentApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _departmentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR DEPARTMENT:: " + e.toString());
      _departmentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allroutineApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allroutineApiResponse => _allroutineApiResponse;
  List<dynamic> _routines = <dynamic>[];
  List<dynamic> get routines => _routines;

  Future<void> fetchAllRoutines(String params) async {
    _allroutineApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RoutineForPrincipalStats res =
          await RoutineRepository().getallroutine(params);
      if (res.success == true) {
        _routines = res.routines!;

        _allroutineApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allroutineApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allroutineApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _filterRoutineApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get filterRoutineApiResponse => _filterRoutineApiResponse;
  Filter _filterRoutine = Filter();
  Filter get filterRoutine => _filterRoutine;

  Future<void> fetchFilterRoutines(String batch, String lecturer,
      String classroom, String institution) async {
    _filterRoutineApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      FilterRoutineResponse res = await RoutineRepository()
          .getFilterRoutine(batch, lecturer, classroom, institution);
      if (res.success == true) {
        _filterRoutine = res.filter!;

        _filterRoutineApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _filterRoutineApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _filterRoutineApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _availableLecturerRoutineApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get availableLecturerRoutineApiResponse =>
      _availableLecturerRoutineApiResponse;
  AvailableLecturerRoutineResponse _availableLecturerRoutine =
      AvailableLecturerRoutineResponse();
  AvailableLecturerRoutineResponse get availableLecturerRoutine =>
      _availableLecturerRoutine;

  Future<void> fetchAvailableLecturerRoutine(data) async {
    _availableLecturerRoutineApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AvailableLecturerRoutineResponse res =
          await RoutineRepository().getAvailableLecturerRoutine(data);
      if (res.success == true) {
        _availableLecturerRoutine = res;

        _availableLecturerRoutineApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _availableLecturerRoutineApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _availableLecturerRoutineApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allRoutineFilterApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allRoutineFilterApiResponse => _allRoutineFilterApiResponse;
  List<dynamic> _allRoutineFilter = <dynamic>[];
  List<dynamic> get allRoutineFilter => _allRoutineFilter;

  Future<void> fetchAllFilterRoutines(String batch, String lecturer,
      String classroom, String institution) async {
    _allRoutineFilterApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RoutineForPrincipalStats res = await RoutineRepository()
          .getAllRoutine(batch, lecturer, classroom, institution);
      if (res.success == true) {
        _allRoutineFilter = res.routines!;

        _allRoutineFilterApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allRoutineFilterApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allRoutineFilterApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allroutinefromclassApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get allroutinefromclassApiResponse =>
      _allroutinefromclassApiResponse;

  Future<void> fetchAllRoutinesfromclass(data) async {
    _allroutinefromclassApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RoutineForPrincipalStats res =
          await RoutineRepository().getallroutinefromclass(data);
      if (res.success == true) {
        _routines = res.routines!;

        _allroutinefromclassApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allroutinefromclassApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allroutinefromclassApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _progressreportApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get progressreportApiResponse => _progressreportApiResponse;
  List<dynamic> _allprogress = <dynamic>[];
  List<dynamic> get allprogress => _allprogress;

  Future<void> fetchAllProgressReport(String email, String batch) async {
    _progressreportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetProgressForStatsResponse res =
          await ProgressRepo().getProgressReport(email, batch);
      if (res.success == true) {
        _allprogress = res.allProgress!;

        _progressreportApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _progressreportApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _progressreportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _disciplinaryApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get disciplinaryApiResponse => _disciplinaryApiResponse;
  List<Result> _act = <Result>[];
  List<Result> get act => _act;

  Future<void> fetchAllAct() async {
    _disciplinaryApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      DisciplinaryResponse res = await DisciplinaryRepo().getdisciplinary();
      if (res.success == true) {
        _act = res.result!;

        _disciplinaryApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _disciplinaryApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _disciplinaryApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _disciplinaryHistoryLevelDetailsApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get disciplinaryHistoryLevelDetailsApiResponse =>
      _disciplinaryHistoryLevelDetailsApiResponse;
  DisciplinaryLevelDetailsResponse _levelDetails =
      DisciplinaryLevelDetailsResponse();
  DisciplinaryLevelDetailsResponse get levelDetails => _levelDetails;

  Future<void> fetchDisciplinaryHistoryLevelDetails(String id) async {
    _disciplinaryHistoryLevelDetailsApiResponse =
        ApiResponse.initial("Loading");
    notifyListeners();
    try {
      DisciplinaryLevelDetailsResponse res =
          await DisciplinaryRepo().getDisciplinaryHistoryLevelDetails(id);
      if (res.success == true) {
        _levelDetails = res;

        _disciplinaryHistoryLevelDetailsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _disciplinaryHistoryLevelDetailsApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _disciplinaryHistoryLevelDetailsApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allStudentForLecturerResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get allStudentForLecturerResponse =>
      _allStudentForLecturerResponse;
  List<dynamic>? _allStudent = <dynamic>[];
  List<dynamic>? get allStudent => _allStudent;

  Future<void> fetchAllStudentForLecturer(String batch) async {
    _allStudentForLecturerResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllStudentStatsResponse res = await StudentStatsLecturerService()
          .getAllStudentForLecturerStats(batch);
      if (res.success == true) {
        print(res.students);
        _allStudent = res.students;

        _allStudentForLecturerResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allStudentForLecturerResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allStudentForLecturerResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allActiveStudentStatsResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get allActiveStudentStatsResponse =>
      _allActiveStudentStatsResponse;
  List<dynamic>? _allActiveStudent = <dynamic>[];
  List<dynamic>? get allActiveStudent => _allActiveStudent;

  Future<void> fetchAllActiveStudent(String batch) async {
    _allActiveStudentStatsResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllActiveStudentResponse res =
          await StudentStatsLecturerService().getAllActiveStudentStats(batch);
      if (res.success == true) {
        _allActiveStudent = res.exam;

        print("Exammmm${_allActiveStudent}");

        _allActiveStudentStatsResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allActiveStudentStatsResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allActiveStudentStatsResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _certificateNamesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get certificateNamesApiResponse => _certificateNamesApiResponse;
  List<Certificate> _certificateNames = <Certificate>[];
  List<Certificate> get certificateNames => _certificateNames;

  Future<void> fetchCertificateNames() async {
    _certificateNamesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      CertificateNamesResponse res =
          await StatsRepository().getCertificateNames();
      if (res.success == true) {
        _certificateNames = res.certificates!;

        _certificateNamesApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _certificateNamesApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _certificateNamesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
