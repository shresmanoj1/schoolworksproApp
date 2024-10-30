import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:schoolworkspro_app/Screens/lecturer/routines-lecturer/routinelecturer_detailscreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/student_leave/view_student_leave_screen.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/routinelecturer_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/lecturer/routinelecturer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
// import 'package:in_app_update/in_app_update.dart';

class RoutineLecturer extends StatefulWidget {
  static String routeName = "/routinelecturer";
  const RoutineLecturer({Key? key}) : super(key: key);

  @override
  RoutineLecturerState createState() => RoutineLecturerState();
}

class RoutineLecturerState extends State<RoutineLecturer> {
  Future<RoutineLecturerResponse>? routine_response;
  // late Future<Authenticateduserresponse> get_user;
  User? user;
  bool isRoutine = true;
  bool connected = true;
  bool isSwitched = false;

  // User? user;

  @override
  void initState() {
    // TODO: implement initState

    getData();

    // check();

    // checkForUpdate();
    checkInternet();
    super.initState();
  }

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
        // snackThis(context: context,content: const Text("No Internet Connection"),duration: 10,color: Colors.red.shade500);
        // Fluttertoast.showToast(msg: "No Internet connection");
      }
    });
  }



  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    routine_response =
        RoutineLecturerService().getroutineforlecturer(user!.email.toString());
    final checkRoutine = await RoutineLecturerService()
        .getroutineforlecturer(user!.email.toString());
    // print(jsonEncode(checkRoutine.routines));
    if (checkRoutine.routines!.isEmpty) {
      setState(() {
        isRoutine = false;
      });
    } else {
      setState(() {
        isRoutine = true;
      });
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            // iconTheme: const IconThemeData(
            //   color: Colors.black, //change your color here
            // ),
            title: const Text("Routines and timetables",
                style: TextStyle(color: white)),
            actions: [],
            // backgroundColor: Colors.white
    ),
        body: connected == false
            ? NoInternetWidget()
            : isRoutine == false
                ? Column(children: <Widget>[
                    Image.asset("assets/images/no_content.PNG"),
                  ])
                : FutureBuilder<RoutineLecturerResponse>(
                    future: routine_response,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10,),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            ViewStudentLeaveScreen()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0XFF1ac790)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ))),
                                      child: Text("Students on Leave")),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              GroupedListView<dynamic, String>(
                                elements: snapshot.data!.routines!,
                                shrinkWrap: true,
                                sort: true,
                                physics: const ScrollPhysics(),
                                groupBy: (element) => getWeekString(
                                        DateFormat('EEEE').format(
                                            DateTime.parse(element['start'])))
                                    .toString(),
                                groupComparator: (value1, value2) =>
                                    value2.compareTo(value1),
                                itemComparator: (item1, item2) =>
                                    DateFormat('EEEE')
                                        .format(DateTime.parse(item1['start']))
                                        .compareTo(DateFormat('EEEE').format(
                                            DateTime.parse(item2['start']))),
                                order: GroupedListOrder.DESC,
                                useStickyGroupSeparators: true,
                                groupSeparatorBuilder: (String value) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Builder(builder: (context) {
                                    return Text(
                                      value.toString() == "1"
                                          ? "Sunday"
                                          : value.toString() == "2"
                                              ? "Monday"
                                              : value.toString() == "3"
                                                  ? "Tuesday"
                                                  : value.toString() == "4"
                                                      ? "Wednesday"
                                                      : value.toString() == "5"
                                                          ? "Thursday"
                                                          : value.toString() ==
                                                                  "6"
                                                              ? "Friday"
                                                              : "Saturday",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  }),
                                ),
                                itemBuilder: (c, element) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: element["isCancelled"] == null
                                              ? Colors.green
                                              : element['isCancelled'] == true
                                                  ? Color(0xff17a2b8)
                                                  : Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Routinelecturerdetailscreen(
                                                        data: element),
                                              ));
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 4),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Title: " + element['title'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            element['module'] == null ||
                                                    element['module'].isEmpty
                                                ? const SizedBox()
                                                : Text(
                                                    "Alias: " +
                                                        element['module']
                                                            ['alias'],
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                              DateFormat.jm()
                                                  .format(DateTime.parse(
                                                          element['start'])
                                                      .add(const Duration(
                                                          hours: 5, minutes: 45)))
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const Text(
                                              ' - ',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              DateFormat.jm()
                                                  .format(DateTime.parse(
                                                          element['end'])
                                                      .add(Duration(
                                                          hours: 5, minutes: 45)))
                                                  .toString(),
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            element["isCancelled"] == null
                                                ? Container()
                                                : element['isCancelled'] == true
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 4,
                                                                vertical: 1),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.red[400],
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            4))),
                                                        child: Text(
                                                          "Class Cancelled",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return VerticalLoader();
                      }
                    },
                  ));
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Event eventdetails = details.appointments![0];
      DateTime start = DateTime.parse(eventdetails.from.toString());

      var startDate = DateFormat('hh:mm a').format(start);

      var day = DateFormat('EEEE').format(start);

      DateTime end = DateTime.parse(eventdetails.to.toString());

      var endDate = DateFormat('hh:mm a').format(end);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Column(
                  children: [
                    Text(day),
                    Text("$startDate-$endDate"),
                  ],
                ),
                content: SizedBox(
                  height: eventdetails.link == null ? 200 : 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Text(
                            "subject: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(eventdetails.eventName!),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "lecturer: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(eventdetails.lecturer!),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Block: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(eventdetails.block!),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "class room: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(eventdetails.classroom!),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          const Text(
                            "class link: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () {
                                _launchURL(eventdetails.link!);
                              },
                              child: Text(
                                eventdetails.link!,
                                style: const TextStyle(color: Colors.blue),
                                textAlign: TextAlign.justify,
                              )),
                        ],
                      ),
                    ],
                  ),
                ));
          });
    }
  }

  _launchURL(String abc) async {
    String url = abc;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  dynamic getWeekString(dynamic data) {
    switch (data) {
      case "Sunday":
        return 1;
      case "Monday":
        return 2;
      case "Tuesday":
        return 3;
      case "Wednesday":
        return 4;
      case "Thursday":
        return 5;
      case "Friday":
        return 6;
      case "Saturday":
        return 7;
      default:
        return 'Err';
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
  // ignore: override_on_non_overriding_member
  String getLecturer(int index) {
    return appointments![index].lecturer;
  }

  @override
  // ignore: override_on_non_overriding_member
  String getBlock(int index) {
    return appointments![index].block;
  }

  @override
  // ignore: override_on_non_overriding_member
  String getLink(int index) {
    return appointments![index].link;
  }

  @override
  // ignore: override_on_non_overriding_member
  String getClassroom(int index) {
    return appointments![index].classroom;
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
      this.lecturer,
      this.block,
      this.classroom,
      this.link,
      this.to,
      this.background,
      this.isAllDay = false});

  String? eventName;
  String? lecturer;
  String? block;
  String? classroom;
  String? link;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}

extension DateTimeExtension on DateTime {
  String getWeekString() {
    switch (weekday) {
      case 1:
        return 'Sunday';
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thursday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      default:
        return 'Err';
    }
  }
}
