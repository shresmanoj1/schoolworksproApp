import 'dart:convert';
import 'package:schoolworkspro_app/response/switchrole_response.dart';

import '../api.dart';

class SwitchRepo {
  API api = API();

  Future<SwitchRoleResponse> switchrole(data) async {
    // print("DATA :: " + data.toString());
    dynamic response =
        await api.postDataWithToken(jsonEncode(data), '/role/switch-role');
    // print("RAW RESPONSE :: "+ response.toString());
    SwitchRoleResponse res = SwitchRoleResponse.fromJson(response);
    return res;
  }
}
