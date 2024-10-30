import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/assignment_details_response.dart';

import '../../../api/api_response.dart';
import '../../../api/repositories/assignment_repo.dart';
import '../../../response/assignment_play_response.dart';
import '../../../response/assignment_response.dart';
import '../../../response/lecturer/assignment_play_report_response.dart';
import '../../../response/lecturer/lecturer_assignment_submission_response.dart';


class AssignmentViewModel extends ChangeNotifier {
  ApiResponse _assignmentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignmentApiResponse => _assignmentApiResponse;
  AssignmentResponse _assignment = AssignmentResponse();
  AssignmentResponse get assignment => _assignment;

  int _totalAssignmentProgress = 0;
  int get totalAssignmentProgress => _totalAssignmentProgress;

  Future<void> fetchAllAssignment(String moduleSlug) async {
    _assignmentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignmentResponse res =
      await AssignmentRepository().getAllAssignment(moduleSlug);

      if (res.success == true) {
        _assignment = res;
        _totalAssignmentProgress =0;

        if(_assignment.assignments != null && _assignment.assignments!.isNotEmpty){
          var totalAssignment = 0;
          for (var i =0; i< _assignment.assignments!.length; i++){
            if(_assignment.assignments![i].submission != null){
              totalAssignment += 1;
            }
          }
          _totalAssignmentProgress = (totalAssignment/ _assignment.assignments!.length * 100).toInt();
        }
        _assignmentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignmentApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe555 :: $e");
      _assignmentApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  // ApiResponse _lecturerAssignmentApiResponse = ApiResponse.initial("Empty Data");
  // ApiResponse get lecturerAssignmentApiResponse => _lecturerAssignmentApiResponse;
  // LecturerAssignmentResponse _lecturerAssignment = LecturerAssignmentResponse();
  // LecturerAssignmentResponse get lecturerAssignment => _lecturerAssignment;
  //
  // Future<void> fetchLecturerAssignment(String moduleSlug) async {
  //   _lecturerAssignmentApiResponse = ApiResponse.initial("Loading");
  //   notifyListeners();
  //   try {
  //     LecturerAssignmentResponse res =
  //     await AssignmentRepository().getAllLecturerAssignment(moduleSlug);
  //
  //     if (res.success == true) {
  //       _lecturerAssignment = res;
  //       _lecturerAssignmentApiResponse =
  //           ApiResponse.completed(res.success.toString());
  //       notifyListeners();
  //     } else {
  //       _lecturerAssignmentApiResponse =
  //           ApiResponse.error(res.success.toString());
  //     }
  //   } catch (e) {
  //     print("VM CATCH ERRe555 :: $e");
  //     _lecturerAssignmentApiResponse =
  //         ApiResponse.error(e.toString());
  //   }
  //   notifyListeners();
  // }
  //
  //
  ApiResponse _assignmentDetailApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignmentDetailApiResponse => _assignmentDetailApiResponse;
  AssignmentDetailsResponse _assignmentDetail = AssignmentDetailsResponse();
  AssignmentDetailsResponse get assignmentDetail => _assignmentDetail;

  Future<void> fetchAssignmentDetails(String id) async {
    _assignmentDetailApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignmentDetailsResponse res =
      await AssignmentRepository().getAssignmentDetail(id);

      if (res.success == true) {
        _assignmentDetail = res;
        _assignmentDetailApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignmentDetailApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRRRRRe1 :: $e");
      _assignmentDetailApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
  //
  ApiResponse _assignmentPlagResultApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignmentPlagResultApiResponse => _assignmentPlagResultApiResponse;
  AssignmentPlagResultResponse _assignmentResult = AssignmentPlagResultResponse();
  AssignmentPlagResultResponse get assignmentResult => _assignmentResult;

  Future<void> fetchAssignmentPlagResult(String username, String id) async {
    _assignmentPlagResultApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignmentPlagResultResponse res =
      await AssignmentRepository().getAssignmentPlagResult(username , id);

      if (res.success == true) {
        _assignmentResult = res;
        _assignmentPlagResultApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignmentPlagResultApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERReee :: $e");
      _assignmentPlagResultApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
  //
  // ApiResponse _batchesApiResponse = ApiResponse.initial("Empty Data");
  // ApiResponse get batchesApiResponse => _batchesApiResponse;
  // List<String> _batchArr = <String>[];
  // List<String> get batchArr => _batchArr;
  //
  // Future<void> fetchBatch(String moduleSlug) async {
  //   _batchesApiResponse = ApiResponse.initial("Loading");
  //   notifyListeners();
  //   try {
  //     GetBatchResponse res = await AssignmentRepository().getbatches(moduleSlug);
  //     if (res.success == true) {
  //       _batchArr = res.batcharr!;
  //
  //       _batchesApiResponse =
  //           ApiResponse.completed(res.success.toString());
  //       notifyListeners();
  //     } else {
  //       _batchesApiResponse =
  //           ApiResponse.error(res.success.toString());
  //     }
  //   } catch (e) {
  //     print("VM CATCH ERR :: " + e.toString());
  //     _batchesApiResponse = ApiResponse.error(e.toString());
  //   }
  //   notifyListeners();
  // }
  //
  //
  ApiResponse _lecturerAssignmentDetailsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lecturerAssignmentDetailsApiResponse => _lecturerAssignmentDetailsApiResponse;
  LecturerAssignmentDetailsResponse _lecturerAssignmentDetails = LecturerAssignmentDetailsResponse();
  LecturerAssignmentDetailsResponse get lecturerAssignmentDetails => _lecturerAssignmentDetails;

  Future<void> fetchLecturerAssignmentDetails(String id, String batch) async {
    _lecturerAssignmentDetailsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerAssignmentDetailsResponse res = await AssignmentRepository().getLecturerAssignmentDetails(id, batch);

      if (res.success == true) {
        _lecturerAssignmentDetails = res;
        _lecturerAssignmentDetailsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lecturerAssignmentDetailsApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe555 :: $e");
      _lecturerAssignmentDetailsApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentReportPlagApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentReportPlagApiResponse => _studentReportPlagApiResponse;
  GetReportPlagResponse _studentReportPlag = GetReportPlagResponse();
  GetReportPlagResponse get studentReportPlag => _studentReportPlag;

  Future<void> fetchStudentReportPlag(String id) async {
    _studentReportPlagApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetReportPlagResponse res = await AssignmentRepository().getReportStudentPlag(id);

      if (res.success == true) {
        _studentReportPlag = res;
        _studentReportPlagApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentReportPlagApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe555 :: $e");
      _studentReportPlagApiResponse =
          ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}


