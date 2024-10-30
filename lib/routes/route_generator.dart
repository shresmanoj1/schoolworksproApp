import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/activities/activities.dart';
import 'package:schoolworkspro_app/Screens/attendance/attendance.dart';
import 'package:schoolworkspro_app/Screens/connected_device/connecteddevice.dart';
import 'package:schoolworkspro_app/Screens/courses/coursedetail.dart';
import 'package:schoolworkspro_app/Screens/dashboard/dasboard.dart';
import 'package:schoolworkspro_app/Screens/dashboard/support/support.dart';
import 'package:schoolworkspro_app/Screens/dashboard/support_staff/support_staff.dart';
import 'package:schoolworkspro_app/Screens/documents/components/slc_certificate.dart';
import 'package:schoolworkspro_app/Screens/documents/documents.dart';
import 'package:schoolworkspro_app/Screens/driver/navigation-driver/navigation_driver.dart';
import 'package:schoolworkspro_app/Screens/examination/examination.dart';
import 'package:schoolworkspro_app/Screens/fees/fees_screen.dart';
import 'package:schoolworkspro_app/Screens/forget_password/forget_password.dart';
import 'package:schoolworkspro_app/Screens/gallery/album_screen.dart';
import 'package:schoolworkspro_app/Screens/gallery/gallery_screen.dart';
import 'package:schoolworkspro_app/Screens/id_card/id_card.dart';
import 'package:schoolworkspro_app/Screens/inventory/request_inventory.dart';
import 'package:schoolworkspro_app/Screens/inventory/viewinventory_request.dart';
import 'package:schoolworkspro_app/Screens/journey/journey_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lecturerRequestScreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/attendance_report/attendance_report.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/book_leave.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/overtime/overtimescreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/lecturerstudentstats_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/soft_marks/soft_add_grade_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/navigation/navigation_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/routines-lecturer/routine-lecturer.dart';
import 'package:schoolworkspro_app/Screens/library/libraryscreen.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics_tab_screen.dart';
import 'package:schoolworkspro_app/Screens/logistics/view_logistics.dart';
import 'package:schoolworkspro_app/Screens/more/edit_profile/edit_profile.dart';
import 'package:schoolworkspro_app/Screens/more/issued_book/issued_book.dart';
import 'package:schoolworkspro_app/Screens/more/settings/updatedetail_screen.dart';
import 'package:schoolworkspro_app/Screens/more/settings/updatepass_screen.dart';
import 'package:schoolworkspro_app/Screens/navigation/navigation.dart';
import 'package:schoolworkspro_app/Screens/notification/notification.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parentchange_password/parentchangepassword_screen.dart';
import 'package:schoolworkspro_app/Screens/parents/children/children_screen.dart';
import 'package:schoolworkspro_app/Screens/register/register.dart';
import 'package:schoolworkspro_app/Screens/request/myrequest.dart';
import 'package:schoolworkspro_app/Screens/request/request_tab_screen.dart';
import 'package:schoolworkspro_app/Screens/result/result_screen.dart';
import 'package:schoolworkspro_app/Screens/splash/splashscreen.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/available_collaboration_page.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/collaboration_tab_page.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/create_task_page.dart';
import 'package:schoolworkspro_app/Screens/student/careers/careers_navigation_screen.dart';
import 'package:schoolworkspro_app/Screens/student/careers/job_finder_screen.dart';
import 'package:schoolworkspro_app/Screens/student/careers/my_application_detail_screen.dart';
import 'package:schoolworkspro_app/Screens/student/disciplinary_act_history/disciplinart_act_history_screen.dart';
import 'package:schoolworkspro_app/Screens/survey/surveyscreen.dart';
import 'package:schoolworkspro_app/Screens/ticket/viewticketscreen.dart';
import 'package:schoolworkspro_app/response/collaboration_group_response.dart';

import '../Screens/achievements/my_achievements_screen.dart';
import '../Screens/add_or_view_attendance.dart';
import '../Screens/dashboard/weekly/Weekly_details_screen.dart';
import '../Screens/dashboard/weekly/weekly_screen.dart';
import '../Screens/lecturer/Dashboardlecturer/examination_lecturer.dart';
import '../Screens/lecturer/ID-lecturer/idcard_lecturer.dart';
import '../Screens/lecturer/Morelecturer/Request/lectureraddrequest_screen.dart';
import '../Screens/lecturer/Morelecturer/inventory/lecturer_inventoryscreen.dart';
import '../Screens/lecturer/Morelecturer/logistics/lecturer_logistiscscreen.dart';
import '../Screens/lecturer/UpdateInventoryLogistics/updateinventory_logistics.dart';
import '../Screens/lecturer/admission/advisor_screen.dart';
import '../Screens/lecturer/events/events_lecturer.dart';
import '../Screens/lecturer/my-modules/components/more_component/school_addgrade_screen.dart';
import '../Screens/lecturer/my-modules/components/more_component/view_grade_student.dart';
import '../Screens/lecturer/student_leave/view_student_leave_screen.dart';
import '../Screens/physical_library/physical_library.dart';
import '../Screens/setting_screen.dart';
import '../Screens/student/careers/current_openings_screen.dart';
import '../Screens/student/careers/job_details_screen.dart';
import '../Screens/student/careers/my_application_screen.dart';
import '../response/my_application_response.dart';

