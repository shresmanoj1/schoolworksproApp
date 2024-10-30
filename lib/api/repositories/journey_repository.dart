import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';

import '../../response/ispublic_response.dart';
import '../../response/journey_response.dart';

class JourneyRepository {
  API api = API();
  Future<Journeyresponse> getJourney() async {
    dynamic response;
    Journeyresponse res;

    try {
      response = await api.getWithToken(Endpoints.myJourney);
      res = Journeyresponse.fromJson(response);
    } catch (e) {
      res = Journeyresponse.fromJson(response);

    }
    return res;
  }

  Future<Publicresponse> updatePublicStatus() async {
    dynamic response;
    Publicresponse res;

    try{
      response = await api.putDataWithToken(null, Endpoints.isPublic);
      print("RAW RESPONSE:: " + response.toString());
      res = Publicresponse.fromJson(response);
    }catch(e){
      res = Publicresponse.fromJson(response);
      print("REPO ERR::: " + e.toString());

    }return res;
  }


}
