import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/fees/fees_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/stats_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_request.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_service.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feesprincipal_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/penalize/penalize_detail.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/student_stats/issue_ticketprincipal.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/studentstatsfor_principalscreen.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/response/course_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getalluser_studentstats_response.dart';
import 'package:schoolworkspro_app/services/course_service.dart';
import 'package:schoolworkspro_app/services/fees_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/lecturer/studentstats_service.dart';
import '../../../response/login_response.dart';

class PenalizeScreen extends StatefulWidget {
  const PenalizeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PenalizeScreenState createState() => _PenalizeScreenState();
}

class _PenalizeScreenState extends State<PenalizeScreen> {
  Future<GetAllUserStudentStatsResponse>? student_response;
  Icon cusIcon = const Icon(Icons.search);
  bool connected = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _listForDisplay = <dynamic>[];
  List<dynamic> _list = <dynamic>[];
  User? user;
  // Future<CourseResponse>? courseResponse;
  Widget cusSearchBar = const Text(
    'Penalize Student',
    style: TextStyle(color: Colors.black),
  );

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    final data = await StudentStatsLecturerService().getAllStudentforStats();
    for (int i = 0; i < data.users!.length; i++) {
      setState(() {
        _list.add(data.users?[i]);
        _listForDisplay = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(builder: (context, common, child) {
      return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
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

                        _searchController.clear();
                        _listForDisplay = _list;
                        this.cusSearchBar = const Text(
                          'Penalize Student',
                          style: TextStyle(color: Colors.black),
                        );
                      }
                    });
                  },
                  icon: cusIcon)
            ],
            elevation: 0.0,
            title: cusSearchBar,
            backgroundColor: Colors.white),
        body: _listForDisplay.isEmpty
            ? const SpinKitDualRing(color: kPrimaryColor)
            : getListView(common),
      );
    });
  }

  _searchBar() {
    return  Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Module",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);
    return items;
  }

  Widget getListView(CommonViewModel common) {
    var listItems = getListElements();
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: listItems.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PenalizeDetail(data: _listForDisplay[index]),
                  ));
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listItems[index]['firstname'] +
                            " " +
                            listItems[index]['lastname']),
                        Text(listItems[index]['username'] ?? ""),
                      ],
                    ),
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
            ),
          );
        });
    return listview;
  }
}
