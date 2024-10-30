import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/TexasID/TexasIDScreen.dart';
import 'package:schoolworkspro_app/Screens/achievements/achievement_view_model.dart';
import 'package:schoolworkspro_app/Screens/chatbot_v2/chatbot_v2.dart';
import 'package:schoolworkspro_app/Screens/id_card/id_card.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/Screens/result/result_tab_bar_screen.dart';
import 'package:schoolworkspro_app/Screens/routines/routine_screen.dart';
import 'package:schoolworkspro_app/auth_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/unread_messageservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_response_config.dart';
import '../../config/preference_utils.dart';
import '../../constants/app_image.dart';
import '../../constants/text_style.dart';
import '../../helper/app_version.dart';
import '../exam_test.dart';
import '../lecturer/ID-lecturer/idcard_view_model.dart';
import '../lecturer/my-modules/components/group_result/group_result_view_model.dart';
import '../message/messaging.dart';
import '../my_learning/activity/student_assessment_task_screen.dart';
import '../parents/attendance_parent/monthly_attendance_view_model.dart';
import '../prinicpal/principal_common_view_model.dart';
import '../prinicpal/stats_common_view_model.dart';
import '../student/digital_diary/digital_diary_screen.dart';
import '../student/exam/exam_list_screen.dart';
import '../widgets/icon_text_grid.dart';
import 'chat_bot_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GlobalKey _one = GlobalKey();

  late PrinicpalCommonViewModel _provider;
  late LearningViewModel _learningViewModel;
  late CommonViewModel _commonViewModel;
  late MonthlyAttendanceViewModel _monthlyAttendance;
  late LearningViewModel learningViewModel;
  late StatsCommonViewModel _provider4;
  late AchievementViewModel _provider5;
  late LibraryViewModel _libraryViewModel;
  late IDCardLecturerViewModel _idCardLecturer;
  late GroupResultViewModel _provider6;

  late User user;
  bool connected = true;
  int count = 0;
  bool visible = false;
  SharedPreferences localStorage = PreferenceUtils.instance;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> initializeData() async {
    checkInternet();
    await getUser();
    await getData();
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _monthlyAttendance =
          Provider.of<MonthlyAttendanceViewModel>(context, listen: false);
      learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      _provider4 = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider5 = Provider.of<AchievementViewModel>(context, listen: false);
      _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
      _idCardLecturer =
          Provider.of<IDCardLecturerViewModel>(context, listen: false);
      _provider6 = Provider.of<GroupResultViewModel>(context, listen: false);

      //Activity
      _commonViewModel.getMyActivity(user.username.toString());
      //events
      _commonViewModel.fetchEvents();
      //routine
      _commonViewModel.fetchStudentRoutine(user.batch ?? "");

      //user Details
      _commonViewModel.fetchoffenses();
      _commonViewModel.fetchExamRulesRegulations();
      _commonViewModel.fetchSupportStaff();

      //Journey
      _commonViewModel.fetchjourney();

      //Act
      _provider4.fetchAllAct();

      //learning
      learningViewModel.fetchLearningFilters();
      learningViewModel.fetchMyLearning("");
      learningViewModel.fetchMyNewLearning("");
      learningViewModel.setShowDigitalDiary(user.institutionType.toString());

      //achievements
      _provider5.fetchMyAchievements();

      //Library
      _libraryViewModel.fetchDigitalBooks();
      _libraryViewModel.fetchAllBooks();
      _libraryViewModel.fetchDigitalBookMarkedBooks();

      //weekly journal
      _commonViewModel.getVerifiedJournal();

      _commonViewModel.fetchStudentBus();

      //id card
      _idCardLecturer.fetchInstitution();

      //result
      _commonViewModel.fetchExamFromCourseStudents(user.username.toString());
      _provider6.fetchAllResultType();

      user = User.fromJson(jsonDecode(localStorage.getString("_auth_")!));
      _provider.fetchCourses();
      _libraryViewModel
          .fetchAllIssuedBooks(user == null ? "" : user.username.toString());
    });
  }

  getUser() async {
    String? userData = localStorage.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  // displayShowCase() async {
  //   final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   bool? showCaseVisibilityStatus = preferences.getBool("displayShowcase");
  //
  //   if (showCaseVisibilityStatus == null) {
  //     preferences.setBool("displayShowcase", false);
  //     return true;
  //   }
  //
  //   return false;
  // }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  int? birthMonth;
  int? birthDay;
  bool? checkBirthday;

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    try {
      if (user != null &&
          user.dob != null &&
          user.dob != "" &&
          DateTime.parse(user.dob!) != null) {
        DateTime now = DateTime.now();
        DateTime? birthDate = DateTime.parse(user.dob!);
        birthMonth = birthDate.month;
        birthDay = birthDate.day;
        if (birthMonth == now.month && birthDay == now.day) {
          // displayShowCase().then((status) {
          //   if (status) {
          //     ShowCaseWidget.of(context).startShowCase([_one]);
          //   }
          // });
        }
      }
    } catch (e) {
      print(e);
    }
    final unreadCount = await UnreadMessageService().getunreadforcount();
    if (mounted) {
      setState(() {
        count = unreadCount.allMessages!.length;
      });
    }
  }

  bool isMaximized = false;

  void toggleMaximized() {
    setState(() {
      isMaximized = !isMaximized;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Consumer3<CommonViewModel, AuthViewModel,IDCardLecturerViewModel>(builder: (context, common, auth,id, child) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          connected == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("No Internet Connection",
                              style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(context, "/");
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Stack(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(color: Color(0XFFEBEBEB)),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Routinescreen()));
                                      },
                                      title: "Routine",
                                      imageAsset: studentDashboardRoutine),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                      onTap: () {
                                        if (user.institution == "softwarica" ||
                                            user.institution == "sunway") {
                                          Navigator.of(context)
                                              .pushNamed('/result');
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ResultTabScreen()
                                                  // ResultTest(),
                                                  ));
                                        }
                                      },
                                      title: "Results",
                                      imageAsset: studentDashboardResult),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/attendance');
                                    },
                                    title: 'Attendance',
                                    imageAsset: studentDashboardAttendance,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        '/reqeustTabScreen',
                                      );
                                    },
                                    title: "Requests",
                                    imageAsset: studentDashboardRequest,
                                  ),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/careerNavigationScreen');
                                      },
                                      title: "Jobs",
                                      imageAsset: studentDashboardCareers),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/myAchievementScreen');
                                    },
                                    title: "Achievements",
                                    imageAsset: studentDashboardAcheivements,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/libraryscreen");
                                    },
                                    title: "Library",
                                    imageAsset: studentDashboardBooks,
                                  ),
                                ),
                                // Expanded(
                                //   child: IconTextGrid(
                                //     onTap: () {
                                //       Navigator.pushNamed(
                                //           context, "/availablecollaboration",
                                //         arguments:
                                //       );
                                //     },
                                //     title: "Collaborate",
                                //     imageAsset: studentDashboardCollaboration,
                                //   ),
                                // ),
                                Expanded(
                                    child: IconTextGrid(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/viewWeekly");
                                  },
                                  title: "Weekly",
                                  imageAsset: studentDashboardWeekly,
                                )),
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        '/logisticsTabScreen',
                                      );
                                    },
                                    title: "Logistic",
                                    imageAsset: studentDashboardLogistics,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [

                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      if(id.institution['alias'] =="texas"){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TexasIDScreen(),
                                            ));
                                      }else{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => IDCard(),
                                            ));
                                      }

                                    },
                                    title: "ID Card",
                                    imageAsset: studentDashboardIDCard,
                                  ),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        '/feesscreen',
                                      );
                                    },
                                    title: "Fees",
                                    imageAsset: studentDashboardFees,
                                  ),
                                ),
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/examinationScreen");
                                    },
                                    title: "Examinations",
                                    imageAsset: studentDashboardExamination,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                // Expanded(
                                //   child: IconTextGrid(
                                //     onTap: () {
                                //       // common.navigatoinIndex(0);
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (builder) =>
                                //                   MessageScreen()));
                                //     },
                                //     title: "Message",
                                //     imageAsset:
                                //         "assets/images/home/comments.png",
                                //   ),
                                // ),

                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const ExamListScreen()));
                                    },
                                    title: "Exam",
                                    imageAsset: "assets/images/exam.png",
                                  ),
                                ),
                                user.institution == "softwarica" ?
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                              const ChatBotLecturerScreen()));
                                    },
                                    title: "ChatBot",
                                    imageAsset: "assets/images/chatbot_ai.png",
                                  ),
                                ) :
                                user.institutionType == "School" ?
                                Expanded(
                                  child: IconTextGrid(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const DigitalDiaryScreen()));
                                    },
                                    title: "Digital Diary",
                                    imageAsset: studentDashboardWeekly,
                                  ),
                                ) :
                                const Expanded(child: SizedBox()),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     !(user.institution == "softwarica") && user.institutionType == "School" ?
                            //     Expanded(
                            //       child: IconTextGrid(
                            //         onTap: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                   const DigitalDiaryScreen()));
                            //         },
                            //         title: "Digital Diary",
                            //         imageAsset: studentDashboardWeekly,
                            //       ),
                            //     ) :
                            //     const Expanded(child: SizedBox()),
                            //     // const Expanded(child: SizedBox()),
                            //   ]
                            // )
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: taskContainer,
                        border: Border.all(color: grey_400),
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Tasks",
                            style: p16.copyWith(
                                fontSize: 18,
                                color: logoTheme,
                                fontWeight: FontWeight.w800),
                          ),
                          trailing: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/activities',
                                    arguments: user.username);
                              },
                              child: const Text("View All",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff001930),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        ),
                        isLoading(common.MyActivityApiResponse)
                            ? const Center(child: CupertinoActivityIndicator())
                            : common.incomplete.isEmpty
                                ? ListTile(
                                    title: Text(
                                      "No task available",
                                      style: p15.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      ...List.generate(
                                          common.incomplete.length > 5
                                              ? 5
                                              : common.incomplete.length,
                                          (index) {
                                        var datas = common.incomplete[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            dense: true,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentAssessmentTaskScreen(
                                                          isFromInside: false,
                                                          lessonTitle: datas
                                                                  .lesson
                                                                  ?.lessonTitle ??
                                                              "",
                                                          lessonSlug: datas
                                                                  .lesson
                                                                  ?.lessonSlug ??
                                                              "",
                                                        )),
                                              );
                                            },
                                            title: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Color(0xffD03579),
                                                    ),
                                                    top: BorderSide(
                                                      color: Color(0xffD03579),
                                                    ),
                                                    right: BorderSide(
                                                      color: Color(0xffD03579),
                                                    ),
                                                    left: BorderSide(
                                                        color:
                                                            Color(0xffD03579),
                                                        width: 8),
                                                  ),
                                                  // borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      datas.module
                                                              ?.moduleTitle ??
                                                          "",
                                                      style: p15.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      datas.lesson
                                                              ?.lessonTitle ??
                                                          "",
                                                      style: p15.copyWith(
                                                          color:
                                                              Color(0xff767676)
                                                          // fontWeight: FontWeight.w600
                                                          ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color: logoTheme,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.access_time,
                                                            color: white,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMM, yyyy - hh mm a EEEE')
                                                                .format(DateTime.parse(datas
                                                                        .assessment!
                                                                        .dueDate
                                                                        .toString())
                                                                    .add(const Duration(
                                                                        minutes:
                                                                            45,
                                                                        hours:
                                                                            5)))
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      );
    }));
  }
}
