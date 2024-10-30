import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';

import '../../response/offensehistory_response.dart';

class offenselevelRepository {
  API api = API();
  Future<OffenceHistoryResponse> getoffenselevel() async {
    dynamic response;
    OffenceHistoryResponse res;
    try {
      response = await api.getWithToken(Endpoints.offenseLevel);
      res = OffenceHistoryResponse.fromJson(response);
    } catch (e) {
      print("REPO ERR :: " + e.toString());
      res = OffenceHistoryResponse.fromJson(response);
    }
    return res;
  }
}


