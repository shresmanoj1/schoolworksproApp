import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/about_module/about_module.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_week.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/api_response_config.dart';
import '../../constants/text_style.dart';
import '../../helper/custom_loader.dart';
import '../../response/assessment_response.dart';
import '../../response/authenticateduser_response.dart';
import '../../services/admin/ticket_service.dart';
import '../lecturer/my-modules/components/more_component/view_homework_screen.dart';
import '../student/available_collaboration/available_collaboration_page.dart';
import '../student/exam/exam_score_screen.dart';
import '../student/module/my_study_material_screen.dart';
import 'activity/assessment.dart';
import 'homework/assignment_tab_screen.dart';
import 'homework/student_homework_screen.dart';
import 'lesson_content.dart/lesson_content.dart';

class LearningOverViewScreen extends StatefulWidget {
  final String moduleSlug;
  final int studyMaterialWeek;
  final int weeks;
  final Assessmentresponse myAssessment;
  final dynamic exam;
  final int tabIndex;
  final String moduleId;
  final bool isSoftwarica;
  const LearningOverViewScreen(
      {Key? key,
      required this.weeks,
      required this.moduleSlug,
      required this.myAssessment,
      required this.studyMaterialWeek,
        required this.moduleId,
        required this.isSoftwarica,
      required this.exam, required this.tabIndex})
      : super(key: key);

  @override
  State<LearningOverViewScreen> createState() => _LearningOverViewScreenState();
}

