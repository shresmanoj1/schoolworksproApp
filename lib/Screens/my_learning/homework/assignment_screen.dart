import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_submission_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_view_model.dart';
import 'package:schoolworkspro_app/constants/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../response/authenticateduser_response.dart';
import '../../lecturer/view_assignment_submission.dart';

class AssignmentScreen extends StatefulWidget {
  String? moduleSlug;
  bool? isTeacher;
  AssignmentScreen(
      {Key? key, required this.moduleSlug, required this.isTeacher})
      : super(key: key);
  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  late AssignmentViewModel _provider3;
  List<bool> _isExpandedList = <bool>[];

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider3 = Provider.of<AssignmentViewModel>(context, listen: false);
      refreshPage();
      _isExpandedList = List.generate(1, (index) => false);
    });
    getUser();
    super.initState();
  }

  User? user;
  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  Future<void> refreshPage() async {
    _provider3.fetchAllAssignment(widget.moduleSlug.toString());
  }

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssignmentViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return RefreshIndicator(
        onRefresh: () => refreshPage(),
        child: Scaffold(
          body: shouldShowDuesAlert(common)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      Text(
                        "Dues Amount Alert",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "You have dues amount in pending. Please clear the dues amount to submit your assignment.",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : _body(value, common),
        ),
      );
    });
  }

  Widget _body(AssignmentViewModel value, CommonViewModel common) {
    return isLoading(value.assignmentApiResponse)
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : isError(value.assignmentApiResponse) ||
                value.assignment.assignments == null ||
                value.assignment.assignments!.isEmpty
            ? Image.asset("assets/images/no_content.PNG")
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  // height: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text("Final Assignment",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          ...List.generate(value.assignment.assignments!.length,
                              (i) {
                            var index = i + 1;
                            var dataObj = value.assignment.assignments![i];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                horizontalTitleGap: 0.0,
                                contentPadding: EdgeInsets.zero,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(Icons.play_arrow_outlined,
                                                color: Color(0xff767676),
                                                size: 20),
                                            Text("Assignment",
                                                style: TextStyle(
                                                  color: Color(0xff767676),
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                        widget.isTeacher == true
                                            ? const SizedBox()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                    color: dataObj.submission ==
                                                            null
                                                        ? const Color(
                                                            0xffE80000)
                                                        : const Color(
                                                            0xff38853B),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.0)),
                                                child: Text(
                                                  dataObj.submission == null
                                                      ? "Due"
                                                      : "Completed",
                                                  style: const TextStyle(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        dataObj.assignmentTitle == null
                                            ? "N/A"
                                            : dataObj.assignmentTitle
                                                .toString(),
                                        style: const TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Builder(builder: (context) {
                                      DateTime? dateS = dataObj.dueDate;
                                      DateTime finalDate = dateS!.add(
                                          const Duration(
                                              hours: 5, minutes: 45));

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffD03579),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Text(
                                          "Due on: ${DateFormat("d MMM, yyy HH:mm a, EEEE").format(finalDate)}",
                                          style: const TextStyle(
                                            color: white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }),
                                    value.assignment.assignments!.length >= 2
                                        ? value.assignment.assignments!
                                                    .length ==
                                                i + 1
                                            ? Container()
                                            : const Divider(
                                                color: Color(0xff767676),
                                                height: 40,
                                              )
                                        : Container()
                                  ],
                                ),
                                onTap: widget.isTeacher == true
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AssignmentDetailsScreen(
                                                args: dataObj,
                                                moduleSlug: widget.moduleSlug
                                                    .toString(),
                                              ),
                                            ));
                                      }
                                    : () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AssignmentSubmissionScreen(
                                                      assignmentId:
                                                          dataObj.id.toString(),
                                                      moduleSlug: widget
                                                          .moduleSlug
                                                          .toString(),
                                                    ))).then((_) {
                                          refreshPage();
                                        });
                                      },
                              ),
                            );
                          })
                        ],
                      )
                    ],
                  ),
                ),
              );
  }

  bool shouldShowDuesAlert(CommonViewModel common) {
    if (common.authenticatedUserDetail.institution == "softwarica" ||
        common.authenticatedUserDetail.institution == "sunway") {
      return common.authenticatedUserDetail.dues ?? false;
    }
    return false;
  }
}
