import 'dart:convert';
import 'dart:io';
import 'package:new_version/new_version.dart';
import 'package:schoolworkspro_app/Screens/TexasID/TexasIdLecturerScreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/view_submission_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/lecturer_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/services/institution_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_view_model.dart';
import '../../../constants/app_image.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../../helper/app_version.dart';
import '../../../response/login_response.dart';
import '../../../services/lecturer/punch_service.dart';
import '../../chatbot_v2/chatbot_v2.dart';
import '../../message/messaging.dart';
import '../../widgets/icon_text_grid.dart';
import '../ID-lecturer/idcard_view_model.dart';
import '../Morelecturer/Request/lecturer_request_tab_screen.dart';
import '../add_assessment/assessment_submissionscreen.dart';
import '../add_assessment/edit_assessment.dart';
import '../chatbot_lecturer/chatbot_lecturer_screen.dart';

class Dashboardlecturer extends StatefulWidget {
  const Dashboardlecturer({Key? key}) : super(key: key);

  @override
  _DashboardlecturerState createState() => _DashboardlecturerState();
}

class _DashboardlecturerState extends State<Dashboardlecturer> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LecturerViewModel>(
          create: (_) => LecturerViewModel(),
        ),
        ChangeNotifierProvider<TicketViewModel>(
          create: (_) => TicketViewModel(),
        ),
      ],
      child: DashboardLecturerBody(),
    );
  }
}

class DashboardLecturerBody extends StatefulWidget {
  const DashboardLecturerBody({Key? key}) : super(key: key);

  @override
  _DashboardLecturerBodyState createState() => _DashboardLecturerBodyState();
}

class _DashboardLecturerBodyState extends State<DashboardLecturerBody> {
  late User user;
  bool connected = true;
  final SharedPreferences localStorage = PreferenceUtils.instance;
  Future<InstitutionDetailForIdResponse>? institution_response;
  dynamic institution;
  late LecturerViewModel _provider;
  late TicketViewModel _ticketViewModel;
  late PunchService _punchService;
  late CommonViewModel _provider4;
  late LecturerCommonViewModel _provider5;
  late LibraryViewModel _libraryViewModel;
  late IDCardLecturerViewModel _idCardLecturer;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final SharedPreferences localStorage = PreferenceUtils.instance;
      _provider = Provider.of<LecturerViewModel>(context, listen: false);
      _punchService = Provider.of<PunchService>(context, listen: false);
      _provider5 = Provider.of<LecturerCommonViewModel>(context, listen: false);
      _idCardLecturer = Provider.of<IDCardLecturerViewModel>(context, listen: false);
      _punchService.checkPunchStatus(context);
      _provider5.setShowDigitalDiary(user.institutionType.toString(),user.institution.toString());
      // user = User.fromJson(jsonDecode(localStorage.getString("_auth_")!));
      _provider.setEmail(user.email.toString());
      _provider.fetchModules();
      _provider.fetchLecturerAllTask();
      _idCardLecturer.fetchInstitution();