class RouteGenerator {

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  static Future<dynamic> replacePage(String routeName, {Object? args}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: args);
  }

  static goBack() {
    return navigatorKey.currentState?.pop();
  }
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Splashscreen());

      case '/Dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());

      case '/navigation':
        return MaterialPageRoute(
            builder: (_) => Navigation(
                  currentIndex: 0,
                ));

      case '/activities':
        return MaterialPageRoute(
            builder: (_) => Activities(
                  username: args as String,
                ));
      case '/navigation-driver':
        return MaterialPageRoute(builder: (_) => NavigationDriver());

      case '/support':
        return MaterialPageRoute(builder: (_) => Support());

      case '/journey':
        return MaterialPageRoute(builder: (_) => JourneyScreen());

      case '/documents':
        return MaterialPageRoute(builder: (_) => const Documentscreen());

      case '/feesscreen':
        return MaterialPageRoute(builder: (_) => Feesscreen());

      case '/IDCard':
        return MaterialPageRoute(builder: (_) => IDCard());

      case '/AttendanceReportLecturer':
        return MaterialPageRoute(builder: (_) => AttendanceReportLecturer());

      case '/LecturerStudentStats':
        return MaterialPageRoute(builder: (_) => LecturerStudentStats());

      case '/galleryscreen':
        return MaterialPageRoute(builder: (_) => Galleryscreen());

      case '/overtimelecturer':
        return MaterialPageRoute(builder: (_) => OvertimeScreen());

      case '/lecturerrequest':
        bool isAdmin = args as bool;
        return MaterialPageRoute(
            builder: (_) => LecturerRequestScreen(isAdmin: isAdmin));

      case '/LogisticsLecturerScreen':
        return MaterialPageRoute(builder: (_) => LogisticsLecturerScreen());

      case '/albumscreen':
        return MaterialPageRoute(builder: (_) => AlbumScreen());

      case '/slccertificate':
        return MaterialPageRoute(
            builder: (_) => Slccertificate(
                  identifier: args as String,
                ));

      case '/logisticscreen':
        return MaterialPageRoute(builder: (_) => Logisticscreen());

      case '/viewlogistics':
        return MaterialPageRoute(builder: (_) => Viewlogistics());

      case '/requestinventory':
        return MaterialPageRoute(builder: (_) => Requestinventory());

      case '/UpdatelogisticsInventory':
        return MaterialPageRoute(builder: (_) => UpdatelogisticsInventory());

      case '/routineLecturer':
        return MaterialPageRoute(builder: (_) => const RoutineLecturer());
      case '/eventLecturer':
        return MaterialPageRoute(builder: (_) => EventLecturer());
      case '/IdCardLecturer':
        return MaterialPageRoute(builder: (_) => const IDCardlecturer());
      case '/lecturerAttendance':
        return MaterialPageRoute(
            builder: (_) => ManipulateAttendanceScreen(
                  modules: args as List<dynamic>,
                ));
      case '/lecturerRequest':
        return MaterialPageRoute(
            builder: (_) => const LecturerAddRequestScreen());
      case '/addGrade':
        return MaterialPageRoute(
            builder: (_) => SchoolAddScreen(
                  modules: args as List<dynamic>,
                ));
      case '/softwaricaAddGrade':
        return MaterialPageRoute(
            builder: (_) => SoftAddGradeScreen(
                  modules: args as List<dynamic>,
                ));
      case '/advisorScreen':
        return MaterialPageRoute(
            builder: (_) => LecturerAdvisorScreen(
                  showAppBar: args as bool,
                ));
      case '/studentStats':
        return MaterialPageRoute(builder: (_) => const LecturerStudentStats());
      case '/studentLeave':
        return MaterialPageRoute(
            builder: (_) => const ViewStudentLeaveScreen());
      case '/lecturerExamination':
        return MaterialPageRoute(builder: (_) => const ExaminationLecturer());

      case '/viewWeekly':
        return MaterialPageRoute(builder: (_) => Weekly());

      case "/weeklyDetails":
        return MaterialPageRoute(
            builder: (_) => WeeklyDetails(
                  JournalSlug: args as String,
                ));

      case '/lecturerrequestinventory':
        return MaterialPageRoute(builder: (_) => LecturerRequestinventory());

      case '/viewinventoryrequest':
        return MaterialPageRoute(builder: (_) => Viewinventoryrequest());

      case '/logisticsTabScreen':
        return MaterialPageRoute(builder: (_) => LogisticsTabScreen());

      case '/bookleave':
        return MaterialPageRoute(builder: (_) => BookLeave());

      case '/myAchievementScreen':
        return MaterialPageRoute(builder: (_) => MyAchievementScreen());

      case '/careerNavigationScreen':
        return MaterialPageRoute(builder: (_) => CareerNavigationScreen());

      case '/editprofile':
        return MaterialPageRoute(builder: (_) => const Editprofile());

      case '/NavigationLecturer':
        return MaterialPageRoute(builder: (_) => const NavigationLecturer());

      case '/attendance':
        return MaterialPageRoute(builder: (_) => const Attendance());

      case '/result':
        return MaterialPageRoute(builder: (_) => Resultscreen());

      case '/myrequest':
        return MaterialPageRoute(builder: (_) => Myrequest());

      case '/notificationscreen':
        return MaterialPageRoute(builder: (_) => Notificationscreen());

      case '/ticketscreen':
        return MaterialPageRoute(builder: (_) => Ticketscreen());

      case '/libraryscreen':
        return MaterialPageRoute(builder: (_) => LibraryScreen());

      case '/forgetpassword':
        return MaterialPageRoute(builder: (_) => Forgetpassword());

      case '/registerscreen':
        return MaterialPageRoute(builder: (_) => Registerscreen());

      case '/surveyscreen':
        return MaterialPageRoute(builder: (_) => Surveyscreen());

      case '/connecteddevicescreen':
        return MaterialPageRoute(builder: (_) => Connecteddevicescreen());

      case '/updatepasswordscreen':
        bool isLogin = args as bool;
        return MaterialPageRoute(
            builder: (_) => Updatepasswordscreen(
                  isLogin: isLogin,
                ));

      case '/updatedetailscreen':
        return MaterialPageRoute(builder: (_) => Updatedetailscreen());

      case '/reqeustTabScreen':
        return MaterialPageRoute(builder: (_) => RequestTabScreen());

      case '/supportStaff':
        return MaterialPageRoute(builder: (_) => Supportstaff());

      case '/disciplinaryActHistoryScreen':
        return MaterialPageRoute(
            builder: (_) => DisciplinaryActHistoryScreen());

      case '/examinationScreen':
        return MaterialPageRoute(builder: (_) => ExaminationScreen());
      case '/examinationLecturerScreen':
        return MaterialPageRoute(builder: (_) => ExaminationLecturer());

      case '/myachievementscreen':
        return MaterialPageRoute(builder: (_) => MyAchievementScreen());

      case '/issuedBook':
        return MaterialPageRoute(builder: (_) => IssuedBook());

      case '/physicalLibraryScreen':
        return MaterialPageRoute(builder: (_) => Physicallibraryscreen());
      case '/availablecollaboration':
        String args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AvailableCollaborationScreen(moduleId: args,));
      case '/create/task':
        dynamic args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => CreateTaskScreen(
                  groupId: args,
                ));

      case '/currentOpeningScreen':
        return MaterialPageRoute(builder: (_) => CurrentOpeningScreen());
      case '/jobDetailScreen':
        String args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => JobDetailScreen(
                  args: args,
                ));
      case '/myApplicationScreen':
        return MaterialPageRoute(builder: (_) => MyApplicationScreen());
      case '/jobFinderScreen':
        return MaterialPageRoute(builder: (_) => JobFinderScreen());
      case '/careerNavigationScreen':
        return MaterialPageRoute(builder: (_) => CareerNavigationScreen());

      // case "/collaborationTab":
      //   AssignmentGroup args = settings.arguments as AssignmentGroup;
      //   return MaterialPageRoute(
      //       builder: (_) => CollaborationTabScreen(groupValue: args));

      case '/myApplicationDetailScreen':
        Request args = settings.arguments as Request;
        return MaterialPageRoute(
            builder: (_) => MyApplicationDetailScreen(
                  request: args,
                ));

      case '/coursedetail':
        return MaterialPageRoute(
            builder: (_) => Coursedetail(
                  data: args,
                ));

      case '/childrenscreen':
        return MaterialPageRoute(builder: (_) => Childrenscreen());

      case '/parentchangepasswordscreen':
        return MaterialPageRoute(builder: (_) => Parentchangepasswordscreen());

      case '/viewmarkerscreen':
        return MaterialPageRoute(builder: (_) => ViewMarkStudentGrade());
      case '/settingScreen':
        return MaterialPageRoute(builder: (_) => SettingScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
