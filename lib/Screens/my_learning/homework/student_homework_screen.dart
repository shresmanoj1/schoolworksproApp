import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_details.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_view_model.dart';
import 'package:schoolworkspro_app/components/date_formatter.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/api_response_config.dart';
import '../../../response/authenticateduser_response.dart';
import 'package:intl/intl.dart';

class StudentHomeWorkMainScreen extends StatefulWidget {
  final moduleSlug;
  const StudentHomeWorkMainScreen({Key? key, required this.moduleSlug})
      : super(key: key);
  @override
  State<StudentHomeWorkMainScreen> createState() =>
      _StudentHomeWorkMainScreenState();
}

class _StudentHomeWorkMainScreenState extends State<StudentHomeWorkMainScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => StudentHomeworkViewModel(),
        child: StudentHomeWorkBody(
          moduleSlug: widget.moduleSlug,
        ));
  }
}

class StudentHomeWorkBody extends StatefulWidget {
  final moduleSlug;
  StudentHomeWorkBody({Key? key, required this.moduleSlug}) : super(key: key);
  @override
  State<StudentHomeWorkBody> createState() => _StudentHomeWorkBodyState();
}

class _StudentHomeWorkBodyState extends State<StudentHomeWorkBody> {
  bool showAnswer = false;
  int clickedIndex = 0;
  late StudentHomeworkViewModel _provider;
  User? user;
  @override
  void initState() {
    getData(); // TODO: implement initState super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StudentHomeworkViewModel>(context, listen: false);
      _provider.fetchStudentHomework(
          widget.moduleSlug, user?.batch, user?.batch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<StudentHomeworkViewModel>(
        builder: (context, getHomeWork, child) {
      return isLoading(getHomeWork.getStudentHomeworkAssignment)
          ? const Center(child: CupertinoActivityIndicator())
          : ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const SizedBox(
                  height: 10,
                ),
                getHomeWork.data.task.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: getHomeWork.data.task.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 10),

                                    child: Column(
                                      children: [
                                        Builder(builder: (context) {
                                          return InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentHomeWorkDetailsMainScreen(
                                                        moduleSlug:
                                                            widget.moduleSlug,
                                                        task: getHomeWork
                                                            .data.task[index],
                                                      )),
                                            ),
                                            child: IgnorePointer(
                                                ignoring: true,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ExpansionTile(
                                                      title: Text(
                                                          getHomeWork
                                                              .data
                                                              .task[index]
                                                              .taskname
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                      trailing: const Icon(Icons
                                                          .keyboard_arrow_right),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 5),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xffD03579),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                        child: Text(
                                                          "Due on: ${DateFormat("d MMM, yyy HH:mm a, EEEE").format(getHomeWork.data.task[index].dueDate!)}",
                                                          style:
                                                              const TextStyle(
                                                            color: white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    getHomeWork.data.task
                                                                .length >=
                                                            2
                                                        ? getHomeWork.data.task
                                                                    .length ==
                                                                index + 1
                                                            ? const SizedBox(height: 10,)
                                                            : const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15.0),
                                                                child: Divider(
                                                                  color: Color(
                                                                      0xff767676),
                                                                  height: 40,
                                                                ),
                                                              )
                                                        : Container()
                                                  ],
                                                )),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      )
                    : Image.asset("assets/images/no_content.PNG"),
              ],
            );
    }));
  }
}
