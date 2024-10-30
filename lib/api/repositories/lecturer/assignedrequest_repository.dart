import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';

class AssignedRequestRepository {
  Future<AdminRequestResponse> getAssignedRequest(username) async {
    API api = API();
    dynamic response;
    AdminRequestResponse res;
    try {
      response = await api.getWithToken('/requests/assigned/$username');

      res = AdminRequestResponse.fromJson(response);
    } catch (e) {
      res = AdminRequestResponse.fromJson(response);
    }
    return res;
  }
}