      _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);


      //Library
      _libraryViewModel.fetchDigitalBooks();
      _libraryViewModel.fetchAllBooks();
      _libraryViewModel.fetchDigitalBookMarkedBooks();

      _ticketViewModel = Provider.of<TicketViewModel>(context, listen: false);
      _ticketViewModel.fetchassignedrequest(user.username.toString()).then((_) {
        //
        int total = _ticketViewModel.backlog +
            _ticketViewModel.approved +
            _ticketViewModel.pending +
            _ticketViewModel.resolved;
        if (localStorage.getInt('insideassigned') == null) {
          _ticketViewModel.setAssignedDot(false);
        }
        else if (localStorage.getInt('insideassigned') != null) {
          if (total == localStorage.getInt('insideassigned')) {
            _ticketViewModel.setAssignedDot(false);
          } else {
            _ticketViewModel.setAssignedDot(true);
          }
        }
      });
      _ticketViewModel.fetchAcademicRequest().then((_) {
        int totalss = _ticketViewModel.backlogAcademic +
            _ticketViewModel.approvedAcademic +
            _ticketViewModel.pendingAcademic +
            _ticketViewModel.resolvedAcademic;
        if (localStorage.getInt('insideacademic') == null) {
          _ticketViewModel.setAcademicDot(false);
        } else if (localStorage.getInt('insideacademic') != null) {
          if (totalss == localStorage.getInt('insideacademic')) {
            _ticketViewModel.setAcademicDot(false);
          } else {
            _ticketViewModel.setAcademicDot(true);
          }
        }
      });
    });

    checkInternet();
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    super.initState();
  }


  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          getData();
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  getData() async {
    final datas = await InstitutionService().getInstitutionDetail();
    _provider.setType(datas.institution['type']);
  }

  getUser() async {
    String? userData = localStorage.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<LecturerViewModel, TicketViewModel,IDCardLecturerViewModel>(
          builder: (context, data, ticket, values,child) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              connected == false
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black38,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "No Internet connection",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                child: SizedBox(
                  // height: 280,
                  child: Column(
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
                                          Navigator.pushNamed(
                                              context, '/routineLecturer');
                                        },
                                        title: "Routines",
                                        imageAsset: studentDashboardRoutine),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/lecturerAttendance',
                                            arguments: data.modules);
                                      },
                                      title: 'Attendance',
                                      imageAsset: lecturerAttendance,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(
                                        //   '/lecturerRequest',
                                        // );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LecturerRequestTabScreen()));
                                      },
                                      title: "Request",
                                      imageAsset: studentDashboardRequest,
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
                                        // if (user.institution == "softwarica" ||
                                        //     user.institution == "sunway") {
                                        //   Navigator.of(context).pushNamed(
                                        //     '/softwaricaAddGrade',
                                        //     arguments: data.modules,
                                        //   );
                                        // } else {
                                        //   Navigator.of(context).pushNamed(
                                        //     '/addGrade',
                                        //     arguments: data.modules,
                                        //   );
                                        // }
                                        Navigator.of(context).pushNamed(
                                          '/addGrade',
                                          arguments: data.modules,
                                        );
                                      },
                                      title: "Add Grade",
                                      imageAsset: addGrade,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          '/LogisticsLecturerScreen',
                                        );
                                      },
                                      title: "Logistic",
                                      imageAsset: lecturerLogistics,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/advisorScreen',
                                            arguments: true);
                                      },
                                      title: "Advisor",
                                      imageAsset: advisor,
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
                                            context, "/studentStats");
                                      },
                                      title: "Student\nStats",
                                      imageAsset: studentStats,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          '/UpdatelogisticsInventory',
                                        );
                                      },
                                      title: "Logistic\nRequest",
                                      imageAsset: logisticRequest,
                                    ),
                                  ),
                                  Expanded(
                                      child: IconTextGrid(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/AttendanceReportLecturer");
                                    },
                                    title: "Attendance\nReport",
                                    imageAsset: attendanceReport,
                                  )),
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
                                          '/bookleave',
                                        );
                                      },
                                      title: "Book A Leave",
                                      imageAsset: bookALeave,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        if(values.institution['alias'] == "texas"){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TexasIDLecturerScreen(),));
                                        }else{
                                          Navigator.of(context)
                                              .pushNamed('/IdCardLecturer');
                                        }
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => IDCard(),
                                        //     ));
                                      },
                                      title: "ID Card",
                                      imageAsset: lecturerIdCard,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconTextGrid(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            "/examinationLecturerScreen");
                                      },
                                      title: "Examinations",
                                      imageAsset: lecturerExamination,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
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
                                  ) : const Expanded(child: SizedBox()),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // IconTextGrid(
                              //   onTap: () {
                              //     Navigator.pushNamed(context, "/viewWeekly");
                              //   },
                              //   title: "Weekly",
                              //   imageAsset: studentDashboardWeekly,
                              // )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
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
                        // contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Tasks",
                          style: p16.copyWith(
                              fontSize: 18,
                              color: logoTheme,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      isLoading(data.lecturerAllTaskApiResponse)
                          ? const Center(child: CupertinoActivityIndicator())
                          : data.lecturerAllTask.assessments == null ||
                                  data.lecturerAllTask.assessments!.isEmpty
                              ? Container()
                              : Builder(builder: (context) {
                                  return Column(
                                    children: [
                                      ...List.generate(
                                          data.lecturerAllTask.assessments!
                                                      .length >
                                                  5
                                              ? 5
                                              : data
                                                  .lecturerAllTask
                                                  .assessments!
                                                  .length, (index) {
                                        var datas = data.lecturerAllTask
                                            .assessments![index];
                                        return ListTile(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           StudentAssessmentTaskScreen(
                                            //             isFromInside: false,
                                            //             lessonTitle: datas
                                            //                 .lesson
                                            //                 ?.lessonTitle ??
                                            //                 "",
                                            //             lessonSlug: datas
                                            //                 .lesson
                                            //                 ?.lessonSlug ??
                                            //                 "",
                                            //           )),
                                            // );
                                          },
                                          title: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
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
                                                      color: Color(0xffD03579),
                                                      width: 8),
                                                ),
                                                // borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // index == 0
                                                  //     ? const SizedBox()
                                                  //     : Padding(
                                                  //   padding:
                                                  //   const EdgeInsets
                                                  //       .only(
                                                  //       bottom: 8.0),
                                                  //   child: Container(
                                                  //     height: 2,
                                                  //     width:
                                                  //     double.infinity,
                                                  //     color: logoTheme,
                                                  //   ),
                                                  // ),
                                                  Text(
                                                    datas.moduleTitle ?? "",
                                                    style: p15.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    datas.lessonTitle ?? "",
                                                    style: p15.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color: logoTheme,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.access_time,
                                                          color: white,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            DateFormat(
                                                                    'dd MMM, yyyy - hh mm a EEEE')
                                                                .format(DateTime.parse(datas
                                                                        .dueDate
                                                                        .toString())
                                                                    .add(const Duration(
                                                                        minutes:
                                                                            45,
                                                                        hours:
                                                                            5)))
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Map<String, dynamic>
                                                                request = {
                                                              "batches":
                                                                  datas.batches,
                                                              "dueDate": datas
                                                                  .dueDate
                                                                  .toString(),
                                                              "contents": datas
                                                                  .contents,
                                                              "lessonSlug": datas
                                                                  .lessonTitle,
                                                              "_id": datas.id,
                                                              "moduleSlug": datas
                                                                  .moduleSlug
                                                            };
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditActivityScreen(
                                                                    data:
                                                                        request,
                                                                            moduleSlug: datas.moduleSlug.toString(),
                                                                  ),
                                                                ));
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          logoTheme),
                                                              shape: MaterialStateProperty
                                                                  .all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ))),
                                                          child: const Text(
                                                            "Edit Task",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ViewSubmissionScreen(
                                                                      id: datas
                                                                          .id
                                                                          .toString(),
                                                                      batch: datas
                                                                          .batches!),
                                                                ));
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Color(
                                                                          0xff2F8336)),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ))),
                                                          child: const Text(
                                                            "Submissions",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  );
                                })
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      }),
    );
  }
}
