import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/issuedbook_response.dart';
import 'package:schoolworkspro_app/services/issuedbook_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IssuedBookStats extends StatefulWidget {
  final data;
  const IssuedBookStats({Key? key,this.data}) : super(key: key);

  @override
  _IssuedBookStatsState createState() => _IssuedBookStatsState();
}

class _IssuedBookStatsState extends State<IssuedBookStats> {
  Future<Issuedbookresponse>? issue_book;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {


    issue_book = Issuedbookservice().getmyissuedbook(widget.data['username']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Issued Books",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Issuedbookresponse>(
        future: issue_book,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.issueHistory!.isEmpty ||
                snapshot.data?.issueHistory == null
                ? Column(children: <Widget>[
              Image.asset("assets/images/no_content.PNG"),
            ])
                : ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data?.issueHistory?.length,
              itemBuilder: (context, index) {
                var datas = snapshot.data?.issueHistory?[index];
                return Column(
                  children: [
                    GFListTile(
                      // avatar: Text('${index + 1}'.toString()),
                      title: Text(
                        datas['book_slug'],
                        style: TextStyle(fontSize: 16),
                      ),
                      description: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              DateTime issued =
                              DateTime.parse(datas['issue_date']);

                              issued = issued
                                  .add(const Duration(hours: 5, minutes: 45));

                              var formattedTime =
                              DateFormat('yMMMMd').format(issued);
                              return RichText(
                                text: TextSpan(
                                  text: 'Issued: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${formattedTime}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              );
                            }),
                            Builder(builder: (context) {
                              DateTime due =
                              DateTime.parse(datas['issue_date']);

                              due = due
                                  .add(const Duration(hours: 5, minutes: 45));

                              var formattedTime =
                              DateFormat('yMMMMd').format(due);
                              return RichText(
                                text: TextSpan(
                                  text: 'Due date: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${formattedTime}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            datas['renewed_history'] == null ||
                                datas["renewed_history"].isEmpty
                                ? SizedBox()
                                : ListView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount:
                              datas['renewed_history'].length,
                              itemBuilder: (context, j) {
                                var datas2 =
                                datas['renewed_history'][j];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text('Renewed History'),
                                      Builder(builder: (context) {
                                        DateTime issued =
                                        DateTime.parse(
                                            datas2['issue_date']);

                                        issued = issued.add(
                                            const Duration(
                                                hours: 5, minutes: 45));

                                        var formattedTime =
                                        DateFormat('yMMMMd')
                                            .format(issued);
                                        return RichText(
                                          text: TextSpan(
                                            text: 'Issued: ',
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                  '${formattedTime}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal)),
                                            ],
                                          ),
                                        );
                                      }),
                                      Builder(builder: (context) {
                                        DateTime due = DateTime.parse(
                                            datas2['due_date']);

                                        due = due.add(const Duration(
                                            hours: 5, minutes: 45));

                                        var formattedTime =
                                        DateFormat('yMMMMd')
                                            .format(due);
                                        return RichText(
                                          text: TextSpan(
                                            text: 'Due date: ',
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                  '${formattedTime}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal)),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ButtonBar(
                              children: [
                                datas['returned'] == true
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Builder(builder: (context) {
                                      DateTime returned =
                                      DateTime.parse(
                                          datas['return_date']);

                                      returned = returned.add(
                                          const Duration(
                                              hours: 5, minutes: 45));

                                      var formattedTime =
                                      DateFormat('yMMMMd')
                                          .format(returned);
                                      return Text("Returned on: " +
                                          formattedTime.toString());
                                    }),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.arrow_circle_up_sharp,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 5,),
                                        Text("Returned"),
                                      ],
                                    ),
                                  ],
                                )
                                    : Row(
                                  children: const [
                                    Icon(
                                      Icons.arrow_circle_down,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5,),
                                    Text('Received'),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      height: 10,
                    )
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error.toString()}');
          } else {
            return VerticalLoader();
          }
        },
      ),
    );
  }
}
