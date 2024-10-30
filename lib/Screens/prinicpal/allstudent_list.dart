import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/stats_screen.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/resuult_parent/result_parent.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_request.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_service.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feesprincipal_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/student_stats/issue_ticketprincipal.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/studentstatsfor_principalscreen.dart';
import 'package:schoolworkspro_app/Screens/result_softwarica/result_softwarica.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/getalluser_studentstats_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/lecturer/studentstats_service.dart';
import '../../api/repositories/exam_repo.dart';
import '../../helper/custom_loader.dart';
import '../../response/common_response.dart';
import '../../response/login_response.dart';
import '../widgets/snack_bar.dart';

class PrincipalAllStudentScreen extends StatefulWidget {
  const PrincipalAllStudentScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PrincipalAllStudentScreenState createState() =>
      _PrincipalAllStudentScreenState();
}

class _PrincipalAllStudentScreenState extends State<PrincipalAllStudentScreen> {
  Future<GetAllUserStudentStatsResponse>? student_response;
  Icon cusIcon = const Icon(Icons.search);
  bool connected = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _listForDisplay = <dynamic>[];
  List<dynamic> _list = <dynamic>[];
  User? user;
  // Future<CourseResponse>? courseResponse;
  Widget cusSearchBar = const Text(
    'Student Stats',
  );

