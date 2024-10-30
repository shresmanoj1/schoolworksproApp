import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:schoolworkspro_app/Screens/attendance/components/attendance_widget.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/monthly_attendance_one_time_screen.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/parent/attendance_request.dart';
import 'package:schoolworkspro_app/response/attendance_response.dart';
import 'package:schoolworkspro_app/response/attendancedetail_response.dart';
import 'package:schoolworkspro_app/services/attendance_service.dart';
import 'package:schoolworkspro_app/services/attendancedetail_response.dart';
import 'package:schoolworkspro_app/services/parents/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../response/parents/childattendance_response.dart';
import '../../../utils/response/login_response.dart';
import '../../prinicpal/student_attendance/overall_attendance_screen.dart';

class AttendanceParent extends StatefulWidget {
  final bool isParent;
  final batch;
  final institution;
  final username;
  const AttendanceParent(
      {Key? key,
      this.batch,
      this.institution,
      this.username,
      this.isParent = false})
      : super(key: key);

  @override
  State<AttendanceParent> createState() => _AttendanceParentState();
}

class _AttendanceParentState extends State<AttendanceParent> {
  Future<Attendanceresponse>? _attendance;
  PageController pagecontroller = PageController();

  Future<ChildAttendanceResponse>? attendance_response;
  Future<AttendanceDetailResponse>? attendance_detail;
  int selectedIndex = 0;
  String title = 'Overall Attendance';
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    _attendance = Attendanceservice().getAttendance();
    checkInternet();
    super.initState();
  }

  bool connected = false;
  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
        getData();
      } else {
        setState(() {
          connected = false;
        });
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

    Map<String, dynamic> datas = {
      "batch": widget.batch.toString(),
      "institution": widget.institution.toString(),
    };
    attendance_detail = AttendanceDetailService()
        .attendanceDetail(datas, widget.username.toString());

    final attendanceheader = Attendancerequest(
        batch: widget.batch,
        institution: widget.institution,
        username: widget.username);

    attendance_response =
        ChildAttendanceService().getchildattendance(attendanceheader);
  }

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = 'Overall Attendance';
          }
          break;
        case 1:
          {
            title = 'Absent days';
          }
          break;
      }
    });
  }

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Attendance',
                  style: TextStyle(color: Colors.black)),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              bottom: PreferredSize(
                preferredSize: widget.isParent == true
                    ? const Size.fromHeight(40.0)
                    : Size.fromHeight(
                        70.0 - MediaQuery.of(context).viewPadding.top),
                child: Container(
                  color: Colors.white,
                  child: Builder(builder: (context) {
                    return const TabBar(
                      isScrollable: true,
                      indicatorColor: kPrimaryColor,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          text: "Subject wise Attendance",
                        ),
                        Tab(
                          text: "Monthly Attendance",
                        ),
                        Tab(
                          text: "Absent Report",
                        ),
                        Tab(
                          text: "Overall Attendance",
                        )
                      ],
                    );
                  }),
                ),
              ),
              backgroundColor: Colors.white),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: FutureBuilder<ChildAttendanceResponse>(
                  future: attendance_response,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.allAttendance!.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/no_content.PNG",
                                  height: 200,
                                  width: 200,
                                ),
                                const Text("No module started",
                                    textAlign: TextAlign.center),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.allAttendance!.length,
                              itemBuilder: (context, index) {
                                var attendance =
                                    snapshot.data!.allAttendance![index];
                                var totalDays = attendance['presentDays'] +
                                    attendance['absentDays'];

                                var displaytext = attendance['percentage']
                                    .toString()
                                    .split(".")[0];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            attendance['moduleTitle']
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Text(
                                            "${attendance['presentDays']}/$totalDays",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Present: ${attendance['presentDays']}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                "Absent:  ${attendance['absentDays']}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: LinearPercentIndicator(
                                            lineHeight: 16.0,
                                            center: Text(
                                              "$displaytext%",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            percent:
                                                attendance['percentage'] / 100,

                                            // header:Center(child: Text(progress['moduleTitle'],overflow: TextOverflow.ellipsis,)),
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            progressColor:
                                                attendance['percentage'] >= 80
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                    } else if (snapshot.hasError) {
                      return Text('{$snapshot.error}');
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
              ),
              OneTimeAttendanceReportScreen(
                  batch: widget.batch.toString(),
                  institution: widget.institution.toString(),
                  username: widget.username.toString()),
              SingleChildScrollView(
                child: FutureBuilder<AttendanceDetailResponse>(
                  future: attendance_detail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.allAttendance!.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/no_content.PNG",
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.allAttendance!.length,
                              itemBuilder: (context, index) {
                                var attendance =
                                    snapshot.data!.allAttendance![index];

                                // var displaytext = double.parse(attendance['percentage'].split(".")[0]);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0),
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            attendance['moduleTitle']
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount:
                                              attendance['studentAttendance']
                                                  .length,
                                          itemBuilder: (context, l) {
                                            DateTime now = DateTime.parse(
                                                attendance['studentAttendance']
                                                        [l]['date']
                                                    .toString());

                                            now = now.add(const Duration(
                                                hours: 5, minutes: 45));

                                            var formattedTime =
                                                DateFormat('y-MMMM-d, EEEE')
                                                    .format(now);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13.0,
                                                      vertical: 5),
                                              child: Text(
                                                  "Absent on: ${formattedTime.toString()}"),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                    } else if (snapshot.hasError) {
                      return Text('{$snapshot.error}');
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
              ),
              OverallAttendanceScreen(username: widget.username ?? "")
            ],
          )),
    );
  }
}
