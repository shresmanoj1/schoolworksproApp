import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/lesson_content.dart/tab1_lecture.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
import 'package:schoolworkspro_app/Screens/widgets/custom_button.dart';
import 'package:schoolworkspro_app/Screens/widgets/custom_text_field.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/helper/image_from_network.dart';
import 'package:schoolworkspro_app/request/comment_request.dart';
import 'package:schoolworkspro_app/request/lessonratingrequest.dart';
import 'package:schoolworkspro_app/request/lessontrack_request.dart';
import 'package:schoolworkspro_app/response/comment_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';
import 'package:schoolworkspro_app/response/lessonrating_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/particularassessment_response.dart';
import 'package:schoolworkspro_app/services/comment_service.dart';
import 'package:schoolworkspro_app/services/particularassessment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/text_style.dart';
import '../activity/student_assessment_task_screen.dart';
import '../additional_resources/additional_resources_view_model.dart';
import '../additional_resources/additional_screen_tab.dart';

class Lessoncontent extends StatefulWidget {
  final moduleSlug;

  final LessonresponseLesson? data;
  final index;
  const Lessoncontent({Key? key, this.data, this.index, this.moduleSlug})
      : super(key: key);

  @override
  _LessoncontentState createState() => _LessoncontentState();
}

class _LessoncontentState extends State<Lessoncontent> {
  Future<Lessoncontentresponse>? lessoncontent_response;
  Future<Particularassessmentresponse>? assessment_response;
  Stream<Commentresponse>? comment_response;
  Future<LessonratingResponse>? lessonrating_response;
  int _selectedPage = 0;
  final TextEditingController commentcontroller = TextEditingController();
  List<TextEditingController> _replycontrollers = [];
  late PageController _pageController;
  bool isliked = false;
  bool isflaged = false;
  bool isvisible = false;
  bool completed = false;
  // List<bool> showreplyfield = [];
  bool showreplyfield = false;
  User? user;
  bool tabIndex = false;
  late LearningViewModel _learningViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _learningViewModel = Provider.of(context, listen: false);
      _learningViewModel.fetchLessonContent(
          widget.data?.lessons?[widget.index].lessonSlug ?? "");
      final data = LessonTrackRequest(
          moduleSlug: widget.moduleSlug,
          lesson: widget.data!.lessons![widget.index].id);
      _learningViewModel.fetchLessonTrackingStatus(data);
      _learningViewModel.fetchParticularAssignment(
          widget.data?.lessons?[widget.index].lessonSlug ?? "");
      additionalResourcesViewModel =
          Provider.of<AdditionalResourcesViewModel>(context, listen: false);
      additionalResourcesViewModel.fetchYoutubeLinks(
          widget.data?.lessons?[widget.index].lessonSlug ?? "");
      additionalResourcesViewModel.fetchRefreshLinks(
          widget.data?.lessons?[widget.index].lessonSlug ?? "");
      additionalResourcesViewModel
          .fetchBookLinks(widget.data?.lessons?[widget.index].lessonSlug ?? "");
      additionalResourcesViewModel
          .fetchSlide(widget.data?.lessons?[widget.index].lessonSlug ?? "");
      _learningViewModel
          .fetchComments(widget.data?.lessons?[widget.index].lessonSlug ?? "");
      _learningViewModel
          .fetchRatings(widget.data?.lessons?[widget.index].lessonSlug ?? "");
    });
    getData();
    // getRatings();
    // getContent();

    // getAssessment();
    getComment();

    _pageController = PageController();

    // TODO: implement initState
    super.initState();
  }

  late AdditionalResourcesViewModel additionalResourcesViewModel;

  // getRatings() async {
  //   final data = await Lessonratingservice()
  //       .getratings(widget.data!.lessons![widget.index].lessonSlug!);
  //   setState(() {
  //     rating = data.rating!.rating!;
  //     print(rating);
  //   });
  // }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  getComment() async {
    comment_response = Commentservice().getrefreshcomment(
        const Duration(milliseconds: 1),
        widget.data!.lessons![widget.index].lessonSlug!);
  }

  getAssessment() async {
    assessment_response = Particularassessmentservice().getparticularassessment(
        widget.data!.lessons![widget.index].lessonSlug!);
  }

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


  // getContent() async {
  //   lessoncontent_response = Lessoncontentservice()
  //       .getLessoncontent(widget.data!.lessons![widget.index].lessonSlug!);
  // }
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
            title: Text(
              widget.data!.lessons![widget.index].lessonTitle.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: logoTheme,
                  labelStyle: p15.copyWith(fontWeight: FontWeight.w800),
                  unselectedLabelColor: white,
                  unselectedLabelStyle: p15.copyWith(color: white),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: white),
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Lesson"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Tasks"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Additional Resources"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: logoTheme),
        body:
            Consumer<LearningViewModel>(builder: (context, snapshot, child) {
          return TabBarView(
            children: [
              Tab1Lecture(
                  callback: (value) {
                    setState(() {
                      tabIndex = value;
                    });
                  },

                  moduleSlug: widget.moduleSlug,
                  data: widget.data,
                  lessonStatus: snapshot.lessonStatus,
                  index: widget.index),
              StudentAssessmentTaskScreen(
                  isFromInside: true,
                  lessonSlug:
                      widget.data?.lessons?[widget.index].lessonSlug ?? "",
                  lessonTitle:
                      widget.data?.lessons?[widget.index].lessonTitle ?? ""),
              AdditionalScreenTab(
                lessonSlug: widget.data?.lessons?[widget.index].lessonSlug,
              )
            ],
          );
        }),
      ),
    );
  }
}
