import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/admin/getstaff_response.dart';
import 'package:schoolworkspro_app/response/getallclub_response.dart';

import '../../../response/admin/department_response.dart';

class ClubRepository {
  API api = API();
  Future<GetAllClubResponse> getallclub() async {
    API api = new API();
    dynamic response;
    GetAllClubResponse res;
    try {
      response = await api.getWithToken('/clubs/all');

      res = GetAllClubResponse.fromJson(response);
    } catch (e) {
      res = GetAllClubResponse.fromJson(response);
    }
    return res;
  }

  Future<DepartmentResponse> getDepartment() async {
    API api = new API();
    dynamic response;
    DepartmentResponse res;
    try {
      response = await api.getWithToken('/users/get-unique-department/staff');


      res = DepartmentResponse.fromJson(response);
    } catch (e) {
      print("response:::${e.toString()}");
      res = DepartmentResponse.fromJson(response);
    }
    return res;
  }
}
