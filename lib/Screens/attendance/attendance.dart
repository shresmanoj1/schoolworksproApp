import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/attendance/components/attendance_widget.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/monthly_attendance_one_time_screen.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/monthly_attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/parent/attendance_request.dart';
import 'package:schoolworkspro_app/response/attendance_response.dart';
import 'package:schoolworkspro_app/response/attendancedetail_response.dart';
import 'package:schoolworkspro_app/result_view_model.dart';
import 'package:schoolworkspro_app/services/attendance_service.dart';
import 'package:schoolworkspro_app/services/attendancedetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../response/login_response.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  PageController pagecontroller = PageController();
  int selectedIndex = 0;
  String title = 'Overall Attendance';
  User? user;
  late CommonViewModel _provider;
  late MonthlyAttendanceViewModel _provider2;
  late ResultViewModel _provider3;
  @override
  void initState() {
    // TODO: implement initState
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);

      _provider2 =
          Provider.of<MonthlyAttendanceViewModel>(context, listen: false);

      _provider3 = Provider.of<ResultViewModel>(context, listen: false);

      _provider.fetchStudentSubjectWiseAttendance();
      Map<String, dynamic> data = {
        "batch": user?.batch,
        "username": user?.username,
        "institution": user?.institution
      };
      _provider2.fetchMonthlyReport(data);

      _provider3.fetchOverAllResult(data);

      Map<String, dynamic> datas = {
        "batch": user?.batch.toString(),
        "institution": user?.institution.toString(),
      };

      _provider2.fetchAbsentReport(user!.username.toString(), datas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Consumer2<CommonViewModel, MonthlyAttendanceViewModel>(
          builder: (context, common, monthlyApi, child) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: false,
                title: const Text('Attendance',
                    style:
                        TextStyle(color: white, fontWeight: FontWeight.w800)),
                elevation: 0.0,
                iconTheme: const IconThemeData(
                  color: white,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Builder(builder: (context) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBar(
                        indicatorColor: logoTheme,
                        indicatorWeight: 4.0,
                        isScrollable: true,
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        unselectedLabelColor: white,
                        labelColor: Color(0xff004D96),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: p1),
                        indicator: BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          color: white,
                        ),
                        tabs: [
                          Tab(
                            text: "Subject wise Attendance",
                          ),
                          Tab(
                            text: "Monthly Attendance",
                          ),
                          Tab(
                            text: "Absent Report",
                          )
                        ],
                      ),
                    );
                  }),
                ),
                backgroundColor: logoTheme),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: isLoading(
                          common.studentSubjectWiseAttendanceApiResponse)
                      ? const CupertinoActivityIndicator()
                      : common.studentSubjectWiseAttendance.allAttendance ==
                                  null ||
                              common.studentSubjectWiseAttendance.allAttendance!
                                  .isEmpty
                          ? Image.asset("assets/images/no_content.PNG")
                          : Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: common
                                        .studentSubjectWiseAttendance
                                        .allAttendance!
                                        .length,
                                    itemBuilder: (context, index) {
                                      var attendance = common
                                          .studentSubjectWiseAttendance
                                          .allAttendance![index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 7),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          decoration: BoxDecoration(
                                              color: (index % 2 == 0)
                                                  ? const Color(0xffCE3B7B)
                                                  : logoTheme,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey.shade300)),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Text(
                                                    attendance.moduleTitle
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                trailing: RichText(
                                                  text: TextSpan(
                                                      text: attendance
                                                                  .percentage !=
                                                              null
                                                          ? attendance
                                                              .percentage!
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString()
                                                          : "0",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: white,
                                                        fontSize: 22,
                                                      ),
                                                      children: const [
                                                        TextSpan(
                                                          text: "%",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: white,
                                                              fontSize: 22),
                                                        ),
                                                      ]),
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Present: ",
                                                          style:
                                                              const TextStyle(
                                                                  color: white,
                                                                  fontSize: 16),
                                                          children: [
                                                            TextSpan(
                                                              text: attendance
                                                                  .presentDays
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      color:
                                                                          white,
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Absent : ",
                                                          style:
                                                              const TextStyle(
                                                                  color: white,
                                                                  fontSize: 16),
                                                          children: [
                                                            TextSpan(
                                                              text: attendance
                                                                  .absentDays
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: white),
                                                            ),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                ),
                OneTimeAttendanceReportScreen(
                    batch: user?.batch.toString(),
                    institution: user?.institution.toString(),
                    username: user?.username.toString()),
                SingleChildScrollView(
                  child: isLoading(monthlyApi.studentAbsentReportApiResponse)
                      ? const CupertinoActivityIndicator()
                      : monthlyApi.absentReport.allAttendance == null ||
                              monthlyApi.absentReport.allAttendance!.isEmpty
                          ? Image.asset("assets/images/no_content.PNG")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount:
                                  monthlyApi.absentReport.allAttendance!.length,
                              itemBuilder: (context, index) {
                                var attendance = monthlyApi
                                    .absentReport.allAttendance![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0, vertical: 7),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey.shade300)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          attendance['moduleTitle'].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 7,
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
                                                DateFormat('E, d MMM yyy')
                                                    .format(now);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0),
                                              child: Text(
                                                "Absent on: ${formattedTime.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                  // FutureBuilder<AttendanceDetailResponse>(
                  //   future: attendance_detail,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return snapshot.data!.allAttendance!.isEmpty
                  //           ? Column(
                  //               children: [
                  //                 Image.asset(
                  //                   "assets/images/no_content.PNG",
                  //                 ),
                  //                 const Text("No data found",
                  //                     textAlign: TextAlign.center),
                  //               ],
                  //             )
                  //           :
                  //     } else if (snapshot.hasError) {
                  //       return Text('{$snapshot.error}');
                  //     } else {
                  //       return const Center(child: CupertinoActivityIndicator()
                  //           //     SpinKitDualRing(
                  //           //   color: kPrimaryColor,
                  //           // )
                  //           );
                  //     }
                  //   },
                  // ),
                ),
              ],
            ));
      }),
    );
  }
}
