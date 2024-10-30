import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/events/add_event_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/events/event_qr_screen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/event_response.dart';
import 'package:schoolworkspro_app/services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/login_response.dart';

import '../../prinicpal/principal_common_view_model.dart';

class EventLecturer extends StatefulWidget {
  bool? showAppBar;
  EventLecturer({Key? key, this.showAppBar}) : super(key: key);

  @override
  EventLecturerState createState() => EventLecturerState();
}

class EventLecturerState extends State<EventLecturer> {
  late Future<Eventresponse> event_response;
  List<Event> _appointmentDetails = <Event>[];
  bool connected = true;
  DateTime showDate = DateTime.now();

  bool isAdminCheck = false;

  @override
  void initState() {
    // TODO: implement initState

    event_response = EventService().getEvents();
    checkInternet();
    getUser();
    super.initState();
  }

  User? user;

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
      isAdminCheck = sharedPreferences.getBool("changedToAdmin")!;
    });
  }

  bool isLoading = false;

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }



  // _noticeModel = NotificationService().getNotice();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<PrinicpalCommonViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: (widget.showAppBar != null && widget.showAppBar == true) ||
                isAdminCheck == true
            ? AppBar(
                elevation: 0.0,
                actions: [
                  Row(
                    children: [
                      model.hasPermission(["add_update_event"])
                          ? InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const AddEventScreen(
                                    isUpdate: false,
                                  );
                                })).then((_) {
                                  event_response = EventService().getEvents();
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                ],
                title:
                    const Text("Events", ),)
            : null,
        body: connected == false
            ? const NoInternetWidget()
            : Center(
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

                        start =
                            start.add(const Duration(hours: 5, minutes: 45));

                        var formattedTime =
                            DateFormat('MM/DD/YY').format(start);
                        collection.add(Event(
                            eventName: showData[i].eventTitle,
                            id: showData[i].id,
                            isAllDay: false,
                            from:
                                DateTime.parse(showData[i].startDate.toString())
                                    .add(const Duration(hours: 5, minutes: 45)),
                            to: DateTime.parse(showData[i].endDate.toString())
                                .add(const Duration(hours: 5, minutes: 45)),
                            background: Colors.green,
                            details: showData[i].detail.toString(),
                            type: showData[i].eventType.toString()));
                      }
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: SfCalendar(
                              todayHighlightColor: kPrimaryColor,
                              selectionDecoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.red, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                shape: BoxShape.rectangle,
                              ),
                              showNavigationArrow: true,
                              view: CalendarView.month,
                              dataSource: MeetingDataSource(collection),
                              onTap: calendarTapped,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(DateFormat.yMMMEd().format(showDate)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 22),
                                  color: Colors.white,
                                  child: ListView.separated(
                                    // shrinkWrap: true,
                                    // physics: ScrollPhysics(),
                                    padding: const EdgeInsets.all(2),
                                    itemCount: _appointmentDetails.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(
                                                      _appointmentDetails[index]
                                                          .eventName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: Text(
                                                        _appointmentDetails[
                                                                index]
                                                            .details
                                                            .toString()));
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.green,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _appointmentDetails[index]
                                                      .eventName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              model.hasPermission([
                                                        "add_update_event"
                                                      ]) ||
                                                      model.hasPermission(
                                                          ["delete_event"])
                                                  ? IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: ((builder) =>
                                                              bottomSheet(
                                                                  _appointmentDetails,
                                                                  index,
                                                                  model)),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                      ))
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                      height: 5,
                                    ),
                                  )))
                        ],
                      );
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
              ),
      );
    });
  }

  Widget bottomSheet(
      List<Event> _appointmentDetails, index, PrinicpalCommonViewModel model) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          model.hasPermission(["add_update_event"])
              ? ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.qr_code_2),
                  title: const Text("Scan Qr"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EventQrScreen(
                        id: _appointmentDetails[index].id.toString(),
                      );
                    }));
                  },
                )
              : const SizedBox(),
          model.hasPermission(["add_update_event"])
              ? _appointmentDetails[index].type == "Holiday" ||
                      _appointmentDetails[index].type == "Student" ||
                      _appointmentDetails[index].type == "Common" ||
                      _appointmentDetails[index].type == "Course" ||
                      _appointmentDetails[index].type == "Batch" ||
                      _appointmentDetails[index].type == "Staff"
                  ? ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit),
                      title: Text("Edit Event"),
                      onTap: () {
                        Map<String, dynamic> data = {
                          "id": _appointmentDetails[index].id.toString(),
                          "title":
                              _appointmentDetails[index].eventName.toString(),
                          "detail": _appointmentDetails[index].details,
                          "to": _appointmentDetails[index].to,
                          "from": _appointmentDetails[index].from,
                          "type": _appointmentDetails[index].type,
                        };
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddEventScreen(
                            data: data,
                            isUpdate: true,
                          );
                        })).then((_) {
                          event_response = EventService().getEvents();
                        });
                      },
                    )
                  : const SizedBox()
              : const SizedBox(),

          // _appointmentDetails[index].type == "Holiday" ?
          model.hasPermission(["delete_event"])
              ? ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Event"),
                  onTap: () {
                    showAlertDialog(
                        context, _appointmentDetails[index].id.toString());
                  },
                )
              : const SizedBox()
          // : SizedBox(),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String id) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("Yes, Delete this Event"),
      onPressed: () async {
        try {
          final res = await EventService().deleteEvent(id);
          if (res.success == true) {
            setState(() {
              isLoading = true;
            });
            snackThis(
                context: context,
                color: Colors.green,
                content: Text(res.message.toString()));
            Navigator.of(context).popUntil((route) => route.isFirst);
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = true;
            });
            snackThis(
                context: context,
                color: Colors.red,
                content: Text(res.message.toString()));
            setState(() {
              isLoading = false;
            });
          }
        } on Exception catch (e) {
          setState(() {
            isLoading = true;
          });
          snackThis(
              context: context, color: Colors.red, content: Text(e.toString()));
          Navigator.of(context).pop();
          setState(() {
            isLoading = false;
          });
        }
      },
    );

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Event"),
      content: Text(
          "Are you sure you want to delete this event? This action cannot be undone!"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        showDate = calendarTapDetails.date!;
        _appointmentDetails = calendarTapDetails.appointments!.cast<Event>();
      });
    }
  }
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
      this.isAllDay = false,
      this.id,
      this.details,
      this.type});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? id;
  String? details;
  String? type;
}