class _LearningOverViewScreenState extends State<LearningOverViewScreen>
    with TickerProviderStateMixin {
  List<bool> _isExpandedList = <bool>[];
  int selectedIndex = 0;
  late TabController tabController;
  User? user;

  @override
  void initState() {
    int tabCount = widget.isSoftwarica == true ? (widget.tabIndex + 1) : widget.tabIndex;
    tabController = TabController(
      initialIndex: 0,
      length: tabCount,
      vsync: this,
    );
    _isExpandedList = List.generate(widget.weeks, (index) => false);

    getuserData();
    super.initState();
  }

  getuserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');

    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await Provider.of<LearningViewModel>(context, listen: false)
        .fetchCompletedLesson();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningViewModel>(builder: (context, snapshot, child) {
      return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: logoTheme,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(125),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading(snapshot.particularModuleResponse) ||
                            isLoading(snapshot.averageRatingApiResponse)
                        ? GFShimmer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: RatingBar.builder(
                                    initialRating:
                                        snapshot.averageRating == null
                                            ? 0
                                            : snapshot.averageRating!,
                                    direction: Axis.horizontal,
                                    tapOnlyMode: false,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    unratedColor: Colors.white,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // print(rating);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.particularModule['moduleTitle'] ??
                                      "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: RatingBar.builder(
                                  initialRating: snapshot.averageRating == null
                                      ? 0
                                      : snapshot.averageRating!,
                                  direction: Axis.horizontal,
                                  tapOnlyMode: false,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: Colors.white,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // print(rating);
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: white,
                            ),
                            onPressed: () {
                              var index = tabController.index - 1;
                              if (index >= 0) {
                                tabController.animateTo(index);
                              }
                            },
                          )),
                      Expanded(
                        flex: 10,
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: logoTheme,
                          controller: tabController,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          labelStyle: p15.copyWith(fontWeight: FontWeight.w800),
                          unselectedLabelColor: white,
                          unselectedLabelStyle: p15.copyWith(color: white),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: white),
                          isScrollable: true,
                          onTap: (value) {
                            setState(() {
                              selectedIndex = value;
                            });

                            // print(selectedIndex);
                          },
                          tabs:  [
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Overview"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Resources"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Study Materials"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Tasks"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Assignment"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Support"),
                              ),
                            ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Quiz"),
                              ),
                            ),
                            if(snapshot.getShowDigitalDiary == true)
                              const Tab(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Digital Diary"),
                                ),
                              ),
                            const Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Exam Score"),
                              ),
                            ),
                            if(widget.isSoftwarica == true)
                              const Tab(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Collaborate"),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: white,
                            ),
                            onPressed: () {
                              var index = tabController.index + 1;
                              if (index < 5) {
                                tabController.animateTo(index);
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AboutModule(
                url: snapshot.particularModule['embeddedUrl'],
                desc: snapshot.particularModule['moduleDesc'],
                benefits: snapshot.particularModule['benefits']),
            Container(
              color: white,
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: Builder(builder: (context) {
                  var categories = snapshot.weekCategory;
                  List<dynamic> elseLessArr = [];
                  List<dynamic> elseWeekArr = [];
                  Map<String, dynamic> untitledData = {
                    "title": "Untitled",
                    "lessons": elseLessArr,
                    "weeks": elseWeekArr
                  };
                  var lessonsWithTitle = [];
                  var weeksWithCategories = [];
                  elseLessArr.clear();
                  elseWeekArr.clear();
                  lessonsWithTitle.clear();
                  weeksWithCategories.clear();
                  print(categories);
                  if (categories.length > 0) {
                    for (var k = 0; k < categories.length; k++) {
                      weeksWithCategories = [
                        ...weeksWithCategories,
                        ...categories[k].weeks!
                      ];
                    }

                    for (var i = 0; i < snapshot.lessons.length; i++) {
                      Map<String, dynamic> newData = {
                        "title": "",
                        "lessons": [],
                        "weeks": []
                      };
                      var week = snapshot.lessons[i].week.toString();
                      for (var j = 0; j < categories.length; j++) {
                        if (categories[j].weeks!.contains(week)) {
                          // find category in lessonsWithTitle array
                          var index = lessonsWithTitle.indexWhere((element) =>
                              element['title'] == categories[j].title);
                          if (index != -1) {
                            var lessonsWithTitleObj = lessonsWithTitle[index];
                            if (lessonsWithTitleObj != null) {
                              if (!lessonsWithTitleObj["weeks"]
                                  .contains(week)) {
                                lessonsWithTitleObj["lessons"]
                                    .add(snapshot.lessons[i]);
                                lessonsWithTitleObj["weeks"].add(week);
                                lessonsWithTitle[index] = lessonsWithTitleObj;
                              }
                            } else {
                              newData['title'] = categories[j].title;
                              newData['lessons'] = [snapshot.lessons[i]];
                              newData['weeks'] = [week];
                              lessonsWithTitle.add(newData);
                            }
                          } else {
                            newData['title'] = categories[j].title;
                            newData['lessons'] = [snapshot.lessons[i]];
                            newData['weeks'] = [week];
                            lessonsWithTitle.add(newData);
                          }
                        }
                      }
                      if (!weeksWithCategories.contains(week)) {
                        untitledData['lessons'] = [
                          ...untitledData['lessons'],
                          snapshot.lessons[i]
                        ];
                        untitledData['weeks'] = [
                          ...untitledData['weeks'],
                          week
                        ];
                      }
                    }

                    if (untitledData["lessons"].length > 0) {
                      lessonsWithTitle.add(untitledData);
                    }
                    print(lessonsWithTitle);
                  } else {
                    var lessonsArr = [];
                    var weeksArr = [];
                    for (var i = 0; i < snapshot.lessons.length; i++) {
                      lessonsArr.add(snapshot.lessons[i]);
                      weeksArr.add(snapshot.lessons[i].week.toString());
                    }
                    untitledData['lessons'] = lessonsArr;
                    untitledData['weeks'] = weeksArr;
                    lessonsWithTitle.add(untitledData);
                  }
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Lessons",
                          style: p16.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: lessonsWithTitle.length,
                          itemBuilder: (BuildContext context, index2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    lessonsWithTitle[index2]["title"]
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                ...List.generate(
                                    lessonsWithTitle[index2]["lessons"].length,
                                    (index) {
                                  var datas = lessonsWithTitle[index2]
                                      ["lessons"][index];

                                  return Column(
                                    children: [
                                      Theme(
                                        data: ThemeData().copyWith(
                                            dividerColor: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: grey_400)),
                                            child: ExpansionTile(
                                                trailing: _isExpandedList[index]
                                                    ? const Icon(
                                                        Icons.remove,
                                                        color: grey_600,
                                                      )
                                                    : const Icon(
                                                        Icons.add,
                                                        color: grey_600,
                                                      ),
                                                onExpansionChanged:
                                                    (isExpanded) {
                                                  setState(() {
                                                    _isExpandedList[index] =
                                                        isExpanded;
                                                    for (int i = 0;
                                                        i <
                                                            _isExpandedList
                                                                .length;
                                                        i++) {
                                                      if (i != index) {
                                                        _isExpandedList[i] =
                                                            false;
                                                      }
                                                    }
                                                  });
                                                },
                                                maintainState: true,
                                                title: Text(
                                                  "Week ${datas.week}",
                                                  style: p15.copyWith(
                                                      color: Colors.black),
                                                ),
                                                children: List.generate(
                                                    datas.lessons!.length, (i) {
                                                  var index = i + 1;
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          trailing: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // InkWell(
                                                                //   onTap: () {
                                                                //     infoDetailDialog(
                                                                //         datas
                                                                //             .lessons![
                                                                //                 i]
                                                                //             .lessonTitle,
                                                                //         snapshot
                                                                //             .syllabusBatchModuleStatus
                                                                //             .syllabus);
                                                                //   },
                                                                //   child:
                                                                //       const Icon(
                                                                //     Icons.info,
                                                                //     color: Color(
                                                                //         0xff2ea033),
                                                                //   ),
                                                                // ),
                                                                // const SizedBox(
                                                                //   width: 5,
                                                                // ),
                                                                snapshot.completedLesson.contains(datas
                                                                        .lessons?[
                                                                            i]
                                                                        .id
                                                                        .toString())
                                                                    ? const Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Color(
                                                                            0xff0078ff),
                                                                      )
                                                                    : const SizedBox(),
                                                              ]),
                                                          title: RichText(
                                                            // textAlign: TextAlign.center,
                                                            text: TextSpan(
                                                              children: [
                                                                const WidgetSpan(
                                                                  child: Icon(
                                                                      Icons
                                                                          .play_arrow_outlined,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 20),
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        "Lesson $index : ${datas.lessons![i].lessonTitle}",
                                                                    style:
                                                                        const TextStyle(
                                                                      color:
                                                                          black,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Lessoncontent(
                                                                            data:
                                                                                datas,
                                                                            moduleSlug:
                                                                                widget.moduleSlug,
                                                                            index:
                                                                                i,
                                                                          )),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                })
                              ],
                            );
                          })
                    ],
                  );
                }),
              ),
            ),
            MyStudyMaterialScreen(
                week: widget.studyMaterialWeek, isTeacher: false),
            Container(
              color: white,
              child: Activity(
                moduleSlug: widget.moduleSlug,
                myAssessment: widget.myAssessment,
              ),
            ),
            user == null
                ? Container()
                : AssignmentScreen(
                    moduleSlug: snapshot.particularModule['moduleSlug'],
                    isTeacher: user?.type == "Student" ? false : true),
            Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ...List.generate(snapshot.teacher.length, (index) {
                      var datas = snapshot.teacher[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              border:
                                  Border(bottom: BorderSide(color: grey_200))),
                          child: ListTile(
                            trailing: InkWell(
                              onTap: () async {
                                customLoadStart();
                                final res = await AdminTicketService()
                                    .addticketwithoutimage(
                                        "Require academic help in ${snapshot.particularModule['moduleTitle'] ?? ""}",
                                        "Request for Academic Support",
                                        "High",
                                        "Academic Support",
                                        datas.username.toString(),
                                        DateTime.now());
                                if (res.success == true) {
                                  Fluttertoast.showToast(
                                      msg: res.message.toString());
                                  customLoadStop();
                                } else {
                                  customLoadStop();
                                  Fluttertoast.showToast(
                                      msg: res.message.toString());
                                  customLoadStop();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: logoTheme,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create a support Ticket",
                                    style: p14.copyWith(color: white),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                                "${datas.firstname ?? ""} ${datas.lastname ?? ""}",
                                style:
                                    p15.copyWith(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            QuizWeekScreen(moduleSlug: widget.moduleSlug),
            if (snapshot.getShowDigitalDiary == true)
              StudentHomeWorkMainScreen(
                moduleSlug: widget.moduleSlug,
              ),
            ExamScoreScreen(moduleSlug: widget.moduleSlug,),
            if(widget.isSoftwarica == true)
              AvailableCollaborationScreen(moduleId: widget.moduleId,)
          ],
        ),
      );
    });
  }

  infoDetailDialog(String title, dynamic syllabus) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title.toString()),
            content: SizedBox(
              height: 340,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Divider(
                      thickness: 2,
                      color: Colors.blueAccent,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueAccent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ))),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget richTextWidget(String title, String value) {
    return Table(
      columnWidths: const {0: FixedColumnWidth(80.0)},
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
