import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/result/result_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../response/login_response.dart';
import 'package:intl/intl.dart';
import '../parents/More_parent/resuult_parent/result_detail.dart';

class Resultscreen extends StatefulWidget {
  const Resultscreen({Key? key}) : super(key: key);

  @override
  _ResultscreenState createState() => _ResultscreenState();
}

class _ResultscreenState extends State<Resultscreen> {
  // Future<Resultresponse>? result_response;

  late StudentResultViewModel _resultViewModel;
  late CommonViewModel _provider;

  bool connected = false;
  late User user;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resultViewModel =
          Provider.of<StudentResultViewModel>(context, listen: false);
      _provider =
          Provider.of<CommonViewModel>(context, listen: false);
      _provider.fetchUser();
      _resultViewModel.fetchreslut();
      _resultViewModel.fetchMarks();
      checkInternet();
    });
    super.initState();
    // result_response = Resultservice().getmyresults();
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudentResultViewModel, CommonViewModel>(
        builder: (context, studentResult, common, child) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Results',
                style: TextStyle(color: white)),
            elevation: 0.0,
        ),
        body: connected == false
            ? const NoInternetWidget()
            : isLoading(common.userDetailsApiResponse) ||
                    isLoading(studentResult.marksApiResponse) ||
                    isLoading(studentResult.resultApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : common.user.user == null
                    ? Container()
                    : common.user.user!.dues == null
                        ? _buildBody(studentResult, common)
                        : common.user.user!.dues == true
                            ?  Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Dues Amount Alert",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "You have dues amount in pending. Please clear the dues amount to access this result",
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )
                            : studentResult.result == null
                                ? Column(children: <Widget>[
                                    Image.asset(
                                        "assets/images/no_content.PNG"),
                                    const Text(
                                      "No result available",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    const Text(
                                        "please contact exam office",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 18.0))
                                  ])
                                : Builder(
                                  builder: (context) {
                                    return _buildBody(studentResult, common);
                                  }
                                ),
      );
    });
  }

  Widget _buildBody(
      StudentResultViewModel studentResult, CommonViewModel common) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: DataTable(
                  showBottomBorder: true,
                  headingRowColor:
                      MaterialStateProperty.all(Color(0xffCF407F)),
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
                        tooltip: 'marks obtained in exam'),
                    DataColumn(
                        label: Text(
                          'Credits',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                        tooltip: 'credit of subjects'),
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
                        tooltip: 'Grade in particular subject'),
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
                  rows: studentResult.result!
                      .map((data) => DataRow(cells: [
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child:
                                            Resultdetail(data: data),
                                        type: PageTransitionType
                                            .rightToLeft));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      try {
                                        return data.subject == null ||
                                                data.subject!.isEmpty
                                            ? Text('')
                                            : Text(
                                                data.subject
                                                    .toString(),
                                                style:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight
                                                                .bold,
                                                        fontSize: 15),
                                              );
                                      } on Exception catch (e) {
                                        return const Text("");
                                        // TODO
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: Resultdetail(
                                //             data: data),
                                //         type:
                                //         PageTransitionType
                                //             .rightToLeft));
                              },
                              child: const Text(
                                '-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: Resultdetail(
                                //             data: data),
                                //         type:
                                //         PageTransitionType
                                //             .rightToLeft));
                              },
                              child: const Text(
                                '-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: Resultdetail(
                                //             data: data),
                                //         type:
                                //         PageTransitionType
                                //             .rightToLeft));
                              },
                              child: Builder(builder: (context) {
                                try {
                                  return data.cw == null ||
                                          data.cw!.isEmpty
                                      ? Text('')
                                      : Text(
                                          data.cw.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 15),
                                        );
                                } on Exception catch (e) {
                                  return const Text("");
                                  // TODO
                                }
                              }),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: Resultdetail(
                                //             data: data),
                                //         type:
                                //         PageTransitionType
                                //             .rightToLeft));
                              },
                              child: Builder(builder: (context) {
                                try {
                                  return data.ex == null ||
                                          data.ex!.isEmpty
                                      ? Text("")
                                      : Text(
                                          data.ex.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 15),
                                        );
                                } on Exception catch (e) {
                                  return Text("");
                                  // TODO
                                }
                              }),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: Resultdetail(
                                //             data: data),
                                //         type:
                                //         PageTransitionType
                                //             .rightToLeft));
                              },
                              child: Builder(builder: (context) {
                                try {
                                  return data.cr!.isEmpty ||
                                          data.cr == null
                                      ? Text('')
                                      : Text(
                                          data.cr.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 15),
                                        );
                                } on Exception catch (e) {
                                  return Text("");
                                  // TODO
                                }
                              }),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child:
                                            Resultdetail(data: data),
                                        type: PageTransitionType
                                            .rightToLeft));
                              },
                              child: Builder(builder: (context) {
                                try {
                                  return data.mm!.isEmpty ||
                                          data.mm == null
                                      ? Text('')
                                      : Text(
                                          common.user.user
                                                      ?.institution ==
                                                  "softwarica"
                                              ? "-"
                                              : data.mm.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 15),
                                        );
                                } on Exception catch (e) {
                                  return Text('');
                                  // TODO
                                }
                              }),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child:
                                            Resultdetail(data: data),
                                        type: PageTransitionType
                                            .rightToLeft));
                              },
                              child: Builder(builder: (context) {
                                try {
                                  return data.gd!.isEmpty ||
                                          data.gd == null
                                      ? Text('')
                                      : Text(
                                          data.gd.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 15),
                                        );
                                } on Exception catch (e) {
                                  return Text('');
                                  // TODO
                                }
                              }),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child:
                                            Resultdetail(data: data),
                                        type: PageTransitionType
                                            .rightToLeft));
                              },
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child:
                                            Resultdetail(data: data),
                                        type: PageTransitionType
                                            .rightToLeft));
                              },
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                            DataCell(GestureDetector(
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                          ]))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            studentResult.marks.marks != null &&
                    studentResult.marks.columns != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: DataTable(
                        showBottomBorder: true,
                        headingRowColor:
                            MaterialStateProperty.all(const Color(0xffCF407F)),
                        columns: [
                          const DataColumn(
                              label: Text(
                                'Subjects',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: Colors.white),
                              ),
                              tooltip: 'marks of Subjects'),
                          ...List.generate(
                              studentResult.marks.columns!.length,
                              (index) {
                            return DataColumn(
                              label: Text(
                                studentResult.marks.columns![index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: Colors.white),
                              ),
                            );
                          }),
                          const DataColumn(
                              label: Text(
                                'Released Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: Colors.white),
                              ),
                              tooltip: 'Released Date'),
                        ],
                        rows: List.generate(
                            studentResult.marks.marks!.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      try {
                                        return studentResult.marks
                                                        .marks![index]
                                                    ["moduleTitle"] ==
                                                null
                                            ? const Text('-')
                                            : Text(
                                                studentResult
                                                    .marks
                                                    .marks![index][
                                                        "moduleTitle"]
                                                    .toString(),
                                                style:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight
                                                                .bold,
                                                        fontSize: 15),
                                              );
                                      } on Exception catch (e) {
                                        return const Text("");
                                        // TODO
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            )),
                            ...List.generate(
                                studentResult.marks.columns!.length,
                                (innerIndex) {
                              return DataCell(GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: [
                                      Builder(builder: (context) {
                                        try {
                                          return studentResult.marks
                                                          .marks![
                                                      index][studentResult
                                                          .marks
                                                          .columns![
                                                      innerIndex]] !=
                                                  null
                                              ? studentResult.marks.columns![innerIndex] == "Mm" &&  common.user.user!.institution == "softwarica" ? Text("-") : Text(
                                                  studentResult
                                                      .marks
                                                      .marks![index][
                                                          studentResult
                                                                  .marks
                                                                  .columns![
                                                              innerIndex]]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                      fontSize: 15),
                                                )
                                              : const Text("-");
                                        } on Exception catch (e) {
                                          return const Text("");
                                          // TODO
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ));
                            }),
                            DataCell(GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      try {
                                        return studentResult.marks
                                                        .marks![index]
                                                    [
                                                    "releasedDate"] ==
                                                null
                                            ? const Text("-")
                                            : Text(
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        studentResult
                                                                .marks
                                                                .marks![index]
                                                            [
                                                            "releasedDate"])),
                                              );
                                      } on Exception catch (e) {
                                        return const Text("");
                                        // TODO
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            )),
                          ]);
                        }),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(13.0),
        child: Text(
            '** Note: If you have any issue regarding result please contact college administration **',
            style: TextStyle(
              color: Colors.grey,
            )),
      ),
      const SizedBox(
        height: 100,
      )
    ]));
  }
}
