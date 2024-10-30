import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/achievements/achievement_view_model.dart';
import 'package:schoolworkspro_app/Screens/driver/driver_view_model.dart';
import 'package:schoolworkspro_app/Screens/fees/view_model/fees_viewmodel.dart';
import 'package:schoolworkspro_app/Screens/lecturer/ID-lecturer/idcard_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/book_leave_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/admission/lecturer_advisor_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/events/lecturer_event_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/grade_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/view_model/modules_view_model.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/activity/activity_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/teaching_material/teaching_material_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/message_principal/message_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/announcement_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/Screens/result/result_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/collaboration_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/careers/career_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_view_model.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/auth_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/environment.config.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';

import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/helper/local_notification_service.dart';
import 'package:schoolworkspro_app/result_view_model.dart';
import 'package:schoolworkspro_app/routes/route_generator.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/document_service.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Screens/lecturer/Dashboardlecturer/lecturer_view_model.dart';
import '../Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import '../Screens/lecturer/my-modules/components/group_result/group_result_view_model.dart';
import '../Screens/lecturer/my-modules/components/more_component/check_submission_view_model.dart';
import '../Screens/lecturer/my-modules/components/more_component/homework_view_model.dart';
import '../Screens/my_learning/additional_resources/additional_resources_view_model.dart';
import '../Screens/my_learning/learning_view_model.dart';
import '../Screens/parents/More_parent/parent_request/view_parentrequest/parent_request_view_model.dart';
import '../Screens/parents/attendance_parent/monthly_attendance_view_model.dart';
import '../Screens/parents/homework/parent_homework_view_model.dart';
import '../Screens/physical_library/library_view_model.dart';
import '../config/flavor_config.dart';
import '../constants/colors.dart';
import '../flavor_config_provider.dart';

