import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/monthly_attendance_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../../utils/response/login_response.dart';

class OneTimeAttendanceReportScreen extends StatelessWidget {
  final batch;
  final username;
  final institution;
  const OneTimeAttendanceReportScreen(
      {Key? key, this.batch, this.username, this.institution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OneTimeAttendanceReportBody(
        batch: batch, username: username, institution: institution);
  }
}

class OneTimeAttendanceReportBody extends StatefulWidget {
  final batch;
  final username;
  final institution;
  const OneTimeAttendanceReportBody(
      {Key? key, this.batch, this.username, this.institution})
      : super(key: key);

  @override
  State<OneTimeAttendanceReportBody> createState() =>
      _OneTimeAttendanceReportBodyState();
}

class _OneTimeAttendanceReportBodyState
    extends State<OneTimeAttendanceReportBody> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Map<String, dynamic> data = {
        "batch": widget.batch,
        "username": widget.username,
        "institution": widget.institution
      };
      Provider.of<MonthlyAttendanceViewModel>(context, listen: false)
          .fetchMonthlyReport(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthlyAttendanceViewModel>(
        builder: (context, value, child) {
      return isLoading(value.resultApiResponse)
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : value.overallResult.isEmpty
              ? Column(
                  children: [
                    Image.asset(
                      "assets/images/no_content.PNG",
                    ),
                    const Text("No data found", textAlign: TextAlign.center),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: value.overallResult.length,
                  itemBuilder: (context, index) {
                    var attendance = value.overallResult[index];

                    var displaytext = (attendance.percentage == null ||
                            attendance.percentage.toString() == "NaN")
                        ? 0
                        : attendance.percentage.toString().split(".")[0];
                    // var displaytext = double.parse(attendance['percentage'].split(".")[0]);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 7),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Column(
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "${attendance.month}, ${attendance.year}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Present: ",
                                        style: const TextStyle(
                                            color: black, fontSize: 15),
                                        children: [
                                          TextSpan(
                                            text: attendance.presentDays
                                                .toString(),
                                            style: const TextStyle(
                                                color: Color(0xff767676),
                                                fontSize: 15),
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: "Total days: ",
                                        style: const TextStyle(
                                            color: black, fontSize: 15),
                                        children: [
                                          TextSpan(
                                            text: attendance.totalAttendance
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff767676)),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: LinearPercentIndicator(
                                lineHeight: 20.0,
                                center: Text(
                                  "$displaytext%",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                percent: (attendance.percentage == null ||
                                        attendance.percentage.toString() ==
                                            "NaN")
                                    ? 0
                                    : double.parse(
                                            attendance.percentage.toString()) /
                                        100,

                                // header:Center(child: Text(progress['moduleTitle'],overflow: TextOverflow.ellipsis,)),
                                backgroundColor: double.parse(
                                            attendance.percentage.toString()) >=
                                        80
                                    ? Colors.green.withOpacity(0.15)
                                    : Color(0xff195DE6).withOpacity(0.15),
                                progressColor: double.parse(
                                            attendance.percentage.toString()) >=
                                        80
                                    ? Colors.green
                                    : Color(0xff195DE6),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width -
                            //               120,
                            //       child: Container(
                            //         height: 200,
                            //         width: 200,
                            //         child: SfRadialGauge(
                            //           axes: <RadialAxis>[
                            //             RadialAxis(
                            //                 minimum: 0,
                            //                 maximum: 100,
                            //                 interval: 10,
                            //                 ranges: <GaugeRange>[
                            //                   GaugeRange(
                            //                       startValue: 0,
                            //                       endValue: 80,
                            //                       color: Colors.red),
                            //                   GaugeRange(
                            //                       startValue: 80,
                            //                       endValue: 100,
                            //                       color: Colors.green),
                            //                 ],
                            //                 pointers: <GaugePointer>[
                            //                   NeedlePointer(
                            //                     value: double.parse(
                            //                         attendance[
                            //                                 'percentage']
                            //                             .toString()),
                            //                     enableAnimation: true,
                            //                   ),
                            //                 ],
                            //                 annotations: <
                            //                     GaugeAnnotation>[
                            //                   GaugeAnnotation(
                            //                     widget: attendance[
                            //                                 'percentage'] ==
                            //                             null
                            //                         ? const Padding(
                            //                             padding:
                            //                                 EdgeInsets
                            //                                     .all(8.0),
                            //                             child: Text(
                            //                               "0%",
                            //                               style: TextStyle(
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold),
                            //                               textAlign:
                            //                                   TextAlign
                            //                                       .justify,
                            //                             ),
                            //                           )
                            //                         : Padding(
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                     .all(8.0),
                            //                             child: Text(
                            //                                 attendance['percentage']!
                            //                                         .round()
                            //                                         .toString() +
                            //                                     "%",
                            //                                 style: const TextStyle(
                            //                                     fontWeight:
                            //                                         FontWeight
                            //                                             .bold)),
                            //                           ),
                            //                     positionFactor: 0.5,
                            //                     angle: 90,
                            //                   )
                            //                 ]),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     Column(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.start,
                            //       crossAxisAlignment:
                            //           CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Present: " +
                            //               attendance['presentDays']
                            //                   .toString(),
                            //           style: const TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.green),
                            //         ),
                            //         Text(
                            //           "Absent:  " +
                            //               attendance['absentDays']
                            //                   .toString(),
                            //           style: const TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.red),
                            //         ),
                            //       ],
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                );
    });
  }
}
