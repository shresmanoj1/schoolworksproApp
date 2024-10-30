import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lesson_component/comment_body.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lesson_component/content_body.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lesson_component/insidelesson_body.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lesson_more/lesson_more_screen.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lessontrack_request.dart';
import 'package:schoolworkspro_app/response/comment_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';
import 'package:schoolworkspro_app/response/lessonrating_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/particularassessment_response.dart';
import 'package:schoolworkspro_app/services/comment_service.dart';
import 'package:schoolworkspro_app/services/lesson_service.dart';
import 'package:schoolworkspro_app/services/lessoncontent_service.dart';
import 'package:schoolworkspro_app/services/particularassessment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';


class LessoncontentLecturer extends StatefulWidget {
  final moduleSlug;
  String moduelTitle;
  final LessonresponseLesson? data;
  final index;

   LessoncontentLecturer(
      {Key? key, this.data, this.index, this.moduleSlug, required this.moduelTitle})
      : super(key: key);

  @override
  _LessoncontentLecturerState createState() => _LessoncontentLecturerState();
}

class _LessoncontentLecturerState extends State<LessoncontentLecturer> {
  Future<Lessoncontentresponse>? lessoncontent_response;
  Future<Particularassessmentresponse>? assessment_response;
  Stream<Commentresponse>? comment_response;
  Future<LessonratingResponse>? lessonrating_response;
  int _selectedPage = 0;
  final TextEditingController commentcontroller = TextEditingController();
  HtmlEditorController controller = HtmlEditorController();
  List<TextEditingController> _replycontrollers = [];
  late PageController _pageController;
  bool isliked = false;
  bool isflaged = false;
  bool isvisible = false;
  bool completed = false;
  // List<bool> showreplyfield = [];
  bool showreplyfield = false;
  User? user;
  double rating = 0;
  StreamController<Commentresponse> stream_controller =
  StreamController<Commentresponse>.broadcast();

  @override
  void initState() {
    getData();
    // getRatings();
    getContent();
    getlessonstatus();
    // getAssessment();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.setSlug(widget.moduleSlug);
      _provider.fetchBatches();
    });
    getComment();
    _pageController = PageController();

    // TODO: implement initState
    super.initState();
  }

  PageController pagecontroller = PageController();
  int selectedIndex = 0;
  String title = 'lesson';

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = 'lesson';
          }
          break;
        case 1:
          {
            title = 'Comments';
          }
          break;
        case 2:
          {
            title = 'Task';
          }
          break;
        case 3:
          {
            title = 'More';
          }
          break;
      }
    });
  }

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  getlessonstatus() async {
    final data = LessonTrackRequest(
        moduleSlug: widget.moduleSlug,
        lesson: widget.data!.lessons![widget.index].id);

    final res = await Lessonservice().getlessonstatus(data);
    if (res.lessonStatus == null) {
      setState(() {
        isvisible = false;
      });
    } else {
      if (res.lessonStatus!["isCompleted"] == false) {
        setState(() {
          completed = false;
        });
      } else {
        setState(() {
          completed = true;
        });
      }
      setState(() {
        isvisible = true;
      });
    }
  }

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

  getContent() async {
    lessoncontent_response = Lessoncontentservice()
        .getLessoncontent(widget.data!.lessons![widget.index].lessonSlug!);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.data!.lessons![widget.index].lessonTitle.toString(),
            style: const TextStyle(color: white),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: white, //change your color here
          ),
          // backgroundColor: Colors.white
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: _itemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/file.png',
              height: 20,
              width: 20,
              color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
            ),
            label: 'lesson',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/file.png',
              height: 20,
              width: 20,
              color: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
            ),
            label: 'comment',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/activity.png',
              height: 20,
              width: 20,
              color: selectedIndex == 2 ? kPrimaryColor : Colors.grey,
            ),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/more.png',
              height: 20,
              width: 20,
              color: selectedIndex == 3 ? kPrimaryColor : Colors.grey,
            ),
            label: 'More',
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: pagecontroller,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            ContentBody(
                data: widget.data,
                moduleSlug: widget.moduleSlug,
                index: widget.index,
                   moduelTitle: widget.moduelTitle,),
            Commentbody(
                data: widget.data,
                moduleSlug: widget.moduleSlug,
                index: widget.index),

            InsideLessonActivity(
                // data: widget.data,
                lessonSlug: widget.data!.lessons![widget.index].lessonSlug!,
                moduleSlug: widget.moduleSlug,
                checkNav: false,
                // index: widget.index
            ),
            LessonMoreScreen(lessonSlug: widget.data!.lessons![widget.index].lessonSlug.toString(), moduleSlug: widget.moduleSlug, moduelTitle: widget.moduelTitle,),
          ],
        ),
      ),
    );
  }
}