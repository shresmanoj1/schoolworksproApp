import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/exam_test.dart';
import 'package:schoolworkspro_app/Screens/result/view_group_result_screen.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/result_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../response/authenticateduser_response.dart';
import '../lecturer/my-modules/components/group_result/group_result_view_model.dart';

class ResultTabScreen extends StatefulWidget {
  const ResultTabScreen({Key? key}) : super(key: key);

  @override
  State<ResultTabScreen> createState() => _ResultTabScreenState();
}

class _ResultTabScreenState extends State<ResultTabScreen> {
  // late CommonViewModel _provider;
  // late ResultViewModel _provider2;
  // late GroupResultViewModel _provider3;
  // late User user;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String? userData = sharedPreferences.getString('_auth_');
    // Map<String, dynamic> userMap = json.decode(userData!);
    // User userD = User.fromJson(userMap);
    // setState(() {
    //   user = userD;
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _provider = Provider.of<CommonViewModel>(context, listen: false);
      // _provider2 = Provider.of<ResultViewModel>(context, listen: false);
      // _provider3 = Provider.of<GroupResultViewModel>(context, listen: false);
      // _provider.fetchExamFromCourseStudents(user.username.toString());
      // _provider3.fetchAllResultType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupResultViewModel>(
        builder: (context, groupResult, child) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                  centerTitle: false,
                  title: const Text("Result",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.w800)),
                  elevation: 0.0,
                  iconTheme: const IconThemeData(
                    color: white,
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(55),
                    child: Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TabBar(
                          physics: const NeverScrollableScrollPhysics(),
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
                          tabs: [
                            const Tab(
                              text: "Exams",
                            ),
                            Tab(
                              text: groupResult.allResultType.allResultType !=
                                          null &&
                                      groupResult.allResultType.allResultType!
                                          .isNotEmpty
                                  ? "Internal Evaluation"
                                  : "",
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  backgroundColor: logoTheme),
              body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const ResultTest(),
                    groupResult.allResultType.allResultType != null &&
                            groupResult.allResultType.allResultType!.isNotEmpty
                        ? const ViewGroupResultScreen()
                        : Container()
                  ])));
    });
  }
}