  late PrinicpalCommonViewModel _provider;
  List<dynamic> filteredCardsList = [];

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  bool isloading = false;

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    final data = await StudentStatsLecturerService().activeStudentList();
    for (int i = 0; i < data.users!.length; i++) {
      setState(() {
        _list.add(data.users?[i]);
        _listForDisplay = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonViewModel, PrinicpalCommonViewModel>(
        builder: (context, common, model, child) {
          if (isloading == true ) {
            customLoadStart();
          } else {
            customLoadStop();
          }
      return Scaffold(
        appBar: AppBar(

            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (this.cusIcon.icon == Icons.search) {
                        this.cusIcon = Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        );
                        this.cusSearchBar = TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.go,
                          controller: _searchController,
                          decoration: const InputDecoration(
                              hintText: 'Search student name...',
                              border: InputBorder.none),
                          onChanged: (text) {
                            setState(() {
                              _listForDisplay = _list.where((list) {
                                var itemName = list['firstname'].toLowerCase() +
                                    " " +
                                    list['lastname'].toLowerCase();
                                return itemName.contains(text);
                              }).toList();
                            });
                          },
                        );
                      } else {
                        this.cusIcon = const Icon(Icons.search);

                        _listForDisplay = _list;
                        _searchController.clear();
                        this.cusSearchBar = const Text(
                          'Student Stats',
                        );
                      }
                    });
                  },
                  icon: cusIcon)
            ],
            elevation: 0.0,
            title: cusSearchBar,),
        body: _listForDisplay.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : getListView(common, model),
      );
    });
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);
    return items;
  }

  Widget getListView(CommonViewModel common, PrinicpalCommonViewModel model) {
    var listItems = getListElements();
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: listItems.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listItems[index]['firstname'] +
                              " " +
                              listItems[index]['lastname']),
                          Text(listItems[index]['username'] ?? ""),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(
                                  listItems[index], index, common, model)),
                            );
                          },
                          icon: const Icon(Icons.more_horiz))
                    ],
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: Builder(builder: (context) {
                    return listItems[index]['userImage'] == null ||
                            listItems[index]['userImage'] == ""
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl: "",
                                    height: 70,
                                    width: 70,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Text(
                                            listItems[index]['firstname'][0]
                                                    .toUpperCase() +
                                                "" +
                                                listItems[index]['lastname'][0]
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ))))
                        : CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              api_url2 +
                                  '/uploads/users/' +
                                  listItems[index]['userImage'],
                            ),
                            backgroundColor: Colors.transparent,
                          );
                  }),
                  trailing: listItems[index]["disableLogin"] == true
                      ? IconButton(
                          onPressed: () {
                            showEnableLoginAlert(
                                context, listItems[index]["_id"]);
                          },
                          icon: Icon(
                            Icons.login_rounded,
                            color: Colors.red,
                          ))
                      : null,
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listItems[index]['course'] ?? ""),
                      Text(listItems[index]['batch'] ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    return listview;
  }

  _listItem(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_listForDisplay[index]['firstname'] +
                          " " +
                          _listForDisplay[index]['lastname']),
                      Text("username:  ${_listForDisplay[index]['username']}"),
                    ],
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_listForDisplay[index]['course'] ?? ""),
                      Text(_listForDisplay[index]['batch'] ?? ""),
                    ],
                  ),
                ),

                // Text("Percentage: "+datas.percentage.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  showEnableLoginAlert(BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Start Exam"),
            content: SizedBox(
              height: 340,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This feature is designed for online exams, and it restricts users from logging in from a new device.However, if a user accidentally logs out, you have the option to enable this feature. Enabling it will log the user out of all current sessions, allowing them to log back in again.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  isloading = true;
                                });
                                Commonresponse res = await ExamRepository()
                                    .enableUserLogin(userId);
                                if (res.success == true) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Navigator.pop(context);
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.green,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  setState(() {
                                    isloading = false;
                                  });
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.red,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  setState(() {
                                    isloading = false;
                                  });
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  isloading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isloading = true;
                                });
                                snackThis(
                                    context: context,
                                    content: Text("Failed"),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xfff33066)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            child: const Text(
                              "Enable Login",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget bottomSheet(dynamic data, int index, CommonViewModel common,
      PrinicpalCommonViewModel model) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 350,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          model.hasPermission(["view_student_detail"]) == true
              ? ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text("View stats"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        PageTransition(
                            child:
                                StatsDetailScreen(data: _listForDisplay[index]),
                            type: PageTransitionType.leftToRight));
                  },
                )
              : const SizedBox(),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text("Result"),
            onTap: () {
              Navigator.of(context).pop();
              if (data['institution'] == "softwarica" ||
                  data['institution'] == "sunway") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultSoftwarica(
                        institution: data['institution'],
                        studentID: data['username'],
                        dues: false,
                      ),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultParent(
                        institution: data['institution'],
                        studentID: data['username'],
                      ),
                    ));
              }
            },
          ),
          model.hasPermission(["view_student_detail"])
              ? ListTile(
                  leading: Icon(Icons.money),
                  title: Text("Fees"),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (_listForDisplay[index]['institution'] == "softwarica") {
                      final data = FeeAdminRequest(
                          institution: _listForDisplay[index]['institution'],
                          studentId: _listForDisplay[index]['username']);
                      FeeServiceAdmin().duedatastart(data);
                    } else {
                      final data = FeeAdminRequest(
                          institution: _listForDisplay[index]['institution'],
                          studentId: _listForDisplay[index]['email']);
                      FeeServiceAdmin().duedatastart(data);
                    }

                    Navigator.push(
                        context,
                        PageTransition(
                            child: FeePrincipalScreen(
                                data: _listForDisplay[index]),
                            type: PageTransitionType.leftToRight));
                  },
                )
              : const SizedBox(),
          model.hasPermission(["update_student"]) == false
              ? const SizedBox()
              : ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text("Issue Ticket"),
                  onTap: () {
                    if (_listForDisplay[index]['username'] == null) {
                      Fluttertoast.showToast(
                          msg: "This user doesn't have username");
                    } else {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          PageTransition(
                              child: IssueTicketPrincipal(
                                  datas: _listForDisplay[index]),
                              type: PageTransitionType.leftToRight));
                    }
                  },
                ),
          model.hasPermission(["reset_user_password"]) == false
              ? const SizedBox()
              : ListTile(
                  leading: Icon(Icons.replay),
                  title: Text("Reset password"),
                  onTap: () async {
                    if (_listForDisplay[index]['username'] == null) {
                      Fluttertoast.showToast(
                          msg: "This user doesn't have username");
                    } else {
                      try {
                        common.setLoading(true);
                        Map<String, dynamic> datas = {
                          "_id": data['_id'],
                          "password": "password"
                        };

                        final res =
                            await StatsRepository().resetPassword(datas);
                        if (res.success == true) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: res.message.toString());
                        } else {
                          Fluttertoast.showToast(msg: res.message.toString());
                        }
                        common.setLoading(false);
                      } on Exception catch (e) {
                        // TODO
                        common.setLoading(true);
                        Fluttertoast.showToast(msg: e.toString());
                        common.setLoading(false);
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}
