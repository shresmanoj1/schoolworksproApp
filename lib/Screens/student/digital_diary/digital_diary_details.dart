import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../response/authenticateduser_response.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

import '../../../response/digital_diary_response.dart';
import '../../my_learning/components/assessment_submission_card.dart';

class DigitalDiaryDetailScreen extends StatefulWidget {
  final String moduleSlug;
  final Task task;
  const DigitalDiaryDetailScreen(
      {Key? key, required this.moduleSlug, required this.task})
      : super(key: key);

  @override
  State<DigitalDiaryDetailScreen> createState() =>
      _DigitalDiaryDetailScreenState();
}

class _DigitalDiaryDetailScreenState extends State<DigitalDiaryDetailScreen> {
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
  final String moduleSlug;
  final Task task;
  const StudentHomeWorkDetailsScreen(
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
  @override
  void initState() {
    getData();
    super.initState();
  }

  late StudentHomeworkViewModel studentHomeworkViewModel;
  getData() async {
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
            elevation: 0.0,
          ),
          body: ListView(
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
                  Padding(
                      padding: const EdgeInsets.all(7),
                      child: Html(
                        data: widget.task.content,
                        customRender: {
                          "table": (context, child) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: (context.tree as TableLayoutElement)
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
                          launch(url!);
                        },
                      )),
                  isLoading(getHomeWork.getStudentInformationAssignment)
                      ? const VerticalLoader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AssessmentSubmissionCard(
                                color: grey_200,
                                valueColor:
                                    getHomeWork.studentInfo.userRecord == null
                                        ? Colors.red.shade200
                                        : greenLight,
                                label: "Submission status",
                                value:
                                    getHomeWork.studentInfo.userRecord == null
                                        ? "Not Submitted"
                                        : "Submitted"),
                            Builder(builder: (context) {
                              DateTime now = DateTime.parse(
                                  widget.task.dueDate.toString());
                              now = now
                                  .add(const Duration(hours: 5, minutes: 45));
                              var formattedTime =
                                  DateFormat('y, MMMM d, EEEE, hh:mm a')
                                      .format(now);
                              return AssessmentSubmissionCard(
                                  color: white,
                                  value: formattedTime,
                                  label: "Due Date");
                            }),
                            AssessmentSubmissionCard(
                                count:
                                    getHomeWork.studentInfo.userRecord == null
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
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
                                value:
                                    getHomeWork.studentInfo.userRecord == null
                                        ? "n/a"
                                        : "widget"),
                          ],
                        )
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
