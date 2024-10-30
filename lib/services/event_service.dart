import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/add_event_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/event_response.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/principal/AddEventResponse.dart';
import 'package:schoolworkspro_app/response/principal/terminal_exam_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/parents/get_parents_events_response.dart';
import '../response/principal/event_attendance_response.dart';

class EventService {
  Future<Eventresponse> getEvents() async {
    var client = http.Client();
    var eventModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      var response = await client.get(
        Uri.parse(api_url2 + '/events/my-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        // print(response.body);
        eventModel = Eventresponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return eventModel;
    }

    return eventModel;
  }

  Future<GetParentsEventsResponse> getParentsEvents(String? institution, String? batch) async {
    var client = http.Client();
    var parentEventModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print(api_url2 + '/parents/all-events');



    var request = {
      "institution": institution,
      "batch": batch
    };

    print(request);

    try {
      var response = await client.post(
        Uri.parse(api_url2 + '/parents/all-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        }, body: jsonEncode(request)
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        print(response.body);
        parentEventModel = GetParentsEventsResponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return parentEventModel;
    }

    return parentEventModel;
  }


  Future<EventAttendanceResponse> getEventApplicants(String? eventId) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/event-guests/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      return EventAttendanceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load module');
    }
  }

  Future<AddEventResponse> addEvents(AddEventRequest data) async {
    API api = API();
    dynamic response;
    AddEventResponse res;
    try {
      print("DATA:::${data.toJson()}");
      response = await api.postDataWithToken(jsonEncode(data),"/events/add");


      res = AddEventResponse.fromJson(response);
    } catch (e) {
      print("RESPONSE:::::::${e}");
      res = AddEventResponse.fromJson(response);
    }
    return res;
  }

  Future<AddEventResponse> updateEvents(AddEventRequest data, String id) async {
    API api = API();
    dynamic response;
    AddEventResponse res;
    try {
      response = await api.putDataWithToken(jsonEncode(data),"/events/$id");

      res = AddEventResponse.fromJson(response);
    } catch (e) {
      res = AddEventResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> deleteEvent(String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteDataWithToken("/events/$id");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<TerminalExamResponse> getTerminal() async {
    API api = API();

    dynamic response;
    TerminalExamResponse res;
    try {
      response = await api.getWithToken('/terminal');
      res = TerminalExamResponse.fromJson(response);
    } catch (e) {
      res = TerminalExamResponse.fromJson(response);
    }
    return res;
  }
}
