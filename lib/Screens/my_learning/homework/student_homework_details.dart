import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_view_model.dart';
import 'package:schoolworkspro_app/components/date_formatter.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../response/authenticateduser_response.dart';
import '../../../response/lecturer/get_homework_response.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

import '../components/assessment_submission_card.dart';

class StudentHomeWorkDetailsMainScreen extends StatefulWidget {
  final moduleSlug;
  Task task;
  StudentHomeWorkDetailsMainScreen(
      {Key? key, required this.moduleSlug, required this.task})
      : super(key: key);

  @override
  State<StudentHomeWorkDetailsMainScreen> createState() =>
      _StudentHomeWorkDetailsMainScreenState();
}

class _StudentHomeWorkDetailsMainScreenState
    extends State<StudentHomeWorkDetailsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => StudentHomeworkViewModel(),
        child: StudentHomeWorkDetailsScreen(
          task: widget.task,
          moduleSlug: widget.moduleSlug,
        ));
  }
}

class StudentHomeWorkDetailsScreen extends StatefulWidget {
  final moduleSlug;
  Task task;
  StudentHomeWorkDetailsScreen(
      {Key? key, required this.moduleSlug, required this.task})
      : super(key: key);
  @override
  State<StudentHomeWorkDetailsScreen> createState() =>
      _StudentHomeWorkDetailsScreenState();
}

class _StudentHomeWorkDetailsScreenState
    extends State<StudentHomeWorkDetailsScreen> {
  bool showAnswer = false;
  int clickedIndex = 0;
  User? user;
  @override
  void initState() {
    getData();
    super.initState();
  }

  late StudentHomeworkViewModel studentHomeworkViewModel;
  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentHomeworkViewModel =
          Provider.of<StudentHomeworkViewModel>(context, listen: false);
      studentHomeworkViewModel.fetchStudentInfo(
        widget.task.taskSlug.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentHomeworkViewModel>(
        builder: (context, getHomeWork, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Digital Diary",
              style: TextStyle(color: white),
            ),
            // backgroundColor: Colors.white,
            elevation: 0.0,
            // iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: isLoading(getHomeWork.getStudentInformationAssignment)
              ? const VerticalLoader()
              : ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Html(
                                data: widget.task.content,
                                customRender: {
                                  "table": (context, child) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child:
                                          (context.tree as TableLayoutElement)
                                              .toWidget(context),
                                    );
                                  }
                                },
                                onLinkTap: (String? url,
                                    RenderContext context,
                                    Map<String, String> attributes,
                                    dom.Element? element) {
                                  Future<void> _launchInBrowser(Uri url) async {
                                    if (await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw 'Could not launch $url';
                                    }
                                  }

                                  var linkUrl = url!.replaceAll(" ", "%20");
                                  _launchInBrowser(Uri.parse(linkUrl));
                                },
                                onImageTap: (String? url,
                                    RenderContext context,
                                    Map<String, String> attributes,
                                    dom.Element? element) {
                                  // print(url!);
                                  //open image in webview, or launch image in browser, or any other logic here
                                  launch(url!);
                                },
                              )),
                        ),
                        AssessmentSubmissionCard(
                            color: grey_200,
                            valueColor:
                                getHomeWork.studentInfo.userRecord == null
                                    ? Colors.red.shade200
                                    : greenLight,
                            label: "Submission status",
                            value: getHomeWork.studentInfo.userRecord == null
                                ? "Not Submitted"
                                : "Submitted"),
                        // AssessmentSubmissionCard(
                        //     color: white,
                        //     label: "Grading status",
                        //     value: getHomeWork.studentInfo.userRecord == null
                        //         ? "Not Submitted"
                        //         : "Submitted for grading"),
                        Builder(builder: (context) {
                          DateTime now =
                              DateTime.parse(widget.task.dueDate.toString());
                          now = now.add(const Duration(hours: 5, minutes: 45));
                          var formattedTime =
                              DateFormat('y, MMMM d, EEEE, hh:mm a')
                                  .format(now);
                          return AssessmentSubmissionCard(
                              color: white,
                              value: formattedTime,
                              label: "Due Date");
                        }),
                        AssessmentSubmissionCard(
                            count: getHomeWork.studentInfo.userRecord == null
                                ? 0
                                : 1,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Feedback"),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(Icons.close))
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color: getHomeWork.studentInfo
                                                          .userRecord ==
                                                      null
                                                  ? Colors.blue.shade100
                                                  : const Color(0xffc8e6c9),
                                            ),
                                            child: Text(
                                              getHomeWork.studentInfo
                                                          .userRecord ==
                                                      null
                                                  ? "Your assessment has not been reviewed yet!"
                                                  : getHomeWork
                                                          .studentInfo
                                                          .userRecord
                                                          ?.feedback ??
                                                      "",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            color: grey_200,
                            label: "Submission Comment",
                            value: getHomeWork.studentInfo.userRecord == null
                                ? "n/a"
                                : "widget"),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ));
    });
  }
}
