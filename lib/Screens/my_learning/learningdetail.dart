import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:new_version/new_version.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/about_module/about_module.dart';
import 'package:schoolworkspro_app/Screens/my_learning/activity/activity_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/activity/assessment.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/lecturer/lecturer.dart';
import 'package:schoolworkspro_app/Screens/my_learning/lesson_content.dart/lesson_content.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/app_image.dart';
import 'package:schoolworkspro_app/response/completed_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/particularmoduleresponse.dart';
import 'package:schoolworkspro_app/response/rating_response.dart';
import 'package:schoolworkspro_app/services/completedlesson_service.dart';
import 'package:schoolworkspro_app/services/lesson_service.dart';
import 'package:schoolworkspro_app/services/particularmodule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/api_response_config.dart';
import '../../config/preference_utils.dart';
import '../../constants/colors.dart';
import '../../constants/text_style.dart';
import '../../response/login_response.dart';
import '../../services/attendance_service.dart';
import 'learning_overview_screen.dart';
import 'learning_view_model.dart';

class LearningDetail extends StatefulWidget {
  final moduleslug;
  final moduleTitle;
  final String moduleId;
  const LearningDetail(
      {Key? key, required this.moduleslug, required this.moduleTitle, required this.moduleId})
      : super(key: key);
  static const String routeName = "/learningdetail";
  @override
  _LearningDetailState createState() => _LearningDetailState();
}

class _LearningDetailState extends State<LearningDetail> {
  Future<Particularmoduleresponse>? particularmodule_response;
  late LearningViewModel _learningViewModel;
  late AssignmentViewModel _provider2;
  late CommonViewModel common;
  Future<Ratingresponse>? rating_response;
  Future<Completedlessonresponse>? completed_response;
  late Future<Lessonresponse> lesson_response;
  String? url;
  double? ratings;
  User? user;

  int _selectedPage = 0;
  late PageController _pageController;
  late ActivityViewModel _provider;

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  SharedPreferences sharedPreferences = PreferenceUtils.instance;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      _provider2 = Provider.of<AssignmentViewModel>(context, listen: false);

      _learningViewModel.fetchParticularModule(widget.moduleslug);
      _learningViewModel.fetchCompletedLesson();
      _learningViewModel.fetchAverageRating(widget.moduleslug);
      _learningViewModel.fetchSupportTeachers(widget.moduleslug); //
      _learningViewModel.fetchLesson(widget.moduleslug);
      _learningViewModel.fetchLessonWeekCategory(widget.moduleslug);
      _learningViewModel.fetchMyStudyMaterial(widget.moduleslug);
      _learningViewModel.getTaskCompletedPercentage(
          user?.username ?? "", widget.moduleslug); //
      _learningViewModel.fetchAttendanceProgress(widget.moduleslug);
      _learningViewModel.fetchLessonProgress(widget.moduleslug);

