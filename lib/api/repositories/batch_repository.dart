import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/get_ota_response.dart';
import 'package:schoolworkspro_app/response/getallbatch_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';

import '../../response/accessedmodule_response.dart';
import '../../response/lecturer/batchpercourse_response.dart';

class BatchRepository {
  API api = API();
  Future<GetBatchResponse> getbatches(String moduleSlug) async {
    API api = new API();
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api.getWithToken('/modules/$moduleSlug/batches');


      res = GetBatchResponse.fromJson(response);
    } catch (e) {
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }
  Future<GetBatchResponse> getbatchesIFOneTime(String moduleSlug) async {
    API api = new API();
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api.getWithToken('/modules/$moduleSlug/attendance-batches');


      res = GetBatchResponse.fromJson(response);
    } catch (e) {
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }

  Future<GetOtaResponse> getOTAtrue() async {

    dynamic response;
    GetOtaResponse res;
    try {
      response = await api.getWithToken('/batch/get/ota-enabled-batches/true');


      res = GetOtaResponse.fromJson(response);
    } catch (e) {
      res = GetOtaResponse.fromJson(response);
    }
    return res;
  }

  Future<GetBatchResponse> getCurrentBatches(String moduleSlug) async {
    API api = new API();
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api.getWithToken('/modules/$moduleSlug/currentBatches');

      res = GetBatchResponse.fromJson(response);
    } catch (e) {
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }

  Future<GetAllBatchResponse> getAllBatch() async {
    API api = new API();
    dynamic response;
    GetAllBatchResponse res;
    try {
      response = await api.getWithToken('/batch/all');

      res = GetAllBatchResponse.fromJson(response);

    } catch (e) {
      res = GetAllBatchResponse.fromJson(response);
    }
    return res;
  }

  Future<GetBatchResponse> getLessonAccessBatch(
      String moduleSlug, String lessonSlug) async {
    API api = new API();
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api
          .getWithToken('/assessments/accessBatch/$moduleSlug/$lessonSlug');

      res = GetBatchResponse.fromJson(response);
    } catch (e) {
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }


  Future<BatchpercourseResponse> getCourseBatch(String courseSlug) async {
    API api = new API();
    dynamic response;
    BatchpercourseResponse res;
    try {
      response = await api.getWithToken('/batch/$courseSlug');

      res = BatchpercourseResponse.fromJson(response);
    } catch (e) {
      res = BatchpercourseResponse.fromJson(response);
    }
    return res;
  }
}
