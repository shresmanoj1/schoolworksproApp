import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_screen.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../lecturer/my-modules/components/more_component/view_homework_screen.dart';

class HomeWorkTabScreen extends StatelessWidget {
  final String? moduleSlug;
  final dynamic data;
  final bool? isTeacher;
  const HomeWorkTabScreen({Key? key, this.isTeacher, this.moduleSlug, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              bottom: const TabBar(
                indicatorColor: logoTheme,
                indicatorWeight: 4.0,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'Homework/Diary',
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Assignment',
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: isTeacher == true ?  TabBarView(
            children: [
              ViewHomeworkScreen(moduleSlug: data['moduleSlug'], moduleTitle: data["moduleTitle"]),
              AssignmentScreen(moduleSlug: data['moduleSlug'], isTeacher: true),
            ],
          ) : TabBarView(
            children: [
              StudentHomeWorkMainScreen(moduleSlug: moduleSlug,),
              AssignmentScreen(moduleSlug: moduleSlug, isTeacher: false),
            ],
          ),
      ),
    );
  }
}

