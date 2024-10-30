import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:new_version/new_version.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/events/event.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
import 'package:schoolworkspro_app/Screens/parents/Dashboard_parent/sizeconfig.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_fee/parentfees_screen.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/parent_requestscreen.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/view_parentrequestscreen.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/resuult_parent/result_parent.dart';
import 'package:schoolworkspro_app/Screens/parents/Routine_parent/routine_parent.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/attendance_parent.dart';
import 'package:schoolworkspro_app/Screens/parents/children/children_screen.dart';
import 'package:schoolworkspro_app/Screens/parents/components/tab_button_parents.dart';
import 'package:schoolworkspro_app/Screens/parents/events/event_parents.dart';
import 'package:schoolworkspro_app/Screens/parents/homework/parent_homework_screen.dart';
import 'package:schoolworkspro_app/Screens/result_softwarica/result_softwarica.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/request/parent/attendance_request.dart';
import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
import 'package:schoolworkspro_app/request/parent/progress_request.dart';
import 'package:schoolworkspro_app/request/parent/result_header.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
import 'package:schoolworkspro_app/response/parents/childattendance_response.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/response/parents/getfessparent_response.dart';
import 'package:schoolworkspro_app/response/parents/getresultparent_response.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:schoolworkspro_app/services/parents/attendance_service.dart';
import 'package:schoolworkspro_app/services/parents/getfeesparent_service.dart';
import 'package:schoolworkspro_app/services/parents/parentresult_service.dart';
import 'package:schoolworkspro_app/services/parents/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../helper/app_version.dart';
import '../../request/request_view_model.dart';
import '../More_parent/parent_request/view_parentrequest/parent_request_tab.dart';
import '../Result-parent/result_parent.dart';

