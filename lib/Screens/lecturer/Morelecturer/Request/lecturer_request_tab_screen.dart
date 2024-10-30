import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lecturerRequestScreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lectureraddrequest_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lecturerrequestdetail_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../response/authenticateduser_response.dart';
import '../../../../ticket_view_model.dart';
import '../../academic_request/academic_request.dart';
import '../../assigned_requestlecturer/assigned_request_lecturer.dart';

class LecturerRequestTabScreen extends StatefulWidget {
  const LecturerRequestTabScreen({Key? key}) : super(key: key);

  @override
  State<LecturerRequestTabScreen> createState() => _LecturerRequestTabScreenState();
}

class _LecturerRequestTabScreenState extends State<LecturerRequestTabScreen> with SingleTickerProviderStateMixin {
  late StatsCommonViewModel _provider;
  late RequestViewModel _provider2;
  late TicketViewModel _provider3;

  late TabController _tabController;

  final List<String> _tab = ["Create Request", "My Request", "Assigned Request", "Academic Request"];
  int selectedIndex = 0;
  User? user;

  @override
  void initState() {
    _tabController = TabController( length: _tab.length, vsync: this);
    // getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider3 = Provider.of<TicketViewModel>(context, listen: false);
      getUserData().then((_) {
        _provider3.fetchassignedrequest(user!.username.toString()).then((value) {

          int output = _provider3.backlog + _provider3.pending + _provider3.approved + _provider3.resolved;
          sharedPreferences.setInt('insideassigned', output);
        });
      });
      _provider3.fetchAcademicRequest().then((_) {
        int outputacademic = _provider3.backlogAcademic +
            _provider3.pendingAcademic +
            _provider3.approvedAcademic +
            _provider3.resolvedAcademic;
        sharedPreferences.setInt('insideacademic', outputacademic);
      });
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: const Text("Request",
                style: TextStyle(
                    color: white, fontWeight: FontWeight.w800)),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: white,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(
                  55),
              child: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: white,
                              size: 18,
                            ),
                            onPressed: () {
                                var index = _tabController.index - 1;
                                if (index >= 0 ) {
                                  _tabController.animateTo(index);
                                }

                            },
                          )),
                      Expanded(
                        flex: 10,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: logoTheme,
                          indicatorWeight: 4.0,
                          isScrollable: true,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          unselectedLabelColor: white,
                          labelColor: const Color(0xff004D96),
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: p1),
                          indicator: const BoxDecoration(
                            border: Border(),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: white,
                          ),
                          onTap: (value){
                            setState(() {
                              selectedIndex = value;
                            });
                          },
                          tabs: [
                            ...List.generate(
                              _tab.length, (index) => Tab(
                              text: _tab[index],
                            ),)
                            // Tab(
                            //   text: "Create Request",
                            // ),
                            // Tab(
                            //   text: "My Request",
                            // ),
                            // Tab(
                            //   text: "Tickets",
                            // ),
                            // Tab(
                            //   text: "Request Letter",
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: white,
                              size: 18,
                            ),
                            onPressed: () {
                              var index = _tabController.index + 1;
                              if (index < 4) {
                                _tabController.animateTo(index);
                              }
                            },
                          )),
                    ],
                  ),
                );
              }),
            ),
            backgroundColor: logoTheme),
        body: TabBarView(
          controller: _tabController,
            children: [
              LecturerAddRequestScreen(),
              LecturerRequestScreen(isAdmin: false),
              AssignedRequestLecturer(isAdmin: false),
              AcademicRequestLecturer(),
        ]));
  }
}
