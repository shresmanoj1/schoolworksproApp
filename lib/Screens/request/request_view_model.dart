import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/request_letter_response.dart';
import 'package:schoolworkspro_app/response/viewticketresponse.dart';
import 'package:schoolworkspro_app/services/parents/getparentrequest_service.dart';
import 'package:schoolworkspro_app/services/viewmyrequest_service.dart';
import 'package:schoolworkspro_app/services/viewticket_service.dart';
import '../../../api/api_response.dart';
import '../../api/repositories/library_repo.dart';
import '../../config/api_response_config.dart';
import '../../response/AssignedToUserResponse.dart';
import '../../response/parents/getrequestparent_response.dart';
import '../../response/physicalbook_response.dart';
import '../../response/viewmyrequest_response.dart';

class RequestViewModel extends ChangeNotifier {
  ApiResponse _myRequestApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myRequestApiResponse => _myRequestApiResponse;
  Viewmyrequestresponse _myRequest = Viewmyrequestresponse();
  Viewmyrequestresponse get myRequest => _myRequest;

  Future<void> fetchMyRequest() async {
    _myRequestApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Viewmyrequestresponse res = await Viewmyrequestservice().getmyrequest();

      if (res.success == true) {
        _myRequest = res;
        _myRequestApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myRequestApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _myRequestApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _myTicketApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myTicketApiResponse => _myTicketApiResponse;
  Viewticketresponse _myTicket = Viewticketresponse();
  Viewticketresponse get myTicket => _myTicket;

  Future<void> fetchMyTicket() async {
    _myTicketApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Viewticketresponse res = await Viewticketservice().getticket();

      if (res.success == true) {
        _myTicket = res;
        _myTicketApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myTicketApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _myTicketApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _parentRequestApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get parentRequestApiResponse => _parentRequestApiResponse;
  Getparentequestresponse _parentRequest = Getparentequestresponse();
  Getparentequestresponse get parentRequest => _parentRequest;

  Future<void> fetchparentRequest() async {
    _parentRequestApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Getparentequestresponse res =
          await Getparentrequestservice().getrequest();

      if (res.success == true) {
        _parentRequest = res;
        _parentRequestApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _parentRequestApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _parentRequestApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _requestLetterApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get requestLetterApiResponse => _requestLetterApiResponse;
  RequestLetterResponse _requestLetter = RequestLetterResponse();
  RequestLetterResponse get requestLetter => _requestLetter;

  Future<void> fetchRequestLetter() async {
    _requestLetterApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RequestLetterResponse res =
          await Viewmyrequestservice().getRequestLetter();

      if (res.success == true) {
        _requestLetter = res;
        _requestLetterApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _requestLetterApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _requestLetterApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _assignedToUserApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assignedToUserApiResponse => _assignedToUserApiResponse;
  AssignedToUserResponse _assignedToUser = AssignedToUserResponse();
  AssignedToUserResponse get assignedToUser => _assignedToUser;

  Future<void> fetchAssignedToUser() async {
    _assignedToUserApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssignedToUserResponse res =
      await Viewmyrequestservice().getAssignedToUser();

      if (res.success == true) {
        _assignedToUser = res;
        _assignedToUserApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assignedToUserApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _assignedToUserApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
