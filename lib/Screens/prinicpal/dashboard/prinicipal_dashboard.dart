import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/TexasID/TexasIDScreen.dart';
import 'package:schoolworkspro_app/Screens/id_card/id_card.dart';
import 'package:schoolworkspro_app/Screens/lecturer/assigned_requestlecturer/assigned_request_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/events/events_lecturer.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/admission/admission.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/admission/daily_income_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/allstudent_list.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/dashboard/addrequest_principalscreen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/dashboard/drawer_principal.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/disciplinary/disciplinary_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/leave/leavereport_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/navigation/custom_app_bar.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/newsannouncent_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/notice/view_mynoticeprinicpal.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/progress_report/progress_report.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_attendance/staff_attendance.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/staff_stats.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/admin/getmyrequestadmin_service.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/shimmerGridWidget.dart';
import '../../../config/api_response_config.dart';
import '../../chatbot_v2/chatbot_v2.dart';
import '../../lecturer/ID-lecturer/idcard_view_model.dart';
import '../../request/DateRequest.dart';
import '../routine/routine_principal_screen.dart';
import '../student_attendance_report/daily_attendance_student_screen.dart';
import '../student_attendance_report/student_attendance_report_screen.dart';

class PrincipalDashboardScreen extends StatefulWidget {
  const PrincipalDashboardScreen({Key? key}) : super(key: key);

  @override
  _PrincipalDashboardScreenState createState() =>
      _PrincipalDashboardScreenState();
}

class _PrincipalDashboardScreenState extends State<PrincipalDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TicketViewModel>(
          create: (_) => TicketViewModel(),
        ),
      ],
      child: const PrincipalDashboardBody(),
    );
  }
}

class PrincipalDashboardBody extends StatefulWidget {
  const PrincipalDashboardBody({Key? key}) : super(key: key);

  @override
  _PrincipalDashboardBodyState createState() => _PrincipalDashboardBodyState();
}

class _PrincipalDashboardBodyState extends State<PrincipalDashboardBody> {
  User? user;
  int myRequest = 0;

  String? selected_role;
  late TicketViewModel _ticketViewModel;
  late IDCardLecturerViewModel _idCardLecturerViewModel;
  late PrinicpalCommonViewModel _provider;

