import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/resuult_parent/result_detail.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/parent/result_header.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/response/result_response.dart';
import 'package:schoolworkspro_app/services/parents/parentresult_service.dart';

import '../../config/api_response_config.dart';
import '../result/result_view_model.dart';

class ResultSoftwarica extends StatefulWidget {
  final institution;
  final studentID;
  final bool dues;
  const ResultSoftwarica(
      {Key? key, this.institution, this.studentID, required this.dues})
      : super(key: key);

  @override
  _ResultSoftwaricaState createState() => _ResultSoftwaricaState();
}

class _ResultSoftwaricaState extends State<ResultSoftwarica> {
  Future<Resultresponse>? result_response;
  late StudentResultViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StudentResultViewModel>(context, listen: false);
      _provider.fetchChildrenResults(
          widget.studentID.toString(), widget.institution.toString());
    });

    getData();
    super.initState();
  }

  getData() async {
    final institution =
        Parentresultheader(institution: widget.institution.toString());
    result_response = Parentresultservice()
        .getallresults(institution, widget.studentID.toString());

    final abc = await Parentresultservice()
        .getallresults(institution, widget.studentID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentResultViewModel>(
        builder: (context, resultData, child) {
      return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: const Text(
              "Results",
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<Resultresponse>(
                          future: result_response,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.results!.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DataTable(
                                        showBottomBorder: true,
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                                Color(0xffCF407F)),
                                        columns: const [
                                          DataColumn(
                                              label: Text(
                                                'Subjects',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'Subjects'),
                                          DataColumn(
                                              label: Text(
                                                'cw2',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'marks of cw2'),
                                          DataColumn(
                                              label: Text(
                                                'cw1',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'marks of cw1'),
                                          DataColumn(
                                              label: Text(
                                                'cw',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'marks of cw'),
                                          DataColumn(
                                              label: Text(
                                                'Exam',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip:
                                                  'marks obtained in exam'),
                                          DataColumn(
                                              label: Text(
                                                'Credits',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'credit of subjects'),
                                          //mm
                                          DataColumn(
                                              label: Text(
                                                'Module Mark',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'Overall module marks'),
                                          DataColumn(
                                              label: Text(
                                                'Grade',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip:
                                                  'Grade in particular subject'),
                                          DataColumn(
                                              label: Text(
                                                'Tst',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'Test'),
                                          DataColumn(
                                              label: Text(
                                                'Tst1',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'Test 1'),
                                          DataColumn(
                                              label: Text(
                                                'Tst2',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                              tooltip: 'Test 2'),
                                        ],
                                        rows: snapshot.data!.results!
                                            .map((data) => DataRow(cells: [
                                                  DataCell(GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  Resultdetail(
                                                                      data:
                                                                          data),
                                                              type: PageTransitionType
                                                                  .rightToLeft));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Builder(builder:
                                                              (context) {
                                                            try {
                                                              return data.subject ==
                                                                          null ||
                                                                      data.subject!
                                                                          .isEmpty
                                                                  ? Text('')
                                                                  : Text(
                                                                      data.subject
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15),
                                                                    );
                                                            } on Exception catch (e) {
                                                              return const Text(
                                                                  "");
                                                              // TODO
                                                            }
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                                  DataCell(const Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                                  DataCell(const Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                                  DataCell(Builder(
                                                      builder: (context) {
                                                    try {
                                                      return data.cw == null ||
                                                              data.cw!.isEmpty
                                                          ? Text('')
                                                          : Text(
                                                              data.cw
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            );
                                                    } on Exception catch (e) {
                                                      return const Text("");
                                                      // TODO
                                                    }
                                                  })),
                                                  DataCell(Builder(
                                                      builder: (context) {
                                                    try {
                                                      return data.ex == null ||
                                                              data.ex!.isEmpty
                                                          ? Text("")
                                                          : Text(
                                                              data.ex
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            );
                                                    } on Exception catch (e) {
                                                      return Text("");
                                                      // TODO
                                                    }
                                                  })),
                                                  DataCell(Builder(
                                                      builder: (context) {
                                                    try {
                                                      return data.cr!.isEmpty ||
                                                              data.cr == null
                                                          ? Text('')
                                                          : Text(
                                                              data.cr
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            );
                                                    } on Exception catch (e) {
                                                      return Text("");
                                                      // TODO
                                                    }
                                                  })),
                                                  DataCell(Builder(
                                                      builder: (context) {
                                                    try {
                                                      return data.mm!.isEmpty ||
                                                              data.mm == null
                                                          ? Text('')
                                                          : Text(
                                                              data.mm
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            );
                                                    } on Exception catch (e) {
                                                      return Text('');
                                                      // TODO
                                                    }
                                                  })),
                                                  DataCell(Builder(
                                                      builder: (context) {
                                                    try {
                                                      return data.gd!.isEmpty ||
                                                              data.gd == null
                                                          ? Text('')
                                                          : Text(
                                                              data.gd
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            );
                                                    } on Exception catch (e) {
                                                      return Text('');
                                                      // TODO
                                                    }
                                                  })),
                                                  DataCell(const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                                  DataCell(const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  )),
                                                  DataCell(GestureDetector(
                                                    child: const Text(
                                                      "-",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  )),
                                                ]))
                                            .toList(),
                                      ),
                                    );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            } else {
                              return Center(
                                  child: Container());
                            }
                          },
                        ),
                        isLoading(resultData.childrenResultsApiResponse)
                            ? const Center(child: CupertinoActivityIndicator())
                            : resultData.childrenResults.marks == null ||
                                    resultData.childrenResults.columns == null
                                ? Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/no_content.PNG",
                                        ),
                                        const Text("No result available",
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 4,
                                          child: DataTable(
                                            showBottomBorder: true,
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                            columns: [
                                              const DataColumn(
                                                  label: Text(
                                                    'Subjects',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17.0,
                                                        color: Colors.white),
                                                  ),
                                                  tooltip: 'marks of Subjects'),
                                              ...List.generate(
                                                  resultData.childrenResults
                                                              .columns ==
                                                          null
                                                      ? 0
                                                      : resultData
                                                          .childrenResults
                                                          .columns!
                                                          .length, (index) {
                                                return DataColumn(
                                                  label: Text(
                                                    resultData.childrenResults
                                                        .columns![index],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17.0,
                                                        color: Colors.white),
                                                  ),
                                                );
                                              }),
                                            ],
                                            rows: List.generate(
                                                resultData.childrenResults
                                                                .marks ==
                                                            null ||
                                                        resultData
                                                            .childrenResults
                                                            .marks!
                                                            .isEmpty
                                                    ? 0
                                                    : resultData
                                                        .childrenResults
                                                        .marks!
                                                        .length, (index) {
                                              return DataRow(cells: [
                                                DataCell(GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Builder(
                                                            builder: (context) {
                                                          try {
                                                            return resultData
                                                                            .childrenResults
                                                                            .marks![index]
                                                                        [
                                                                        "moduleTitle"] ==
                                                                    null
                                                                ? const Text('-')
                                                                : Text(
                                                                    resultData
                                                                        .childrenResults
                                                                        .marks![
                                                                            index]
                                                                            [
                                                                            "moduleTitle"]
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15),
                                                                  );
                                                          } on Exception catch (e) {
                                                            return const Text(
                                                                "");
                                                            // TODO
                                                          }
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                                ...List.generate(
                                                    resultData
                                                        .childrenResults
                                                        .columns!
                                                        .length, (innerIndex) {
                                                  return DataCell(
                                                      GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Builder(builder:
                                                              (context) {
                                                            try {
                                                              return resultData
                                                                          .childrenResults
                                                                          .marks![index][resultData
                                                                              .childrenResults
                                                                              .columns![
                                                                          innerIndex]] !=
                                                                      null
                                                                  ? resultData.childrenResults.columns![innerIndex] ==
                                                                              "Mm" &&
                                                                          widget.institution ==
                                                                              "softwarica"
                                                                      ? const Text(
                                                                          "-")
                                                                      : Text(
                                                                          resultData
                                                                              .childrenResults
                                                                              .marks![index][resultData.childrenResults.columns![innerIndex]]
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        )
                                                                  : const Text("-");
                                                            } on Exception catch (e) {
                                                              return const Text(
                                                                  "");
                                                              // TODO
                                                            }
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                                }),
                                              ]);
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])),
      );
    });
  }
}