var flavorConfigProvider;

Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  // await Upgrader.clearSavedSettings();
  await EnvironmentConfig().init();
  await PreferenceUtils.init();
  await Hive.initFlutter();
  LocalNotificationService.initialize();
  await HiveUtils.init();

  ByteData data =
  await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  // FlutterError.onError = (FlutterErrorDetails details){
  //   print("details of error");
  //   print(details.exception);
  //       print(details);
  // };
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider<FlavorConfigProvider>(
      create: (_) => FlavorConfigProvider(config),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    final config = flavorConfigProvider.config;
    return OverlayKit(
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider<CommonViewModel>(
              create: (_) => CommonViewModel(),
            ),
            ChangeNotifierProvider<AuthViewModel>(
              create: (_) => AuthViewModel(),
            ),
            ChangeNotifierProvider<PrinicpalCommonViewModel>(
              create: (_) => PrinicpalCommonViewModel(),
            ),
            ChangeNotifierProvider<LecturerCommonViewModel>(
              create: (_) => LecturerCommonViewModel(),
            ),
            ChangeNotifierProvider<IDCardLecturerViewModel>(
              create: (_) => IDCardLecturerViewModel(),
            ),
            ChangeNotifierProvider<AssignedRequestService>(
              create: (_) => AssignedRequestService(),
            ),
            ChangeNotifierProvider<AnnouncementViewModel>(
              create: (_) => AnnouncementViewModel(),
            ),
            ChangeNotifierProvider<GradeViewModel>(
              create: (_) => GradeViewModel(),
            ),
            ChangeNotifierProvider<StatsCommonViewModel>(
              create: (_) => StatsCommonViewModel(),
            ),
            ChangeNotifierProvider<MessageViewModel>(
              create: (_) => MessageViewModel(),
            ),
            ChangeNotifierProvider<Authenticateduserservice>(
              create: (_) => Authenticateduserservice(),
            ),
            ChangeNotifierProvider<GradeViewModel>(
              create: (_) => GradeViewModel(),
            ),
            ChangeNotifierProvider<LecturerViewModel>(
              create: (_) => LecturerViewModel(),
            ),
            ChangeNotifierProvider<AnnouncementViewModel>(
              create: (_) => AnnouncementViewModel(),
            ),
            ChangeNotifierProvider<HomeworkViewModel>(
              create: (_) => HomeworkViewModel(),
            ),
            ChangeNotifierProvider<CheckSubmissionViewModel>(
              create: (_) => CheckSubmissionViewModel(),
            ),
            ChangeNotifierProvider<LecturerAdvisorViewModel>(
              create: (_) => LecturerAdvisorViewModel(),
            ),
            ChangeNotifierProvider<ParentHomeworkViewModel>(
              create: (_) => ParentHomeworkViewModel(),
            ),
            ChangeNotifierProvider<AttendanceViewModel>(
              create: (_) => AttendanceViewModel(),
            ),
            ChangeNotifierProvider<ModuleAttendanceLecturer>(
              create: (_) => ModuleAttendanceLecturer(),
            ),
            ChangeNotifierProvider<AdditionalResourcesViewModel>.value(
              value: AdditionalResourcesViewModel(),
            ),
            ChangeNotifierProvider<BookLeaveViewModel>.value(
              value: BookLeaveViewModel(),
            ),
            ChangeNotifierProvider<StudentResultViewModel>.value(
              value: StudentResultViewModel(),
            ),
            ChangeNotifierProvider<PunchService>.value(
              value: PunchService(),
            ),
            ChangeNotifierProvider<DocumentService>.value(
              value: DocumentService(),
            ),
            ChangeNotifierProvider<TeachingMaterialViewModel>.value(
              value: TeachingMaterialViewModel(),
            ),
            ChangeNotifierProvider<ActivityViewModel>(
              create: (_) => ActivityViewModel(),
            ),
            ChangeNotifierProvider<AchievementViewModel>(
              create: (_) => AchievementViewModel(),
            ),
            ChangeNotifierProvider<LibraryViewModel>(
              create: (_) => LibraryViewModel(),
            ),
            ChangeNotifierProvider<ExamViewModel>(
              create: (_) => ExamViewModel(),
            ),
            ChangeNotifierProvider<CareerViewModel>(
              create: (_) => CareerViewModel(),
            ),
            ChangeNotifierProvider<LearningViewModel>(
              create: (_) => LearningViewModel(),
            ),
            ChangeNotifierProvider<ParentRequestViewModel>(
              create: (_) => ParentRequestViewModel(),
            ),
            ChangeNotifierProvider<LecturerEventViewModel>(
              create: (_) => LecturerEventViewModel(),
            ),
            ChangeNotifierProvider<GroupResultViewModel>(
              create: (_) => GroupResultViewModel(),
            ),
            ChangeNotifierProvider<RequestViewModel>(
              create: (_) => RequestViewModel(),
            ),
            ChangeNotifierProvider<LogisticsViewModel>(
              create: (_) => LogisticsViewModel(),
            ),
            ChangeNotifierProvider<CollaborationViewModel>(
              create: (_) => CollaborationViewModel(),
            ),
            ChangeNotifierProvider<FeesViewModel>(
              create: (_) => FeesViewModel(),
            ),
            ChangeNotifierProvider<TicketViewModel>(
              create: (_) => TicketViewModel(),
            ),
            ChangeNotifierProvider<ModuleViewModel>(
              create: (_) => ModuleViewModel(),
            ),
            ChangeNotifierProvider<AssignmentViewModel>(
              create: (_) => AssignmentViewModel(),
            ),
            ChangeNotifierProvider<ResultViewModel>(
              create: (_) => ResultViewModel(),
            ),
            ChangeNotifierProvider<MonthlyAttendanceViewModel>(
              create: (_) => MonthlyAttendanceViewModel(),
            ),
            ChangeNotifierProvider<DriverViewModel>(
              create: (_) => DriverViewModel(),
            ),
          ],
          child: MaterialApp(
            title: '${config.appTitle}',
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            navigatorKey: RouteGenerator.navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: logoTheme, centerTitle: false),
                scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                primaryColor: kPrimaryColor,
                fontFamily: "Muli",
                // textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
                textTheme: const TextTheme(
                    bodyText1: TextStyle(color: Colors.black),
                    bodyText2: TextStyle(color: Colors.black))),
            // home: Splashscreen()
          )),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}