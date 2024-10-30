import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/activities/activity_detail.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';

import 'package:schoolworkspro_app/response/activity_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/activity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../common_view_model.dart';
import '../../config/api_response_config.dart';
import '../../constants.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../my_learning/activity/student_assessment_task_screen.dart';

class Activities extends StatefulWidget {
  String username;

  Activities({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late CommonViewModel commmon;
  // Future<Activityresponse>? activityresponse;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CommonViewModel>(context, listen: false);
      // .getMyActivity(widget.username);
    });
    super.initState();
  }

  refreshScreen(CommonViewModel common){
    common.getMyActivity(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("My Task",
                style: TextStyle(color: white, fontWeight: FontWeight.w800)),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: white, //change your color here
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: Builder(builder: (context) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    unselectedLabelColor: white,
                    labelColor: Color(0xff004D96),
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: p1),
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
                        text: "Incompleted",
                      ),
                      Tab(
                        text: "Completed",
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
              child: Consumer<CommonViewModel>(
                builder: (context, common, child) {
                  return isLoading(common.MyActivityApiResponse)
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            common.incomplete.isEmpty
                                ? Column(children: <Widget>[
                                    Image.asset("assets/images/no_content.PNG"),
                                  ])
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: GroupedListView<Complete, String>(
                                      elements: common.incomplete,
                                      groupBy: (element) =>
                                          element.module!.moduleTitle!,
                                      groupComparator: (value1, value2) =>
                                          value2.compareTo(value1),
                                      itemComparator: (item1, item2) =>
                                          item1.lesson!.lessonTitle!.compareTo(
                                              item2.lesson!.lessonTitle!),
                                      order: GroupedListOrder.DESC,
                                      useStickyGroupSeparators: true,
                                      groupSeparatorBuilder: (String value) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      itemBuilder: (c, element) {
                                        DateTime now = DateTime.parse(element
                                            .assessment!.dueDate
                                            .toString());

                                        now = now.add(const Duration(
                                            hours: 5, minutes: 45));

                                        final formattedTime =
                                            DateFormat('yMMMMd').format(now);

                                        DateTime today = DateTime.now();
                                        final bool isExpired =
                                            now.isBefore(today);

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentAssessmentTaskScreen(
                                                        isFromInside: false,
                                                        lessonTitle: element
                                                                .lesson
                                                                ?.lessonTitle ??
                                                            "",
                                                        lessonSlug: element
                                                                .lesson
                                                                ?.lessonSlug ??
                                                            "",
                                                      )),
                                            );
                                          },
                                          child: ListTile(
                                              minVerticalPadding: 0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 0.0),
                                              title: Text(
                                                element.lesson!.lessonTitle!,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              trailing: Chip(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                backgroundColor: isExpired ==
                                                        true
                                                    ? const Color(0xffE80000)
                                                    : Colors.green,
                                                label: Text(
                                                  formattedTime,
                                                  style: const TextStyle(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        );
                                      },
                                    ),
                                  )
                          ],
                        );
                },
              ),
            ),
            SingleChildScrollView(
              child: Consumer<CommonViewModel>(
                builder: (context, common, child) {
                  return isLoading(common.MyActivityApiResponse)
                      ? const Center(child: CupertinoActivityIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            common.completed.isEmpty
                                ? Column(children: <Widget>[
                                    Image.asset("assets/images/no_content.PNG"),
                                  ])
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: GroupedListView<Complete, String>(
                                      elements: common.completed,
                                      groupBy: (element) =>
                                          element.module!.moduleTitle!,
                                      groupComparator: (value1, value2) =>
                                          value2.compareTo(value1),
                                      itemComparator: (item1, item2) =>
                                          item1.lesson!.lessonTitle!.compareTo(
                                              item2.lesson!.lessonTitle!),
                                      order: GroupedListOrder.DESC,
                                      useStickyGroupSeparators: true,
                                      groupSeparatorBuilder: (String value) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      itemBuilder: (c, element) {
                                        DateTime duedate = DateTime.parse(
                                            element.assessment!.dueDate
                                                .toString());

                                        DateTime now = DateTime.now();

                                        duedate = duedate.add(const Duration(
                                            hours: 5, minutes: 45));

                                        var formattedTime2 =
                                            DateFormat('yMMMMd')
                                                .format(duedate);

                                        final bool isExpired =
                                            duedate.isBefore(now);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentAssessmentTaskScreen(
                                                        isFromInside: false,
                                                        lessonTitle: element
                                                                .lesson
                                                                ?.lessonTitle ??
                                                            "",
                                                        lessonSlug: element
                                                                .lesson
                                                                ?.lessonSlug ??
                                                            "",
                                                      )),
                                            );
                                          },
                                          child: ListTile(
                                            minVerticalPadding: 0,
                                            trailing: Chip(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              backgroundColor: Colors.green,
                                              label: Text(
                                                formattedTime2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 0.0),
                                            title: Text(
                                              element.lesson!.lessonTitle!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                          ],
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
