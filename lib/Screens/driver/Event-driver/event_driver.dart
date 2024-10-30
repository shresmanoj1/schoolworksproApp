import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version/new_version.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/event_response.dart';
import 'package:schoolworkspro_app/services/event_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class EventDriverScreen extends StatefulWidget {
  const EventDriverScreen({Key? key}) : super(key: key);

  @override
  EventDriverScreenState createState() => EventDriverScreenState();
}

class EventDriverScreenState extends State<EventDriverScreen> {
  late Future<Eventresponse> event_response;
  bool connected = true;

  @override
  void initState() {
    // TODO: implement initState

    event_response = EventService().getEvents();
    super.initState();
  }




  // _noticeModel = NotificationService().getNotice();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: const Text("Events", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white),
      body: Center(
        child: FutureBuilder<Eventresponse>(
          future: event_response,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return ListView.builder(itemBuilder: (context, index) {
              var showData = snapshot.data!.events;

              List<Event> collection = [];

              for (int i = 0; i < showData.length; i++) {
                DateTime start =
                DateTime.parse(showData[i].startDate.toString());

                start = start.add(const Duration(hours: 5, minutes: 45));

                var formattedTime = DateFormat('MM/DD/YY').format(start);
                collection.add(Event(
                    eventName: showData[i].eventTitle,
                    isAllDay: false,
                    from: DateTime.parse(showData[i].startDate.toString())
                        .add(const Duration(hours: 5, minutes: 45)),
                    to: DateTime.parse(showData[i].endDate.toString())
                        .add(const Duration(hours: 5, minutes: 45)),
                    background: Colors.green));
              }
              return SizedBox(
                child: SfCalendar(

                  view: CalendarView.month,
                  showNavigationArrow: true,
                  todayHighlightColor: kPrimaryColor,
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                      startHour: 9,
                      nonWorkingDays: <int>[DateTime.saturday],
                      endHour: 16),
                  dataSource: MeetingDataSource(collection),
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                  initialSelectedDate: DateTime.now(),
                ),
              );
            } else {
              return const Center(
                  child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ));
            }
          },
        ),
      ),
    );
  }

// MeetingDataSource _getCalendarDataSource([List<Event> collection]) {
//   List<Event> meetings = collection ?? <Event>[];
//   return MeetingDataSource(meetings);
// }

// MettingDataSource _getCalendarDatSource([List<Event> collection])
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Event {
  Event(
      {this.eventName,
        this.from,
        this.to,
        this.background,
        this.isAllDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}
