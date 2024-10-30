import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/tab_barlecturer.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/components/info.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/components/leavestats_body.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/components/logs_body.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/components/overtime_body.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/components/requeststats_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../response/login_response.dart';

class StatsScreenPrincipal extends StatefulWidget {
  final data;
  const StatsScreenPrincipal({Key? key, this.data}) : super(key: key);

  @override
  _StatsScreenPrincipalState createState() => _StatsScreenPrincipalState();
}

class _StatsScreenPrincipalState extends State<StatsScreenPrincipal> {
  User? user;
  int _selectedPage = 0;
  int _subselectedPage = 0;
  late PageController _pageController;
  late PageController _subpageController;

  PickedFile? _imageFile;
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  bool isLoading = false;

  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "choose photo",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colors.red),
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  final TextEditingController _remarksController = new TextEditingController();

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

  void _changesubPage(int pageNum) {
    setState(() {
      _subselectedPage = pageNum;
      _subpageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _subpageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // getActivity();
    _pageController = PageController();
    _subpageController = PageController();

    getData();

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            widget.data['firstname'] + " " + widget.data['lastname'],
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabButtonLecturer(
                    text: "Info",
                    pageNumber: 0,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(0);
                    },
                  ),
                  TabButtonLecturer(
                    text: "Leave",
                    pageNumber: 1,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(1);
                    },
                  ),
                  TabButtonLecturer(
                    text: "PaySlip",
                    pageNumber: 2,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(2);
                    },
                  ),
                  TabButtonLecturer(
                    text: "Requests",
                    pageNumber: 3,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(3);
                    },
                  ),
                  TabButtonLecturer(
                    text: "Overtime",
                    pageNumber: 4,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(4);
                    },
                  ),

                  TabButtonLecturer(
                    text: "Activity Logs",
                    pageNumber: 5,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(5);
                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 20,
            thickness: 15,
            indent: 3,
            color: Colors.grey.shade100,
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              controller: _pageController,
              children: [
                InfoScreen(data: widget.data),
                LeavestatsBody(data: widget.data),
                Container(
                  child: Column(
                    children: [
                      Image.asset("assets/images/no_content.PNG")
                    ],
                  ),
                ),
                RequeststatsBody(data: widget.data),
                OvertimeBody(data: widget.data,),

                ActivityLogsBody(data: widget.data,initialDate: DateTime.now()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
