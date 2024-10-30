import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:schoolworkspro_app/response/principal/getallmodule_response.dart';

class ModuleRepositoryPrincipal {
  Future<GetAllModulesPrincipalResponse> getAllModules() async {
    API api = API();
    dynamic response;
    GetAllModulesPrincipalResponse res;
    try {
      response = await api.getWithToken('/modules/all');

      res = GetAllModulesPrincipalResponse.fromJson(response);
    } catch (e) {
      res = GetAllModulesPrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<GetBatchResponse> getassignedbatches(String slug) async {
    API api = API();
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api.getWithToken('/modules/$slug/batches');

      res = GetBatchResponse.fromJson(response);
    } catch (e) {
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }
}