class Dashboardparent extends StatefulWidget {
  final Getchildrenresponse data;
  final int index;
  const Dashboardparent({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  _DashboardparentState createState() => _DashboardparentState();
}

class _DashboardparentState extends State<Dashboardparent>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  User? user;
  Future<AllProgressResponse>? progress_response;

  Future<Addprojectresponse>? transaction_start;
  Future<GetFeesResponse>? transaction_finish;
  Future<Addprojectresponse>? due_start;
  Future<GetFeesResponse>? due_finish;
  List<Child> _children = <Child>[];
  dynamic _selectedChildren;
  String? dropdownValue;

  late RequestViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider2 =
          Provider.of<RequestViewModel>(context, listen: false);
      _provider2.fetchparentRequest();
    });
    getData();
    getchildren();
    getSelectedChildren();
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    super.initState();
    dropdownValue = widget.data.children![widget.index].firstname.toString();
  }



  getSelectedChildren() async {
    setState(() {
      _selectedChildren = widget.data.children![widget.index].id.toString();
    });
  }

  getchildren() async {
    for (int i = 0; i < widget.data.children!.length; i++) {
      setState(() {
        _children.add(widget.data.children![i]);
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

    final progress_request = Addprogressheader(
      institution: widget.data.children![widget.index].institution,
      studentId: widget.data.children![widget.index].id,
    );

    progress_response = ProgressService().getallprogress(progress_request);
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              color: Colors.grey,
              height: 5,
              width: 50,
            ),
          ),
          ...List.generate(widget.data.children!.length, (it) {
            var displayData = widget.data.children![it];
            return ListTile(
              leading: SizedBox(
                height: 30,
                width: 30,
                child: CircleAvatar(
                    radius: 18,
                    backgroundColor: displayData.userImage == null
                        ? Colors.grey
                        : Colors.white,
                    child: displayData.userImage == null
                        ? Text(
                            displayData.firstname![0].toUpperCase() +
                                "" +
                                displayData.lastname![0].toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : ClipOval(
                            child: Image.network(
                              api_url2 +
                                  '/uploads/users/' +
                                  displayData.userImage.toString(),
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
              title: Text(displayData.firstname.toString() +
                  " " +
                  displayData.lastname.toString()),
              trailing: Checkbox(
                value: _selectedChildren == displayData.id,
                onChanged: (value) {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Dashboardparent(data: widget.data, index: it),
                      ));
                  // setState(() {
                  //   _value = value;
                  // });
                },
                activeColor: Colors.green,
              ),
            );
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.children?[widget.index].institution == "softwarica") {
      final data = GetFeesForParentsRequest(
        studentId: widget.data.children?[widget.index].username.toString(),
        institution: widget.data.children?[widget.index].institution.toString(),
      );

      due_start = ParentFeeService().duedatastart(data);
    } else {
      final data = GetFeesForParentsRequest(
        studentId: widget.data.children?[widget.index].email.toString(),
        institution: widget.data.children?[widget.index].institution.toString(),
      );

      due_start = ParentFeeService().duedatastart(data);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        widget.data.children![widget.index].userImage == null
                            ? Colors.grey
                            : Colors.white,
                    child: widget.data.children![widget.index].userImage == null
                        ? Text(
                            widget.data.children![widget.index].firstname![0]
                                    .toUpperCase() +
                                "" +
                                widget.data.children![widget.index].lastname![0]
                                    .toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : ClipOval(
                            child: Image.network(
                              api_url2 +
                                  '/uploads/users/' +
                                  widget.data.children![widget.index].userImage
                                      .toString(),
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GFCard(
              boxFit: BoxFit.cover,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              title: GFListTile(
                color: white,
                shadow: BoxShadow(color: Colors.transparent),

                icon: IconButton(
                  icon: Icon(Icons.swap_vert),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Childrenscreen()));
                  },
                ),
                avatar: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          widget.data.children![widget.index].userImage == null
                              ? Colors.grey
                              : Colors.white,
                      child: widget.data.children![widget.index].userImage == null
                          ? Text(
                              widget.data.children![widget.index].firstname![0]
                                      .toUpperCase() +
                                  "" +
                                  widget.data.children![widget.index].lastname![0]
                                      .toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white),
                            )
                          : ClipOval(
                              child: Image.network(
                                api_url2 +
                                    '/uploads/users/' +
                                    widget.data.children![widget.index].userImage
                                        .toString(),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )),
                ),
                title: Builder(builder: (context) {
                  var full_name =
                      widget.data.children![widget.index].firstname.toString() +
                          " " +
                          widget.data.children![widget.index].lastname.toString();
                  return Text(
                    full_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
                subTitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.children![widget.index].email.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data.children![widget.index].course.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data.children![widget.index].batch.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shadowColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Routineparent(
                                            batch: widget.data
                                                .children?[widget.index].batch,
                                            institution: widget
                                                .data
                                                .children?[widget.index]
                                                .institution,
                                          )));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/routinenew.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Routines',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.data.children?[widget.index]
                                              .institution ==
                                          "softwarica" ||
                                      widget.data.children?[widget.index]
                                              .institution ==
                                          "sunway") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          ResultSoftwarica(
                                            institution: widget
                                                .data
                                                .children?[widget.index]
                                                .institution,
                                            studentID: widget
                                                .data
                                                .children?[widget.index]
                                                .username,
                                            dues: widget.data.children?[widget.index].dues ?? false,
                                          ),
                                        ));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultParent(
                                            institution: widget
                                                .data
                                                .children?[widget.index]
                                                .institution,
                                            studentID: widget
                                                .data
                                                .children?[widget.index]
                                                .username,
                                          ),
                                        ));
                                  }
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/result_t.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Result',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AttendanceParent(
                                          isParent: true,
                                          batch: widget.data
                                              .children?[widget.index].batch
                                              .toString(),
                                          institution: widget
                                              .data
                                              .children?[widget.index]
                                              .institution
                                              .toString(),
                                          username: widget.data
                                              .children?[widget.index].username
                                              .toString(),
                                        ),
                                      ));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/capture.PNG',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Attendance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Eventparents(
                                          institution: widget
                                              .data
                                              .children?[widget.index]
                                              .institution
                                              .toString(),
                                          batch: widget.data
                                              .children?[widget.index].batch
                                              .toString(),
                                        ),
                                      ));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/events.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Events',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ParentFeeScreen(
                                            data: widget.data,
                                            index: widget.index),
                                      ));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/fees.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Fees',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )),
                            user?.institutionType == "School" ?
                            Expanded(
                                child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ParentHomeworkScreen(
                                                  institution: widget
                                                      .data
                                                      .children?[widget.index]
                                                      .institution
                                                      .toString(),
                                                  username: widget
                                                      .data
                                                      .children?[widget.index]
                                                      .username
                                                      .toString())
                                          // Viewparentrequestscreen(),
                                          ));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/books.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        'Digital Diary',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            )) : const Expanded(child: SizedBox()),
                          ],
                        ),
                      )),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Parentrequestscreen(
                                institution: widget
                                    .data
                                    .children != null ? widget
                                    .data
                                    .children![widget.index]
                                    .institution.toString() : "",
                                  res: widget.data, index: widget.index),
                            ));
                      },
                      child: const Text("Create a ticket")),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParentRequestTab(showAppBar: true,),
                            ));
                      },
                      child: const Text("Ticket")),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Progress",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            child: FutureBuilder<AllProgressResponse>(
              future: progress_response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data?.allProgress == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/no_content.PNG",
                              height: 200,
                              width: 200,
                            ),
                            const Text("No module started",
                                textAlign: TextAlign.center),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.allProgress!.length,
                          itemBuilder: (context, index) {
                            var progress = snapshot.data!.allProgress![index];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    progress['moduleTitle'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: LinearPercentIndicator(
                                    width: (MediaQuery.of(context).size.width) -
                                        17,
                                    lineHeight: 16.0,
                                    center: Text(
                                      progress['progress'].toString() + "%",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    percent: progress['progress'] / 100,
                                    // header:Center(child: Text(progress['moduleTitle'],overflow: TextOverflow.ellipsis,)),
                                    backgroundColor: Colors.grey.shade100,
                                    progressColor: progress['progress'] >= 90
                                        ? Colors.green
                                        : progress['progress'] >= 50 &&
                                                progress['progress'] <= 90
                                            ? Colors.orange
                                            : progress['progress'] < 50
                                                ? Colors.red
                                                : Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Text('{$snapshot.error}');
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
