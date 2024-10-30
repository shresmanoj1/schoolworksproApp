import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/parent/progress_request.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
import 'package:schoolworkspro_app/services/parents/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progressparent extends StatefulWidget {
  const Progressparent({Key? key}) : super(key: key);

  @override
  _ProgressparentState createState() => _ProgressparentState();
}

class _ProgressparentState extends State<Progressparent> {
  late User user;
  Future<AllProgressResponse>? progress_response;
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
    final header = Addprogressheader(
        studentId: '6007af6b2e73fa2da94925a5', institution: 'softwarica');
    // final attendanceheader = Attendancerequest(
    //     batch: "TP-Y3-Jan2019-C",
    //     institution: "softwarica",
    //     username: "170012");
    progress_response = ProgressService().getallprogress(header);
    // attendance_response =
    //     ChildAttendanceService().getchildattendance(attendanceheader);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [

        ],
        backgroundColor: kparentsdashboard,
        elevation: 0,
        title: const Text(
          "Progress",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [

            FutureBuilder<AllProgressResponse>(
                  future: progress_response,
                  builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                ListTile(
                  trailing: Text("Total Module: "+snapshot.data!.allProgress!.length.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                  GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          snapshot.data!.allProgress!.length, (index) {
                        return CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 7.0,
                          percent: 0.8,
                          header: Text(
                            snapshot.data!.allProgress![index]["moduleTitle"],
                            overflow: TextOverflow.ellipsis,
                          ),
                          center: Text(
                            snapshot.data!.allProgress![index]["progress"]
                                    .toString() +
                                "%",
                            overflow: TextOverflow.ellipsis,
                          ),
                          backgroundColor: Colors.grey,
                          progressColor: snapshot.data!.allProgress![index]
                                      ["progress"] ==
                                  100
                              ? Colors.green
                              : snapshot.data!.allProgress![index]
                                          ["progress"] <=
                                      80
                                  ? Colors.orange
                                  : snapshot.data!.allProgress![index]
                                              ["progress"] <
                                          11
                                      ? Colors.red
                                      : Colors.orange,
                        );
                      })
                      // return
                      ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Center(
                  child: SpinKitDualRing(
                color: kPrimaryColor,
              ));
            }
                  },
                ),
          ],
        ),


        ));
  }
}
