import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/activity/activity_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/activity/student_assessment_task_screen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/assessment_response.dart';
import 'package:schoolworkspro_app/response/particularmoduleresponse.dart';
import 'package:schoolworkspro_app/services/assessment_service.dart';
import 'package:intl/intl.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../lecturer/my-modules/lesson_component/insidelesson_body.dart';

class Activity extends StatefulWidget {
  String? moduleSlug;
  Assessmentresponse myAssessment;
  Activity({Key? key, this.moduleSlug, required this.myAssessment})
      : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Future<Assessmentresponse>? assessment_response;
  late ActivityViewModel _provider;
  List<bool> _isExpandedList = <bool>[];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ActivityViewModel>(context, listen: false);
    });
    setState(() {
      _isExpandedList = List.generate(
          widget.myAssessment.assessments == null
              ? 0
              : widget.myAssessment.assessments!.length,
          (index) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityViewModel>(builder: (context, snapshot, child) {
      return isLoading(snapshot.myAssessmentApiResponse)
          ? const Center(
              child: SpinKitDualRing(
                color: kPrimaryColor,
              ),
            )
          : snapshot.myAssessment.assessments == null ||
                  snapshot.myAssessment.assessments!.isEmpty
              ? Column(children: <Widget>[
                  Image.asset("assets/images/no_content.PNG"),
                ])
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: snapshot.myAssessment.assessments!.length,
                  itemBuilder: (context, i) {
                    var datas = snapshot.myAssessment.assessments![i];
                    return datas.assessments!.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: grey_400)),
                                    child: ExpansionTile(
                                        trailing: _isExpandedList[i]
                                            ? const Icon(
                                                Icons.remove,
                                                color: grey_600,
                                              )
                                            : const Icon(
                                                Icons.add,
                                                color: grey_600,
                                              ),
                                        onExpansionChanged: (isExpanded) {
                                          setState(() {
                                            _isExpandedList[i] = isExpanded;
                                            for (int j = 0;
                                                j < _isExpandedList.length;
                                                j++) {
                                              if (j != i) {
                                                _isExpandedList[i] = false;
                                              }
                                            }
                                          });
                                        },
                                        title: Text("Week ${datas.week}",
                                            style: p15),
                                        children: List.generate(
                                            datas.assessments!.length, (i) {
                                          var index = i + 1;
                                          DateTime now = DateTime.parse(datas
                                              .assessments![i].dueDate
                                              .toString());

                                          now = now.add(const Duration(
                                              hours: 5, minutes: 45));

                                          var formattedTime =
                                              DateFormat('dd MMM, yyyy')
                                                  .format(now);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  trailing: datas
                                                              .assessments![i]
                                                              .completed ==
                                                          true
                                                      ? const Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .dangerous_rounded,
                                                          color: Colors.red),
                                                  title: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Task $index : ${datas.assessments![i].lessonTitle!}",
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Chip(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          label: Text(
                                                              "Due on:  $formattedTime",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudentAssessmentTaskScreen(
                                                                lessonSlug: datas
                                                                    .assessments![
                                                                        i]
                                                                    .lessonSlug
                                                                    .toString(),
                                                                lessonTitle: datas
                                                                    .assessments![
                                                                        i]
                                                                    .lessonTitle
                                                                    .toString(),
                                                                isFromInside:
                                                                    false),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                  });
    });
  }
}