  List<dynamic> dashboardCardsList = [];


  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _idCardLecturerViewModel =
          Provider.of<IDCardLecturerViewModel>(context, listen: false);
      _ticketViewModel = Provider.of<TicketViewModel>(context, listen: false);
      _ticketViewModel.fetchassignedrequest(user!.username.toString());
      _ticketViewModel.fetchAcademicRequest();
      _idCardLecturerViewModel.fetchInstitution().then((value) {

        initializeDashboardCards();
      });

      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      final date = DateRequest(date: DateTime.now());
      _provider.fetchallattendanceforstaffs(date);
      _provider.fetchStudentDailyAttendanceCount();
      _provider.fetchAbsentStudentDailyAttendance(date.toString(),"","","");
      // _provider.fetchMyPermissions();
    });

    selected_role = user?.type.toString();

    final dataas = await MyRequestAdminService().myticketAdmin();
    setState(() {
      myRequest = dataas.requests!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<CommonViewModel, TicketViewModel,
            PrinicpalCommonViewModel,IDCardLecturerViewModel>(
        builder: (context, common, ticket, principalViewModel,value, child) {
      List<dynamic> filteredCardsList = dashboardCardsList
          .where((item) => principalViewModel.hasPermission(item['identifier']))
          .toList();

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff000099),
            elevation: 0.0,
          ),
          drawer: const DrawerPrincipal(),
          body: Consumer2<PrinicpalCommonViewModel,IDCardLecturerViewModel>(
              builder: (context, value,idcard, child) {
            return RefreshIndicator(
              onRefresh: () => getData(),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    const CustomAppBar(),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    kPrimaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AssignedRequestLecturer(
                                                isAdmin: true),
                                      ));
                                },
                                child: Builder(builder: (context) {
                                  int total = ticket.approved +
                                      ticket.pending +
                                      ticket.backlog +
                                      ticket.resolved;
                                  return Text(
                                      'Assigned Task ${total.toString()}');
                                })),
                          ),
                          10.sW,
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffff33cc)),
                              ),
                              child: const Text("My Request"),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    '/lecturerrequest',
                                    arguments: true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddRequestPrincipalScreen(),
                                      ));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffff0066),
                                  ),
                                ),
                                child: const Text('Create new task')),
                          ),
                          10.sW,
                          principalViewModel.hasPermission(["view_daily_income"]) ?
                          // user?.institution?.toLowerCase() == "rhombus" ?
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DailyIncomeScreen(),
                                      ));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.green,
                                  ),
                                ),
                                child: const Text('Daily Income')),
                          ) : const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    (isLoading(principalViewModel.myPermissionsApiResponse) || isLoading(idcard.institutionApiResponse))
                        ? const ShimmerGrid()
                        : GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: filteredCardsList.length,
                            itemBuilder: (context, index) {
                              final cardData = filteredCardsList[index];
                              return CardWidget(
                                title: cardData["title"],
                                image: cardData["image"],
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: cardData["navigate"],
                                          type:
                                              PageTransitionType.leftToRight));
                                },
                              );
                            },
                          )
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }


  void initializeDashboardCards() {
    dashboardCardsList = [
      {
        "title": "ID Card",
        "image": "assets/icons/card.png",
        "identifier": [],
        "navigate": _idCardLecturerViewModel.institution['alias'] == "texas" ? const TexasIDScreen() : const IDCard()
      },
      {
        "title": "Staff Attendance",
        "image": "assets/icons/verified-user.png",
        "identifier": ["daily_staff_attendance_report"],
        //get => remove static roles, load data in init state
        "navigate": const StaffAttendance()
      },
      // {
      //   "title": "Penalize Student",
      //   "image": "assets/images/penalty-card.png",
      //   "identifier": ["set_student_disciplinary_act"],
      //   "navigate": const PenalizeScreen()
      // },
      {
        "title": "Progress Report",
        "image": "assets/icons/verified-user.png",
        "identifier": ["view_module_progress"],
        "navigate": const ProgressReportScreen()
      },
      {
        "title": "Student Attendance",
        "image": "assets/icons/immigration.png",
        "identifier": [
          "student_module_attendance_report",
          "student_batch_attendance_report",
          "student_attendance_daily"
        ],
        "navigate": const StudentAttendanceReportScreen()
      },
      {
        "title": "Leave",
        "image": "assets/icons/exit.png",
        "identifier": ["view_staffs_leave_report", "manage_all_staff_leaves"],
        //get => filter bottom nav-bar according to permissions
        "navigate": const LeaveReportScreen()
      },
      {
        "title": "Notices",
        "image": "assets/icons/propaganda.png",
        "identifier": ["add_notice"],
        "navigate": const ViewMynoticePrincipal()
      },
      {
        "title": "Student Stats",
        "image": "assets/icons/statistics.png",
        "identifier": ["list_all_students", "view_student_detail", "manage_student_log"],
        //get => set_student_disciplinary_act(view stats=>disciplinary act=>penalize), update_student(issue ticket), reset_user_password(reset password),
        "navigate": const PrincipalAllStudentScreen()
      },
      {
        "title": "Disciplinary Act",
        "image": "assets/icons/card.png",
        "identifier": [
          "add_update_disciplinary_actions",
          "view_all_disciplinary_actions"
        ],
        "navigate": const DisciplinaryActScreen()
      },
      {
        "title": "Staff Stats",
        "image": "assets/icons/statistics.png",
        "identifier": ["view_staffs"],
        //edit_staff_detail=>view stats,  reset_user_password(reset password),
        "navigate": const Staffstats()
      },
      {
        "title": "News & Announcement",
        "image": "assets/icons/budget.png",
        "identifier": [],
        "navigate": const NewsAnnouncmentScreen()
      },
      {
        "title": "Routine",
        "image": "assets/icons/schedule.png",
        "identifier": ["view_all_routines_admin", "manage_all_routine"],
        //if(manage_all_routine) edit access else view access
        "navigate": const RoutinePrincipal()
      },
      {
        "title": "Events",
        "image": "assets/icons/event.png",
        "identifier": [],
        //if(add_update_event) add, update, scan : else view event
        "navigate": EventLecturer()
      },
      {
        "title": "Advisor",
        "image": "assets/icons/social-group.png",
        "identifier": ["view_advisors_admin"],
        //if(add_edit_advisor) show button option else nth
        "navigate": const AdvisorScreen()
      },
      {
        "title": "ChatBot",
        "image": "assets/images/chatbot_ai.png",
        "identifier": [],
        "navigate": const ChatBotLecturerScreen()
      },
    ];
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String image;
  final Function() onTap;

  const CardWidget(
      {Key? key, required this.title, required this.image, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 30,
                width: 30,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }
}