      _provider = Provider.of<ActivityViewModel>(context, listen: false);
      _provider.fetchMyAssessment(widget.moduleslug);
      _provider2.fetchAllAssignment(widget.moduleslug);
      common = Provider.of<CommonViewModel>(context, listen: false);
      common.fetchCurrentStudent(widget.moduleslug);
    });
    getpass().then((_) {
      Map<String, dynamic> datas = {
        "batch": user?.batch,
        "moduleSlug": widget.moduleslug
      };
      _learningViewModel.fetchSyllabusBatchModuleStatus(datas);
    });
    _pageController = PageController();
    completed_response = Completedlessonservice().getcompletedlesson();

    getcompletedlesson();
    getRating();
    getAttendance();
    getLessons();
    super.initState();
  }

  dynamic attendancePercentage = 0;
  bool loading = true;
  getAttendance() async {
    setState(() {
      loading = true;
    });
    final data = await Attendanceservice().getAttendance();
    for (int i = 0; i < data.allAttendance!.length; i++) {
      try {
        setState(() {
          loading = true;
        });
        if (data.allAttendance![i].moduleTitle.toString().toLowerCase() ==
            widget.moduleTitle.toString().toLowerCase()) {
          attendancePercentage = data.allAttendance![i].percentage;
        }
        setState(() {
          loading = false;
        });
      } on Exception catch (e) {
        // print(e.toString());
        attendancePercentage = 0;
        setState(() {
          loading = false;
        });
        // TODO
      }
    }
  }

  getpass() async {
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  List completion = [];

  getcompletedlesson() async {
    final data = await Completedlessonservice().getcompletedlesson();
    for (int index = 0; index < data.completedLessons!.length; index++) {
      completion.add(data.completedLessons![index].lesson);
    }
  }

  getLessons() async {
    lesson_response = Lessonservice().getLesson(widget.moduleslug);
  }

  getRating() async {
    rating_response = Particularmoduleservice().fetchRatings(widget.moduleslug);
    final data =
        await Particularmoduleservice().fetchRatings(widget.moduleslug);
    setState(() {
      ratings = data.averageRating!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LearningViewModel, ActivityViewModel, AssignmentViewModel>(
        builder: (context, snapshot, activity, assignmentProvider, child) {
      return Scaffold(
        backgroundColor: logoTheme,
        bottomNavigationBar: SafeArea(
          child: isLoading(snapshot.particularModuleResponse) ||
                  isLoading(snapshot.averageRatingApiResponse)
              ? const SizedBox(
                  height: 1,
                  width: 1,
                )
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningOverViewScreen(
                            moduleSlug: widget.moduleslug,
                            weeks: snapshot.lessons.length,
                            myAssessment: activity.myAssessment,
                            studyMaterialWeek:
                                snapshot.myStudyMaterial.weeks != null
                                    ? snapshot.myStudyMaterial.weeks!.length
                                    : 0,
                            exam: snapshot.particularModule,
                            tabIndex: snapshot.getTabIndex,
                            moduleId: widget.moduleId,
                            isSoftwarica: user?.institution?.toLowerCase() == "softwarica" ? true : false,
                          ),
                        ));
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: logoTheme,
                    ),
                    child: Center(
                        child: Text(
                      "Go To Module",
                      style: p16.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    )),
                  ),
                ),
        ),
        appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Align(
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
                                    "Module Title",
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
                                    print(rating);
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                )),
            backgroundColor: logoTheme),
        body: Container(
          color: white,
          child: ListView(
            padding: const EdgeInsets.only(top: 15),
            children: [
              isLoading(snapshot.particularModuleResponse)
                  ? const CupertinoActivityIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: snapshot.particularModule['imageUrl']
                                      .split(".")
                                      .last ==
                                  "svg"
                              ? SvgPicture.network(
                                  '${api_url2}/uploads/modules/${snapshot.particularModule['imageUrl']}',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                )
                              : Image.network(
                                  '$api_url2/uploads/modules/${snapshot.particularModule['imageUrl']}',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        lecturerIntro(
                            snapshot,
                            DateTime.now().year -
                                DateTime.parse(snapshot
                                        .particularModule['moduleLeader']
                                            ['joinDate']
                                        .toString())
                                    .add(const Duration(minutes: 45, hours: 5))
                                    .year),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Overall Progress",
                            style: p16.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                CircularPercentIndicator(
                                    backgroundColor: const Color(0xFFFF0303)
                                        .withOpacity(0.3),
                                    progressColor: const Color(0xFFFF0303),
                                    center: isLoading(
                                            snapshot.lessonProgressApiResponse)
                                        ? Text("0%")
                                        : Text(snapshot.totalProgressProgress ==
                                                    null ||
                                                snapshot
                                                    .totalProgressProgress.isNaN
                                            ? "0%"
                                            : "${snapshot.totalProgressProgress.toStringAsFixed(0)}%"),
                                    lineWidth: 20,
                                    radius: 50,
                                    percent: isLoading(
                                            snapshot.lessonProgressApiResponse)
                                        ? 0
                                        : snapshot.totalProgressProgress.isNaN
                                            ? 0
                                            : snapshot.totalProgressProgress /
                                                100),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Lessons \nCompleted",
                                  style:
                                      p14.copyWith(fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                CircularPercentIndicator(
                                  backgroundColor: Colors.green.shade100,
                                  progressColor: Colors.green,
                                  center: isLoading(assignmentProvider
                                          .assignmentApiResponse)
                                      ? const Text('.')
                                      : Text("${assignmentProvider
                                              .totalAssignmentProgress
                                              .toStringAsFixed(0)}%"),
                                  lineWidth: 20,
                                  radius: 50,
                                  percent: isLoading(assignmentProvider
                                              .assignmentApiResponse) ||
                                          assignmentProvider
                                              .totalAssignmentProgress.isNaN
                                      ? 0.0
                                      : assignmentProvider
                                              .totalAssignmentProgress.isNaN
                                          ? 0
                                          : double.parse(assignmentProvider
                                                  .totalAssignmentProgress
                                                  .toStringAsFixed(0)) /
                                              100,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Assignment \nCompleted",
                                  style:
                                      p14.copyWith(fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                isLoading(
                                        snapshot.attendanceProgressApiResponse)
                                    ? const SizedBox()
                                    : Builder(builder: (context) {
                                        num percentage = 0;
                                        try {
                                          percentage = (snapshot
                                                      .attendanceProgress
                                                      .attendance!
                                                      .completed! /
                                                  snapshot.attendanceProgress
                                                      .attendance!.total!) *
                                              100;
                                        } catch (e) {}
                                        return CircularPercentIndicator(
                                            backgroundColor:
                                                Colors.purple.shade100,
                                            progressColor:
                                                const Color(0xFFD0108F),
                                            center: isLoading(snapshot
                                                    .attendanceProgressApiResponse)
                                                ? const Text('..')
                                                : Builder(builder: (context) {
                                                    return Text(percentage ==
                                                                null ||
                                                            percentage.isNaN
                                                        ? "0%"
                                                        : "${percentage.toStringAsFixed(0)}%");
                                                  }),
                                            lineWidth: 20,
                                            radius: 50,
                                            percent: isLoading(snapshot
                                                    .attendanceProgressApiResponse)
                                                ? 0
                                                : percentage == null ||
                                                        percentage.isNaN
                                                    ? 0
                                                    : double.parse(percentage
                                                            .toStringAsFixed(
                                                                0)) /
                                                        100);
                                      }),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Module\n Attendance ",
                                  style:
                                      p14.copyWith(fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    )
            ],
          ),
        ),
      );
    });
  }
}
