import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_detail.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';

import 'lecturer/my-modules/attendance/onetime_attendance_detail.dart';

class ViewOneTime extends StatefulWidget {
  const ViewOneTime({Key? key}) : super(key: key);

  @override
  _ViewOneTimeState createState() => _ViewOneTimeState();
}

class _ViewOneTimeState extends State<ViewOneTime> {
  String? _myclass;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AttendanceViewModel>(context, listen: false).fetchclass();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AttendanceViewModel, ModuleAttendanceLecturer>(
        builder: (context, value, snapshot, child) {
      return ListView(
        children: [
          value.classes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No class found",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      border: OutlineInputBorder(),
                      filled: true,
                      hintText: 'Select class',
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: value.classes.map((item) {
                      return DropdownMenuItem(
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (newVal) async {
                      setState(() {
                        _myclass = newVal as String?;

                        // value.checkAttendance('School', _myclass.toString(),"Theory");
                        snapshot.fetchStudentAttendance('School', _myclass.toString());
                      });
                    },
                    value: _myclass,
                  ),
                ),
          _myclass == null
              ? SizedBox()
              : isLoading(snapshot.getAttendacenApiResponse)
                  ? VerticalLoader()
                  : snapshot.getStudentAttendance.isEmpty
                      ? Image.asset('assets/images/no_content.PNG')
                      : ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.getStudentAttendance.length,
                          itemBuilder: (context, index) {
                            DateTime start = DateTime.parse(snapshot
                                .getStudentAttendance[index]['createdAt']);
                            start = start
                                .add(const Duration(hours: 5, minutes: 45));
                            var formattedTime =
                                DateFormat('MMMM d yyyy').format(start);

                            return Row(children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularPercentIndicator(
                                    radius: 33.0,
                                    lineWidth: 6.0,
                                    percent: double.parse(snapshot
                                            .getStudentAttendance[index]
                                                ['presentPercentage']
                                            .split(".")[0]) /
                                        100,
                                    center: Text(
                                      snapshot.getStudentAttendance[index]
                                                  ['presentPercentage']
                                              .split(".")[0] +
                                          "%",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    progressColor: Colors.green,
                                    animationDuration: 100,
                                    animateFromLastPercent: true,
                                    arcType: ArcType.FULL,
                                    arcBackgroundColor: Colors.black12,
                                    backgroundColor: Colors.white,
                                    animation: true,
                                    circularStrokeCap: CircularStrokeCap.butt,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Attendance of: "),
                                      Text(formattedTime)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OneTimeAttendanceDetail(
                                            id: snapshot
                                                    .getStudentAttendance[index]
                                                ['_id'],
                                            absent_student: snapshot
                                                    .getStudentAttendance[index]
                                                ['absent_students'],
                                            present_student:
                                                snapshot.getStudentAttendance[
                                                    index]['present_students'],
                                            batch:
                                                snapshot.getStudentAttendance[
                                                    index]['batch'],
                                            module_slug: 'School',
                                            date: formattedTime,
                                          ),
                                        ));
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ]);
                          },
                        )
        ],
      );
    });
  }
}
