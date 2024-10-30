import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/request/lecturer/progressstats_request.dart';
import 'package:schoolworkspro_app/request/lecturer/stats_request.dart';
import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../response/login_response.dart';

class ProgressStats extends StatefulWidget {
  final data;
  const ProgressStats({Key? key,this.data}) : super(key: key);

  @override
  _ProgressStatsState createState() => _ProgressStatsState();
}

class _ProgressStatsState extends State<ProgressStats> {
  // User ? user;
  Future<GetProgressForStatsResponse> ?  progress_response;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async{

    // final username = StudentStatsRequest(username: widget.data['username']);
    final progressRequest = ProgressStatsRequest(
        institution: widget.data['institution'], studentId: widget.data['_id']);

    progress_response =
        StudentStatsLecturerService().getUserProgress(progressRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Progress",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body:       SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<GetProgressForStatsResponse>(
            future: progress_response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print('dataaaa' +
                //     snapshot.data!.allProgress.toString());
                return snapshot.data!.allProgress!.isEmpty
                    ? Column(children: <Widget>[
                  Image.asset("assets/images/no_content.PNG"),
                  const Text(
                    "No Record",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ])
                    : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount:
                      snapshot.data?.allProgress?.length,
                      itemBuilder: (context, index) {
                        var datas =
                        snapshot.data?.allProgress?[index];
                        return Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas['moduleTitle'],
                              style:
                              const TextStyle(fontSize: 15),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 10.0),
                                      child:
                                      LinearPercentIndicator(
                                        lineHeight: 4.0,
                                        percent: double.parse(
                                            datas['progress']
                                                .toString()
                                                .split(
                                                ".")[0]) /
                                            100,
                                        backgroundColor:
                                        Colors.grey,
                                        progressColor:
                                        Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(datas['progress']
                                      .toString() +
                                      "%"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return VerticalLoader();

              }
            },
          ),
        ),
      ),
    );
  }
}
