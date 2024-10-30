import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/module_wise_attendance_test.dart';
import 'package:schoolworkspro_app/Screens/one_time_test.dart';
import 'package:schoolworkspro_app/Screens/view_module_wise_attendance.dart';
import 'package:schoolworkspro_app/Screens/view_one_time_attendance_screen.dart';
import 'package:schoolworkspro_app/constants.dart';

class ViewAttendanceTestScreen extends StatefulWidget {
  List<dynamic> modules;
  ViewAttendanceTestScreen({Key? key,required this.modules}) : super(key: key);

  @override
  State<ViewAttendanceTestScreen> createState() => _ViewAttendanceTestScreenState();
}

class _ViewAttendanceTestScreenState extends State<ViewAttendanceTestScreen> {
  PageController pagecontroller = PageController();
  int selectedIndex = 0;
  String title = 'One Time Attendance';

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = 'One time attendance';
          }
          break;
        case 1:
          {
            title = 'Subject wise attendance';
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
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LecturerCommonViewModel>(builder: (context, value, child) {
      return Scaffold(
appBar: AppBar(
  title: const Text("View Attendance",style: TextStyle(color: Colors.black),),
  iconTheme: const IconThemeData(color: Colors.black),
  backgroundColor: Colors.white,
  elevation: 0.0
),
        body: PageView(
          controller: pagecontroller,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            const ViewOneTime(),
            ViewModuleAttendance(modules: widget.modules),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: _itemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 20,

                color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
              ),

              // ignore: deprecated_member_use
              label: 'One time attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: 20,
                color: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
              ),
              // ignore: deprecated_member_use
              label: 'Subject wise attendance',
            ),
          ],
        ),
      );
    });
  }
}