import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/api/repositories/ticket_repo.dart';
import 'package:schoolworkspro_app/response/lecturer/academicrequest_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerrequest_response.dart';
import 'package:schoolworkspro_app/response/principal/assignedrequestforstats_response.dart';

class TicketViewModel extends ChangeNotifier {

  refreshState(){
    notifyListeners();
  }

  String _startDate = "";
  String _endDate = "";
  ApiResponse _requestApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get requestApiResponse => _requestApiResponse;

  List<Request> _ticket = <Request>[];
  List<Request> get ticket => _ticket;

  List<Request> _pendingTicket = <Request>[];
  List<Request> get pendingTicket => _pendingTicket;

  List<Request> _progressTicket = <Request>[];
  List<Request> get progressTicket => _progressTicket;

  List<Request> _resolvedTicket = <Request>[];
  List<Request> get resolvedTicket => _resolvedTicket;

  int _pendingCount = 0;
  int get pendingcount => _pendingCount;

  int _approvedCount = 0;
  int get approvedCount => _approvedCount;

  int _resolvedCount = 0;
  int get resolvedCount => _resolvedCount;

  Future<void> fetchTicketsfromProvider() async {
    _requestApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerRequestResponse res =
          await TicketRepository().getMyRequestFromProvider();
      if (res.success == true) {
        _ticket = res.requests!;

        for (int i = 0; i < _ticket.length; i++) {
          if (_ticket[i].status == "Resolved" ) {
            _resolvedCount = _resolvedCount + 1;
            notifyListeners();
          } else if (_ticket[i].status == "Pending" || _ticket[i].status == "Backlog") {
            _pendingCount = _pendingCount + 1;
            notifyListeners();
          } else if (_ticket[i].status == "Approved") {
            _approvedCount = _approvedCount + 1;
            notifyListeners();
          }
        }
        _requestApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _requestApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _requestApiResponse = ApiResponse.error(e.toString());
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

  ApiResponse _academicApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get academicApiResponse => _academicApiResponse;
  List<dynamic> _academicRequest = <dynamic>[];
  List<dynamic> get academicRequest => _academicRequest;

  int _approvedAcademic = 0;
  int get approvedAcademic => _approvedAcademic;

  int _backlogAcademic = 0;
  int get backlogAcademic => _backlogAcademic;

  resetVal(int val){
    _backlogAcademic = val;
    _pendingAcademic = val;
    _resolvedAcademic = val;
    _approvedAcademic = val;
    notifyListeners();
  }

  int _pendingAcademic = 0;
  int get pendingAcademic => _pendingAcademic;

  int _resolvedAcademic = 0;
  int get resolvedAcademic => _resolvedAcademic;

  Future<void> fetchAcademicRequest() async {
    _academicApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AcademicRequestResponse res =
          await TicketRepository().getMyAcademicRequest();
      if (res.success == true) {
        _academicRequest = res.requests!;
        for (int i = 0; i < _academicRequest.length; i++) {
          if (_academicRequest[i]['status'] == "Resolved") {
            _resolvedAcademic = _resolvedAcademic + 1;
            notifyListeners();
          } else if (_academicRequest[i]['status'] == "Approved") {
            _approvedAcademic = _approvedAcademic + 1;
            notifyListeners();
          } else if (_academicRequest[i]['status'] == "Pending") {
            _pendingAcademic = _pendingAcademic + 1;
            notifyListeners();
          } else if (_academicRequest[i]['status'] == "Backlog") {
            _backlogAcademic = _backlogAcademic + 1;
            notifyListeners();
          }
        }

        _academicApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _academicApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _academicApiResponse = ApiResponse.error(e.toString());
    }
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

  setAcademicDot(bool value) {
    _academicDot = value;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pendingCount = 0;
    _pendingAcademic = 0;
    _backlogAcademic = 0;
    _resolvedAcademic = 0;
    _approvedAcademic = 0;
    _approvedCount = 0;
    _resolvedCount = 0;
    super.dispose();
  }
}
