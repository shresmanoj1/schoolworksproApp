import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/response/attendancedetail_response.dart';

import 'package:schoolworkspro_app/services/attendancedetail_response.dart';

class AbsentDetailsStats extends StatefulWidget {
  final data;
  const AbsentDetailsStats({Key? key, this.data}) : super(key: key);

  @override
  _AbsentDetailsStatsState createState() => _AbsentDetailsStatsState();
}

class _AbsentDetailsStatsState extends State<AbsentDetailsStats> {
  Future<AttendanceDetailResponse>? attendance_detail;
  @override
  void initState() {
    // TODO: implement initState

    Map<String, dynamic> datas = {
      "batch": widget.data['batch'],
      "institution": widget.data['institution'],
    };
    attendance_detail = AttendanceDetailService()
        .attendanceDetail(datas, widget.data['username']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Absent Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
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
                    height: 200,
                    width: 200,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                attendance['moduleTitle'].toString(),
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
                                    attendance['studentAttendance'][l]
                                    ['date']
                                        .toString());

                                now = now.add(const Duration(
                                    hours: 5, minutes: 45));

                                var formattedTime =
                                DateFormat('y-MMMM-d, EEEE')
                                    .format(now);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0, vertical: 5),
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
              return VerticalLoader();
            }
          },
        ),
      ),
    );
  }
}
