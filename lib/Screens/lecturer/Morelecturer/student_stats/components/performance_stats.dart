import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/request/lecturer/stats_request.dart';
import 'package:schoolworkspro_app/response/lecturer/getperformance_stats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';

class PerformanceStats extends StatefulWidget {
  final data;
  const PerformanceStats({Key? key, this.data}) : super(key: key);

  @override
  _PerformanceStatsState createState() => _PerformanceStatsState();
}

class _PerformanceStatsState extends State<PerformanceStats> {
  Future<GetPerformanceForStatsResponse>? performance_response;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    final username = StudentStatsRequest(username: widget.data['username']);

    performance_response =
        StudentStatsLecturerService().getUserPerformance(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Performance",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<GetPerformanceForStatsResponse>(
          future: performance_response,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: const BoxDecoration(color: Colors.pinkAccent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Comments',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              '${snapshot.data?.commentCount.toString()}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 15,
                    indent: 3,
                    color: Colors.grey.shade100,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Attendance",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data?.attendance?.length,
                      itemBuilder: (context, index) {
                        var datas = snapshot.data?.attendance?[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            child: Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        datas['moduleTitle'] ?? "",
                                        style: const TextStyle(fontSize: 15),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(datas['present'].toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return VerticalLoader();
            }
          },
        ),
      ),
    );
  }
}
