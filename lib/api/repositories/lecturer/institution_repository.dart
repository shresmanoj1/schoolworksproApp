import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';

class InstitutionRepository{
  Future<InstitutionDetailForIdResponse> getinstitution() async {
    API api = new API();
    Box box = HiveUtils.box;
    dynamic response;
    InstitutionDetailForIdResponse res;
    try {
      response = await api.getWithToken(Endpoints.getInstitutiondetails);

      res = InstitutionDetailForIdResponse.fromJson(response);
      await box.put(Endpoints.getInstitutiondetails, res.toJson());
    } catch (e) {
      print(e.toString());
      response = await box.get(Endpoints.getInstitutiondetails);
      // print("asas"+response.toString());
      res = InstitutionDetailForIdResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}


