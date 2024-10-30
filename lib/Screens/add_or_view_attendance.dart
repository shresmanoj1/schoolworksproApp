import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:schoolworkspro_app/Screens/attendance_test.dart';
import 'package:schoolworkspro_app/Screens/view_attendance_screentest.dart';

import '../constants/colors.dart';

class ManipulateAttendanceScreen extends StatefulWidget {
  List<dynamic> modules;
  ManipulateAttendanceScreen({Key? key, required this.modules})
      : super(key: key);

  @override
  _ManipulateAttendanceScreenState createState() =>
      _ManipulateAttendanceScreenState();
}

class _ManipulateAttendanceScreenState
    extends State<ManipulateAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          // iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          centerTitle: false,
          title: const Text(
            "Student Attendance",
            style: TextStyle(color: white),
          ),
        ),
        body: ListView(
          children: [

            Lottie.asset('assets/12594-attendence.json'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAttendanceTestScreen(modules: widget.modules),));

                  },
                  child: Container(
                    height: 100,
                    child: Card(
                        color:Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.visibility),
                        Text("View Attendance ")
                      ],
                    )),
                  ),
                )),       Expanded(child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceTestScreen(modules: widget.modules),));
                  },
                  child: Container(
                    height: 100,
                    child: Card(
                        color:Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        const Text("New Attendance")
                      ],
                    )),
                  ),
                )),

              ],
            ),
          ],
        ));
  }
}
