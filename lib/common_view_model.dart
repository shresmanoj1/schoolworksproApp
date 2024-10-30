import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/Journal_repository.dart';
import 'package:schoolworkspro_app/api/repositories/batch_repository.dart';
import 'package:schoolworkspro_app/api/repositories/collaboration_repo.dart';
import 'package:schoolworkspro_app/api/repositories/exam_repo.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/assignedrequest_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/grade_repository.dart';
import 'package:schoolworkspro_app/api/repositories/notification_repository.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/request/comment_request.dart';
import 'package:schoolworkspro_app/response/activity_response.dart';
import 'package:schoolworkspro_app/response/attendance_response.dart';
import 'package:schoolworkspro_app/response/current_student_response.dart';

import 'package:schoolworkspro_app/response/event_response.dart';

import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/exam_rules_regulation_response.dart';

import 'package:schoolworkspro_app/response/fetchjournal_response.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';
import 'package:schoolworkspro_app/response/authenticateduser_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/encrypt_student_qr_response.dart';
import 'package:schoolworkspro_app/response/exam_from_course_response.dart';
import 'package:schoolworkspro_app/response/get_all_chat_ai_response.dart';
import 'package:schoolworkspro_app/response/get_ota_response.dart';
import 'package:schoolworkspro_app/response/getexam_response.dart';
import 'package:schoolworkspro_app/response/journey_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudentformarking_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerexam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/viewexamattendance_response.dart';
import 'package:schoolworkspro_app/response/notice_response.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';
import 'package:schoolworkspro_app/response/offensehistory_response.dart';
import 'package:schoolworkspro_app/response/routine_response.dart';
import 'package:schoolworkspro_app/response/student_bus_response.dart';
import 'package:schoolworkspro_app/response/supportstaff_response.dart';
import 'package:schoolworkspro_app/response/updatedetail_response.dart';
import 'package:schoolworkspro_app/response/user_detail.dart';
import 'package:schoolworkspro_app/response/user_input_chat_response.dart';
import 'package:schoolworkspro_app/response/verifiedJournal_response.dart';
import 'package:schoolworkspro_app/response/weeklydetails_response.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/supportstaff_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_response.dart';
import 'api/api_response.dart';
import 'api/repositories/activity_repository.dart';
import 'api/repositories/chatbot/chat_repo.dart';
import 'api/repositories/journey_repository.dart';
import 'api/repositories/offense_level_repository.dart';
import 'api/repositories/user_repository.dart';

import 'api/repositories/lecturer/attendance_repository.dart';
import 'helper/custom_loader.dart';

class CommonViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _connected = false;
  bool get connnected => _connected;

  bool _showDot = false;
  bool get showDot => _showDot;

  bool _hasData = false;
  bool get hasData => _hasData;

  bool _hasStudent = false;
  bool get hasStudent => _hasStudent;

  setHasStudent(bool value) {
    _hasStudent = value;
    notifyListeners();
  }

  setIfData(bool value) {
    _hasData = value;
    notifyListeners();
  }

  setDot(bool state) {
    _showDot = state;
    notifyListeners();
  }

  bool _assignedDot = false;
  bool get assignedDot => _assignedDot;

  setAssignedDot(bool value) {
    _assignedDot = value;
    notifyListeners();
  }

  bool _academicDot = false;
  bool get academicDot => _academicDot;

  SetAcademicDot(bool value) {
    _assignedDot = value;
    notifyListeners();
  }

  setLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  checkInternet() async {
    await internetCheck().then((value) {
      if (value) {
        _connected = true;
      } else {
        _connected = false;

        // Fluttertoast.showToast(msg: "No Internet connection");
      }
    });
  }

  ApiResponse _MyActivityApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get MyActivityApiResponse => _MyActivityApiResponse;
  List<Complete> _completed = <Complete>[];
  List<Complete> get completed => _completed;
  List<Complete> _incomplete = <Complete>[];
  List<Complete> get incomplete => _incomplete;

  Future<void> getMyActivity(String username) async {
    _MyActivityApiResponse = ApiResponse.initial("Empty Data");
    notifyListeners();
    try {
      Activityresponse res = await ActivityRepository().getActivity(username);
      if (res.success == true) {
        _completed = res.complete!;
        _incomplete = res.incomplete!;
        _MyActivityApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _MyActivityApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _MyActivityApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _noticeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get noticeApiResponse => _noticeApiResponse;
  List<Notice> _notice = <Notice>[];
  List<Notice> get notice => _notice;
  int _page = 1;
  int _size = 10;
  int _totalData = 0;
  bool _hasMore = true;
  int get page => _page;
  int get size => _size;
  int get totalData => _totalData;
  bool get hasMore => _hasMore;

  Future<void> fetchNotice() async {

    _noticeApiResponse = ApiResponse.initial("Empty Data");
    notifyListeners();
    try {
      Noticeresponse res = await UserRepository().getNotice(_page.toString());

      if (res.success == true) {
        _notice = res.notices!;
        _page = 1;
        _hasMore = res.notices!.isNotEmpty;
        _noticeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _noticeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print(e.toString());
      _noticeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _loadMoreApiResponse = ApiResponse.initial('Empty data');
  ApiResponse get loadMoreApiResponse => _loadMoreApiResponse;

  Future<void> loadMore() async {
    if (hasMore) {
      _page += 1;
      _loadMoreApiResponse = ApiResponse.loading('Fetching device data');
      notifyListeners();
      try {
        Noticeresponse res = await UserRepository().getNotice(_page.toString());
        _notice.addAll(res.notices!);
        _hasMore = res.notices!.isNotEmpty;
        _loadMoreApiResponse = ApiResponse.completed(res.success);

        notifyListeners();
      } catch (e) {
        _loadMoreApiResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  ApiResponse _notificationApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get notificationApiResponse => _notificationApiResponse;
  List<Notificationss> _notification = <Notificationss>[];
  List<Notificationss> get notification => _notification;
  int _noticeCount = 0;
  int get noticeCount => _noticeCount;

  Future<void> fetchNotifications() async {
    _notificationApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Notificationresponse res =
          await NotificationRepository().getNotifications();
      if (res.success == true) {
        _notification = res.notifications!;
        _noticeCount = res.notifications!.length;
        _notificationApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _notificationApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _notificationApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _batchesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get atchesApiResponse => _batchesApiResponse;
  List<String> _batchArr = <String>[];
  List<String> get batchArr => _batchArr;

  List<String> _lessonbatchArr = <String>[];
  List<String> get lessonbatchArr => _lessonbatchArr;

  String _moduleSlug = "";
  String get moduleSlug => _moduleSlug;

  setSlug(String module_slug) {
    _moduleSlug = module_slug;
    notifyListeners();
  }

  ApiResponse _lessonbatchApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessonbatchApiResponse => _lessonbatchApiResponse;

  Future<void> fetchlessonbatch(String moduleSlug, String lessonSlug) async {
    _lessonbatchApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBatchResponse res =
          await BatchRepository().getLessonAccessBatch(moduleSlug, lessonSlug);
      if (res.success == true) {
        // _batchArr = res.batcharr!;
        _lessonbatchArr = res.batcharr!;

        _lessonbatchApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessonbatchApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _lessonbatchApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchBatches() async {
    _batchesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBatchResponse res = await BatchRepository().getbatches(_moduleSlug);
      if (res.success == true) {
        _batchArr = res.batcharr!;

        _batchesApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _batchesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR222222 :: " + e.toString());
      _batchesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _checkIfOnTimeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get checkIfOnTimeApiResponse => _checkIfOnTimeApiResponse;
  List<String> _oneTimeBatch = <String>[];
  List<String> get oneTimeBatch => _oneTimeBatch;
  Future<void> fetchBatcheOneTimeAttendanceCheck(String moduleSlug) async {
    _checkIfOnTimeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBatchResponse res =
          await BatchRepository().getbatchesIFOneTime(moduleSlug);
      if (res.success == true) {
        _oneTimeBatch = res.batcharr!;

        _checkIfOnTimeApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _checkIfOnTimeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _checkIfOnTimeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _currentbatchApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get currentbatchApiResponse => _currentbatchApiResponse;
  List<String> _currentBatch = <String>[];
  List<String> get currentBatch => _currentBatch;

  Future<void> fetchCurrentBatches() async {
    _currentbatchApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetBatchResponse res =
          await BatchRepository().getCurrentBatches(_moduleSlug);
      if (res.success == true) {
        _currentBatch = res.batcharr!;

        _currentbatchApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _currentbatchApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _currentbatchApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentMarkingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentMarkingApiResponse => _studentMarkingApiResponse;
  List<dynamic> _studentMarking = <dynamic>[];
  List<dynamic> get studentMarking => _studentMarking;

  Future<void> fetchStudentformarking(batchss) async {
    _studentMarkingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      var batch_slug = batchss.split(" ").join("%20");
      GetStudentForMarkingResponse res =
          await GradeRepository().getStudentsformarking(batch_slug);
      if (res.success == true) {
        _studentMarking = res.students!;

        _studentMarkingApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentMarkingApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _studentMarkingApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _examFromCourseResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examFromCourseResponse => _examFromCourseResponse;
  List<AllExam> _examsCourse = <AllExam>[];
  List<AllExam> get examsCourse => _examsCourse;

  Future<void> fetchExamFromCourseStudents(username) async {
    _examFromCourseResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ExamFromCourseResponse res =
          await ExamRepository().getExamFromCourseStudents(username);
      if (res.success == true) {
        _examsCourse = res.allExams!;

        _examFromCourseResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _examFromCourseResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _examFromCourseResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _examApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examApiResponse => _examApiResponse;
  List<dynamic> _exams = <dynamic>[];
  List<dynamic> get exams => _exams;

  Future<void> fetchExams() async {
    _examApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetExamResponse res = await ExamRepository().getExam();
      if (res.success == true) {
        _exams = res.allExam!;

        _examApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _examApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _examApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _examlecturerApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examlecturerApiResponse => _examlecturerApiResponse;
  List<dynamic> _examslecturer = <dynamic>[];
  List<dynamic> get examslecturer => _examslecturer;

  Future<void> fetchExamLecturer() async {
    _examlecturerApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerGetExamResponse res = await ExamRepository().getExamLecturer();
      if (res.success == true) {
        _examslecturer = res.exam!;

        _examlecturerApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _examlecturerApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _examlecturerApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _examAttendanceApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get examAttendanceApiResponse => _examAttendanceApiResponse;
  List<AllStudent> _examAttendance = <AllStudent>[];
  List<AllStudent> get examAttendance => _examAttendance;

  Future<void> fetchExamAttendance(String id) async {
    _examAttendanceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ViewExamAttendanceResponse res =
          await ExamRepository().getExamAttendance(id);
      if (res.sucess == true) {
        _examAttendance = res.allStudents!;

        _examAttendanceApiResponse =
            ApiResponse.completed(res.sucess.toString());
        notifyListeners();
      } else {
        _examAttendanceApiResponse = ApiResponse.error(res.sucess.toString());
      }
    } catch (e) {
      _examAttendanceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _assignedrequestApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignedrequestApiResponse => _assignedrequestApiResponse;
  List<dynamic> _assignedrequest = <dynamic>[];
  List<dynamic> get assignedrequest => _assignedrequest;
  int _backlog = 0;
  int get backlog => _backlog;

  int _pending = 0;
  int get pending => _pending;

  int _approved = 0;
  int get approved => _approved;

  int _resolved = 0;
  int get resolved => _resolved;

  Future<void> getAssignedRequest(username) async {
    _assignedrequestApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AdminRequestResponse res =
          await AssignedRequestRepository().getAssignedRequest(username);
      if (res.success == true) {
        _assignedrequest = res.requests!;

        _backlog = res.backlog!;
        _pending = res.pending!;
        _approved = res.approved!;
        _resolved = res.resolved!;

        _assignedrequestApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignedrequestApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _assignedrequestApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _truotaApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get truotaApiResponse => _truotaApiResponse;
  List<String> _otabatch = <String>[];
  List<String> get otabatch => _otabatch;

  Future<void> fetchotatrue() async {
    _truotaApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetOtaResponse res = await BatchRepository().getOTAtrue();
      if (res.success == true) {
        _otabatch = res.batchArr!;

        _truotaApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _truotaApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _truotaApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _userDetailsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get userDetailsApiResponse => _userDetailsApiResponse;
  Authenticateduserresponse _user = Authenticateduserresponse();
  Authenticateduserresponse get user => _user;

  Future<void> fetchUser() async {
    _userDetailsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Authenticateduserresponse res =
          await Authenticateduserservice().getuser();
      if (res.success == true) {
        _user = res;

        _userDetailsApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _userDetailsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _userDetailsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _authenticatedUserDetailApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get authenticatedUserDetailApiResponse =>
      _authenticatedUserDetailApiResponse;
  User _authenticatedUserDetail = User();
  User get authenticatedUserDetail => _authenticatedUserDetail;

  late bool _privateFlag;
  bool get privateFlag => _privateFlag;

  Future<void> getAuthenticatedUser() async {
    _authenticatedUserDetailApiResponse = ApiResponse.loading("Loading");
    notifyListeners();
    try {
      Authenticateduserresponse res =
          await UserRepository().fetchAuthenticatedUser();
      if (res.success == true) {
        _authenticatedUserDetail = res.user!;
        _privateFlag = res.privateFlag ?? false;
        final SharedPreferences localStorage =
            await SharedPreferences.getInstance();
        localStorage.setBool("privateFlag", _privateFlag);
        _authenticatedUserDetailApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _authenticatedUserDetailApiResponse =
            ApiResponse.error(res.success.toString());
        notifyListeners();
      }
    } catch (e) {
      _authenticatedUserDetailApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  ApiResponse _UserDetailsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get UserDetailsApiResponse => _UserDetailsApiResponse;
  UserDetail _UserDetails = UserDetail();
  UserDetail get UserDetails => _UserDetails;

  Future<void> getUserDetails() async {
    _isLoading = true;
    _UserDetailsApiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      Userdetailresponse res = await UserRepository().fetchUsersDetails();
      if (res.success == true) {
        _UserDetails = res.user!;
        _UserDetailsApiResponse = ApiResponse.completed(res.success.toString());
      } else {
        _UserDetailsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _UserDetailsApiResponse = ApiResponse.error(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ApiResponse _UpdateUserDetailsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get UpdateUserDetailsApiResponse => _UpdateUserDetailsApiResponse;

  Future<void> updateUserProfile(BuildContext context, data) async {
    customLoadStart();
    _UpdateUserDetailsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      UpdatedetailResponse res = await UserRepository().updateUserDetails(data);
      if (res.success == true) {
        Fluttertoast.showToast(msg: 'Details updated successfully');
        Future.delayed(const Duration(milliseconds: 10), () {
          customLoadStop();
        });
      } else {
        Fluttertoast.showToast(msg: 'Error updating data, try again later');
        Future.delayed(const Duration(milliseconds: 10), () {
          customLoadStop();
        });
      }
    } catch (e) {
      customLoadStop();

      Fluttertoast.showToast(msg: 'Error updating data, try again later');
    }
  }

  ApiResponse _journeyApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get journeyApiResponse => _journeyApiResponse;
  List<AllDatum> _journey = <AllDatum>[];
  List<AllDatum> get journey => _journey;
  JUser? _juser;
  JUser? get juser => _juser;
  Future<void> fetchjourney() async {
    _journeyApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Journeyresponse res = await JourneyRepository().getJourney();
      if (res.success == true) {
        _journey = res.allData!;
        _juser = res.user!;

        _journeyApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _journeyApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _journeyApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _journalApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get journalApiResponse => _journalApiResponse;
  List<GetJournal> _journal = <GetJournal>[];
  List<GetJournal> get journal => _journal;
  Future<void> fetchmyJourney() async {
    _isLoading = true;
    _journalApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Fetchjournalresponse res = await JournalRepository().fetchmyJournal();
      if (res.success == true) {
        _journal = res.journal!;
        _journalApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _journalApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _journalApiResponse = ApiResponse.error(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    notifyListeners();
  }

  ApiResponse _verifiedJournalApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get verifiedJournalApiResponse => _verifiedJournalApiResponse;
  List<Journal> _verifiedJournal = <Journal>[];
  List<Journal> get verifiedJournal => _verifiedJournal;

  Future<void> getVerifiedJournal() async {
    _verifiedJournalApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      VerifiedJournalresponse res = await JournalRepository().journalVerify();
      if (res.success == true) {
        _verifiedJournal = res.journal!;
        _verifiedJournalApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _verifiedJournalApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _verifiedJournalApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _weeklyDetailsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get weeklyDetailsApiResponse => _weeklyDetailsApiResponse;
  JournalDetail _weeklydetail = JournalDetail();
  JournalDetail get weeklydetail => _weeklydetail;

  Future<void> fetchweeklydetails(String JournalSlug) async {
    _isLoading = true;
    _weeklyDetailsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      WeeklyDetailsresponse res =
          await JournalRepository().detailWeekly(JournalSlug);
      if (res.success == true) {
        _weeklydetail = res.journal!;
        _weeklyDetailsApiResponse =
            ApiResponse.completed(res.success.toString());
      } else {
        _weeklyDetailsApiResponse =
            ApiResponse.error(res.success.toString() ?? "Error");
      }
    } catch (e) {
      _weeklyDetailsApiResponse = ApiResponse.error(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ApiResponse _likeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get likeApiResponse => _likeApiResponse;
  Commonresponse _likeJournals = Commonresponse();
  Commonresponse get likeJournals => _likeJournals;

  Future<void> likeJournal(String slug, BuildContext context) async {
    _likeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      Commonresponse response = await JournalRepository().putLike(slug);
      if (response.success == true) {
        _likeJournals = response;
        _likeApiResponse = ApiResponse.completed(response.success.toString());

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _likeApiResponse = ApiResponse.error(response.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _likeApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _journalCommentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get journalCommentApiResponse => _journalCommentApiResponse;
  Commonresponse _journalComment = Commonresponse();
  Commonresponse get journalComment => _journalComment;

  Future<void> addJournalComment(
      Commentrequest request, String slug, BuildContext context) async {
    _likeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      Commonresponse response =
          await JournalRepository().postComment(request, slug);
      if (response.success == true) {
        _journalComment = response;
        _likeApiResponse = ApiResponse.completed(response.success.toString());

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _likeApiResponse = ApiResponse.error(response.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _likeApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _offenseApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get offenseApiResponse => _offenseApiResponse;
  List<Result> _offenses = <Result>[];
  List<Result> get offenses => _offenses;
  String _currentLevel = "";
  String? get currentLevel => _currentLevel;

  Future<void> fetchoffenses() async {
    _offenseApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      OffenceHistoryResponse res =
          await offenselevelRepository().getoffenselevel();
      if (res.success == true) {
        _offenses = res.result!;

        _currentLevel = res.currentLevel!;
        _offenseApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _offenseApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _offenseApiResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  ApiResponse _supportStaffApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get supportStaffApiResponse => _supportStaffApiResponse;
  SupportstaffResponse _supportStaff = SupportstaffResponse();
  SupportstaffResponse get supportStaff => _supportStaff;

  Future<void> fetchSupportStaff() async {
    _supportStaffApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      SupportstaffResponse res = await Supportstaffservice().getSupportstaff();
      if (res.success == true) {
        _supportStaff = res;
        _supportStaffApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _supportStaffApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _supportStaffApiResponse = ApiResponse.error(e.toString());
    }
  }

  ApiResponse _encryptStudentQrApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get encryptStudentQrApiResponse => _encryptStudentQrApiResponse;
  EncryptStudentQrResponse _encryptStudentQr = EncryptStudentQrResponse();
  EncryptStudentQrResponse get encryptStudentQr => _encryptStudentQr;

  Future<void> fetchEncryptStudentQr(request) async {
    _encryptStudentQrApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      EncryptStudentQrResponse res =
          await AttendanceRepository().postEncryptStudentQr(request);
      if (res.success == true) {
        _encryptStudentQr = res;

        _encryptStudentQrApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _encryptStudentQrApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _encryptStudentQrApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  BuildContext? _navigation;
  BuildContext? get navigation => _navigation;

  void setNavigatorContext(BuildContext c) {
    _navigation = c;
    notifyListeners();
  }

  //student navigation

  int _navigatoinIndex = 0;
  int get navigatoinIndex => _navigatoinIndex;

  PageController _pagecontroller = PageController();
  PageController get pagecontroller => _pagecontroller;
  setNavigationIndex(int index) {
    _navigatoinIndex = index;
    notifyListeners();
  }

  setInitial(int index) {
    _pagecontroller = PageController(initialPage: index);
    setNavigationIndex(index);
    notifyListeners();
  }

  itemTapped(int index) {
    setNavigationIndex(index);
    _pagecontroller.jumpToPage(index);
    notifyListeners();
  }

  List<dynamic> _quizselectedAnswer = <dynamic>[];
  List<dynamic> get quizselectedAnswer => _quizselectedAnswer;

  List<int> _selectedAnswer = <int>[];
  List<int> get selectedAnswer => _selectedAnswer;

  removeSelectAnswer() {
    selectedAnswer.clear();
    notifyListeners();
  }

  setSelectAnswerList(value) {
    _selectedAnswer.add(value);
    notifyListeners();
  }

  ApiResponse _eventApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get eventApiResponse => _eventApiResponse;
  List<Event> _events = <Event>[];
  List<Event> get events => _events;

  Future<void> fetchEvents() async {
    _events = [];
    _eventApiResponse = ApiResponse.initial("Empty Data");
    notifyListeners();
    try {
      Eventresponse res = await UserRepository().getAllEvents();

      if (res.success == true) {
        DateTime _currentDate = DateTime.now();
        _events.clear();

        _events = res.events;

        _eventApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _eventApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _eventApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _myExamsRulesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myExamsRulesApiResponse => _myExamsRulesApiResponse;
  ExamRulesRegulationsResponse _myExamsRules = ExamRulesRegulationsResponse();
  ExamRulesRegulationsResponse get myExamsRules => _myExamsRules;
  Future<void> fetchExamRulesRegulations() async {
    _myExamsRulesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ExamRulesRegulationsResponse res =
          await ExamRepository().getExamRulesRegulations();
      if (res.success == true) {
        _myExamsRules = res;
        _myExamsRulesApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myExamsRulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _myExamsRulesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentRoutineApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentRoutineApiResponse => _studentRoutineApiResponse;
  Routineresponse _studentRoutine = Routineresponse();
  Routineresponse get studentRoutine => _studentRoutine;
  Future<void> fetchStudentRoutine(String batch) async {
    _studentRoutineApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Routineresponse res = await UserRepository().getStudentRoutine(batch);
      if (res.success == true) {
        _studentRoutine = res;
        _studentRoutineApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentRoutineApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _studentRoutineApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentSubjectWiseAttendanceApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get studentSubjectWiseAttendanceApiResponse =>
      _studentSubjectWiseAttendanceApiResponse;
  Attendanceresponse _studentSubjectWiseAttendance = Attendanceresponse();
  Attendanceresponse get studentSubjectWiseAttendance =>
      _studentSubjectWiseAttendance;
  Future<void> fetchStudentSubjectWiseAttendance() async {
    _studentSubjectWiseAttendanceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Attendanceresponse res =
          await UserRepository().getStudentSubjectWiseAttendance();
      if (res.success == true) {
        _studentSubjectWiseAttendance = res;
        _studentSubjectWiseAttendanceApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentSubjectWiseAttendanceApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _studentSubjectWiseAttendanceApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentBusApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentBusApiResponse => _studentBusApiResponse;
  StudentBusResponse _studentBus = StudentBusResponse();
  StudentBusResponse get studentBus => _studentBus;

  Future<void> fetchStudentBus() async {
    _studentBusApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentBusResponse res = await UserRepository().getBusStudent();
      if (res.success == true) {
        _studentBus = res;
        _studentBusApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentBusApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _studentBusApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _allMessageNewchatBotApiResponse =
  ApiResponse.initial("Empty Data");
  ApiResponse get allMessageNewchatBotApiResponse =>
      _allMessageNewchatBotApiResponse;
  List<Message> _allMessagesV2 = <Message>[];
  List<Message> get allMessagesV2 => _allMessagesV2;

  Future<void> fetchAllMessagesNewChatBot(String username) async {
    _allMessageNewchatBotApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetAllChatAiResponse res = await ChatBotRepo().getAllMessagesV2(username);
      if (res.data?.success == true) {
        _allMessagesV2 = res.data!.messages!;

        _allMessageNewchatBotApiResponse =
            ApiResponse.completed(res.data?.success.toString());
        notifyListeners();
      } else {
        _allMessageNewchatBotApiResponse =
            ApiResponse.error(res.data?.success.toString());
      }
    } catch (e) {
      _allMessageNewchatBotApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _messageSentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get messageSentApiResponse => _messageSentApiResponse;
  InputData _inputData = InputData();
  InputData get inputData => _inputData;

  Future<void> sendMessageToBot(
      String username, String question, String email, bool student) async {
    _messageSentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      UserInputChatResponse res = await ChatBotRepo().sendUserInput(
          "?username=$username&question=$question&email=$email", student);
      if (res.data?.success == true) {
        _inputData = res.data!;

        _messageSentApiResponse =
            ApiResponse.completed(res.data?.success.toString());
        notifyListeners();
      } else {
        _messageSentApiResponse =
            ApiResponse.error(res.data?.success.toString());
      }
    } catch (e) {
      _messageSentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _currentStudentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get currentStudentApiResponse => _currentStudentApiResponse;
  List<StudentList> _currentStudent = <StudentList>[];
  List<StudentList> get currentStudent => _currentStudent;

  Future<void> fetchCurrentStudent(moduleSlug) async {
    _currentStudentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      var formatSlug = moduleSlug.split(" ").join("%20");
      CurrentStudentResponse res =
      await CollaborationRepository().getCurrentStudent(formatSlug);
      if (res.success == true) {
        _currentStudent = res.students!;

        _currentStudentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _currentStudentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _currentStudentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}


class DashboardData {
  String? image;
  Function()? onTap;

  DashboardData({this.image, this.onTap});
}
