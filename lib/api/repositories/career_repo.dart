import 'dart:convert';import 'package:hive/hive.dart';import 'package:schoolworkspro_app/api/api.dart';import 'package:schoolworkspro_app/response/all_job_response.dart';import 'package:schoolworkspro_app/response/common_response.dart';import 'package:schoolworkspro_app/response/job_finder_response.dart';import 'package:schoolworkspro_app/response/job_setting_respone.dart';import 'package:schoolworkspro_app/response/my_resume_response.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:http/http.dart' as http;import '../../config/hive.conf.dart';import '../../response/google_jobs_response.dart';import '../../response/job_detail_response.dart';import '../../response/my_application_response.dart';class CareerRepository {  API api = API();  Future<AllJobResponse> getAllJob(String page, dynamic filter) async {    API api = API();    dynamic response;    AllJobResponse res;    try {      response = await api.postDataWithToken(filter, "/job/filter-job/$page");      res = AllJobResponse.fromJson(response);    } catch (e) {      res = AllJobResponse.fromJson(response);    }    return res;  }  Future<JobDetailResponse> getJobDetails(String slug) async {    API api = API();    dynamic response;    JobDetailResponse res;    try {      response = await api.getWithToken("/job/job-details/$slug");      res = JobDetailResponse.fromJson(response);    } catch (e) {      res = JobDetailResponse.fromJson(response);    }    return res;  }  Future<Commonresponse> jobBookMark(String id, bool bookMark) async {    API api = API();    dynamic response;    Commonresponse res;    try {      var request = {"save": bookMark};      response = await api.putDataWithToken(          jsonEncode(request), "/job/toggle-save/$id");      res = Commonresponse.fromJson(response);    } catch (e) {      res = Commonresponse.fromJson(response);    }    return res;  }  Future<MyApplicationResponse> getMyApplication() async {    API api = API();    dynamic response;    MyApplicationResponse res;    try {      response = await api.getWithToken("/job/my-applications");      res = MyApplicationResponse.fromJson(response);    } catch (e) {      res = MyApplicationResponse.fromJson(response);    }    return res;  }  Future<MyResumeResponse> getMyResume() async {    API api = API();    dynamic response;    MyResumeResponse res;    try {      response = await api.getWithToken("/resumes/my-resume");      res = MyResumeResponse.fromJson(response);    } catch (e) {      res = MyResumeResponse.fromJson(response);    }    return res;  }  Future<Commonresponse> addReply(String data) async {    API api = API();    dynamic response;    Commonresponse res;    try {      response = await api.postDataWithToken(data, "/job/add-response");      res = Commonresponse.fromJson(response);    } catch (e) {      res = Commonresponse.fromJson(response);    }    return res;  }  Future<dynamic> getJobSetting() async {    final SharedPreferences sharedPreferences =        await SharedPreferences.getInstance();    print("[POST]:::::::::${api_url2 + '/job-setting/'}");    String? token = sharedPreferences.getString('token');    final response = await http.get(      Uri.parse(api_url2 + '/job-setting/'),      headers: {        'Authorization': 'Bearer $token',        'Content-Type': 'application/json; charset=utf-8',      },    );    if (response.statusCode == 200) {      var jsonMap = jsonDecode(response.body);      return jsonMap;    } else {      throw Exception('Failed to load offense history');    }  }  Future<GoogleJobsResponse> getGoogleJobs(List<String> tags) async {    final SharedPreferences sharedPreferences =        await SharedPreferences.getInstance();    Box box = HiveUtils.box;    final request = {"tags": tags};    GoogleJobsResponse res;    var url = "https://job.sageintegrity.com/api/get-jobs-google";    print(url);    String? token = sharedPreferences.getString('token');    final response = await http.post(Uri.parse(url),        headers: {          'Authorization': 'Bearer $token',          'Content-Type': 'application/json; charset=utf-8',        },        body: jsonEncode(request));    if (response.statusCode == 200) {      res = GoogleJobsResponse.fromJson(          jsonDecode(response.body)); // await box.put(url,res.toJson());    } else {      throw Exception('Failed to load data');    }    return res;  }  Future<JobFinderResponse> getJob(List<String> tags) async {    final SharedPreferences sharedPreferences =        await SharedPreferences.getInstance();    Box box = HiveUtils.box;    final request = {"tags": tags};    JobFinderResponse res;    var url = "https://job.sageintegrity.com/api/get-jobs";    print(url);    String? token = sharedPreferences.getString('token');    final response = await http.post(Uri.parse(url),        headers: {          'Authorization': 'Bearer $token',          'Content-Type': 'application/json; charset=utf-8',        },        body: jsonEncode(request));    if (response.statusCode == 200) {      res = JobFinderResponse.fromJson(jsonDecode(response.body));    } else {      throw Exception('Failed to load data');    }    return res;  }}