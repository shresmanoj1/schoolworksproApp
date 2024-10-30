import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/school_addgrade_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/lecturer_studentreport.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/view_homework_screen.dart';
import 'package:schoolworkspro_app/api/api.dart';

import '../../../../constants/colors.dart';
import 'more_component/add_homework_task_screen.dart';
import 'more_component/mark_student.dart';

class MoreScreen extends StatefulWidget {
  final data;
  const MoreScreen({Key? key, this.data}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: ListView(
        children: [
          Builder(builder: (context) {
            var extension = widget.data['imageUrl'].split(".").last;

            return extension == "svg"
                ? SvgPicture.network(
                    api_url2 +
                        '/uploads/modules/' +
                        widget.data['imageUrl'],
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  )
                : Image.network(
                    api_url2 +
                        '/uploads/modules/' +
                        widget.data['imageUrl'],
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  );
          }),
          SizedBox(
            height: 15,
          ),
          // Card(
          //   child: ListTile(
          //     title: Text("Homework/Task"),
          //     onTap: () {},
          //   ),
          // ),

          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LecturerStudentReport(
                          moduleSlug: widget.data['moduleSlug']),
                    ));
              },
              title: const Text("Student Report"),
            ),
          ),
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 MarkStudentGrade(moduleSlug: widget.data['moduleSlug']),
          //           ));
          //     },
          //     title: const Text("Add Grades"),
          //   ),
          // ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewHomeworkScreen(moduleSlug: widget.data['moduleSlug'], moduleTitle: widget.data["moduleTitle"])
                          // HomeWorkTaskScreen(
                          // moduleSlug: widget.data['moduleSlug'],),
                    ));
              },
              title: const Text("Homework/Tasks"),
            ),
          ),
        ],
      ),
    );
  }
}
