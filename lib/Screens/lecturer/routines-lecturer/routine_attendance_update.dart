
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/attendance/all_attendance_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';

import '../my-modules/attendance/attendance_detail.dart';

class RoutineAttendanceUpdateScreen extends StatefulWidget {
  final batch;
  final moduleSlug;
  final selected_attendance_type;
  const RoutineAttendanceUpdateScreen({Key? key, this.batch, this.moduleSlug, required this.selected_attendance_type}) : super(key: key);

  @override
  _RoutineAttendanceUpdateScreenState createState() =>
      _RoutineAttendanceUpdateScreenState();
}

class _RoutineAttendanceUpdateScreenState
    extends State<RoutineAttendanceUpdateScreen> {

  late CommonViewModel commonViewModel;
  late AttendanceViewModel allAttendanceViewModel;
  late ModuleAttendanceLecturer moduleAttendanceLecturer;



  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AttendanceViewModel>(context, listen: false).fetchclass();
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      allAttendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: false);
      moduleAttendanceLecturer = Provider.of<ModuleAttendanceLecturer>(context, listen: false);
      // allAttendanceViewModel.checkAttendance(
      //     widget.moduleSlug.toString(),
      //     widget.batch.toString());
      moduleAttendanceLecturer.fetchStudentAttendance(
          widget.moduleSlug.toString(),
          widget.batch.toString());
    });
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
          "Update Attendance",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer3<AttendanceViewModel,
          CommonViewModel, ModuleAttendanceLecturer>(
          builder: (context, value, common, mcl, child) {
            return ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [

                ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: mcl.getStudentAttendance.length,
                  itemBuilder: (context, index) {
                    DateTime start = DateTime.parse(mcl
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
                            percent: double.parse(mcl
                                .getStudentAttendance[index]
                            ['presentPercentage']
                                .split(".")[0]) /
                                100,
                            center: Text(
                              mcl.getStudentAttendance[index]
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
                            circularStrokeCap:
                            CircularStrokeCap.butt,
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
                              Text(formattedTime),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal : 6),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                                  child: Text(mcl.getStudentAttendance[index]["attendanceType"]))
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
                                      AttendanceDetail(
                                        id: mcl.getStudentAttendance[
                                        index]['_id'],
                                        absent_student: mcl
                                            .getStudentAttendance[
                                        index]['absent_students'],
                                        present_student: mcl
                                            .getStudentAttendance[
                                        index]['present_students'],
                                        batch: mcl.getStudentAttendance[
                                        index]['batch'],
                                        module_slug:
                                        widget.moduleSlug.toString(),
                                        date: formattedTime,
                                        attendanceType: widget.selected_attendance_type,
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
          }),
    );
  }
}
