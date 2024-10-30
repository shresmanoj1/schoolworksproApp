import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/Screens/journey/journey_screen.dart';
import 'package:schoolworkspro_app/Screens/routines/routine_screen.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFlexiableAppBar extends StatefulWidget {
  const MyFlexiableAppBar();

  @override
  State<MyFlexiableAppBar> createState() => _MyFlexiableAppBarState();
}

class _MyFlexiableAppBarState extends State<MyFlexiableAppBar> {
  // final double appBarHeight = 66.0;
  User? user;

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
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(

        // padding: EdgeInsets.only(top: statusBarHeight),
        // margin: const EdgeInsets.only(top: 10),
        // height: 350,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 280,
              child: Column(
                children: [
                  Expanded(
                      child: Card(
                    shadowColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 3,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Routinescreen()));
                          },
                          // child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Image.asset(
                          //         'assets/images/routinenew.png',
                          //         width: 60,
                          //       ),
                          //       Text(
                          //         'Routines',
                          //         style: TextStyle(fontWeight: FontWeight.bold),
                          //       )
                          //     ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/routinenew.png',
                                  width: 60,
                                ),
                                const Text(
                                  'Routines',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/result');
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/attendance');
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/documents');
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/aaa.png',
                                  width: 60,
                                ),
                                const Text(
                                  'Documents',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(msg: "On Development phase");
                            // Navigator.of(context).pushNamed('/libraryscreen');
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/library.png',
                                  width: 60,
                                ),
                                const Text(
                                  'Library',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => JourneyScreen(
                                      // username: user!.username,
                                    )));

                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/journey.png',
                                  width: 60,
                                ),
                                const Text(
                                  'My Journey',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        ]));
  
  }
}
