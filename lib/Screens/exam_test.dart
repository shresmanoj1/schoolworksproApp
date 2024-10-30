import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/result_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../response/login_response.dart';
import '../constants/colors.dart';

class ResultTest extends StatefulWidget {
  const ResultTest({Key? key}) : super(key: key);

  @override
  _ResultTestState createState() => _ResultTestState();
}

class _ResultTestState extends State<ResultTest> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultViewModel>(
      create: (_) => ResultViewModel(),
      child: const ResultBody(),
    );
  }
}

class ResultBody extends StatefulWidget {
  const ResultBody({Key? key}) : super(key: key);

  @override
  _ResultBodyState createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  late CommonViewModel _commonViewModel;
  late ResultViewModel _resultViewModel;
  late User user;
  String? selected_examType;

  @override
  void initState() {
    // TODO: implement initState
    // getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _resultViewModel = Provider.of(context, listen: false);
    });

    super.initState();
  }

  // getData() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? userData = sharedPreferences.getString('_auth_');
  //   Map<String, dynamic> userMap = json.decode(userData!);
  //   User userD = User.fromJson(userMap);
  //   setState(() {
  //     user = userD;
  //   });
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     _commonViewModel = Provider.of(context, listen: false);
  //     _commonViewModel.fetchExamFromCourseStudents(user.username.toString());
  //
  //     _resultViewModel = Provider.of(context, listen: false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   title: const Text(
      //     "Results",
      //     style: TextStyle(color: white),
      //   ),
      // ),
      body: Consumer2<CommonViewModel, ResultViewModel>(
          builder: (context, common, result, child) {
        return ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            isLoading(common.examFromCourseResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : common.examsCourse.isEmpty
                    ? Image.asset('assets/images/no_content.PNG')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            hint: const Text('Select exam'),
                            value: selected_examType,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            items: common.examsCourse.map((pt) {
                              return DropdownMenuItem(
                                value: pt.examSlug,
                                child: Text(
                                  pt.examTitle.toString(),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selected_examType = newVal as String?;
                                _resultViewModel
                                    .fetchOverAllResult(selected_examType);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          selected_examType == null
                              ? Container(
                                  width: double.infinity,
                                  color: Colors.orange.shade200,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Select exam to view result"),
                                  ))
                              : isLoading(result.resultApiResponse)
                                  ? const VerticalLoader()
                                  : result.overallResult.isEmpty
                                      ? const Text(
                                          "Marks has not been released yet")
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount:
                                              result.overallResult.length,
                                          itemBuilder: (context, firstindex) {
                                            var firstData = result
                                                .overallResult[firstindex];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: logoTheme,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const Text(
                                                            "Overall Grade",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: white),
                                                          ),
                                                          Text(
                                                            firstData.totalMarks
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                color: white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        firstData.grade
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 28,
                                                            color: white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  // color: Colors.black,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.3,
                                                  child: Row(
                                                    children: const [
                                                      Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            "Subject",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text("Marks",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16))),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text("Grade",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16))),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                firstData.mark!.isEmpty
                                                    ? const SizedBox()
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...List.generate(
                                                              firstData
                                                                  .mark!.length,
                                                              (secondIndex) {
                                                            var output =
                                                                firstData.mark![
                                                                    secondIndex];
                                                            return output.marks!
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            3,
                                                                        vertical:
                                                                            8),
                                                                    child:
                                                                        ListTileTheme(
                                                                      contentPadding:
                                                                          const EdgeInsets.all(
                                                                              0),
                                                                      dense:
                                                                          true,
                                                                      horizontalTitleGap:
                                                                          0.0,
                                                                      minLeadingWidth:
                                                                          0,
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                2),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            border: Border.all(color: Colors.grey.shade200)),
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                                          child:
                                                                              ExpansionTile(
                                                                            childrenPadding:
                                                                                const EdgeInsets.symmetric(vertical: 10),
                                                                            title:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Expanded(
                                                                                    flex: 3,
                                                                                    child: Text(
                                                                                      output.module!.moduleTitle.toString(),
                                                                                      style: const TextStyle(fontSize: 16.0, color: black),
                                                                                    )),
                                                                                Expanded(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                      output.mm.toString(),
                                                                                      style: const TextStyle(fontSize: 16.0, color: black),
                                                                                    )),
                                                                                Expanded(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                      output.grade.toString(),
                                                                                      style: const TextStyle(fontSize: 16.0, color: black),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            children: <Widget>[
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: DataTable(
                                                                                    border: TableBorder.all(width: 1, style: BorderStyle.solid, color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                                                                    showBottomBorder: true,
                                                                                    columns: [
                                                                                      DataColumn(label: Container(width: MediaQuery.of(context).size.width / 2, child: const Text('Mark Title', style: TextStyle(fontWeight: FontWeight.bold)))),
                                                                                      DataColumn(
                                                                                          label: Container(
                                                                                              // width: 200,
                                                                                              child: const Text('Marks', style: TextStyle(fontWeight: FontWeight.bold)))),
                                                                                    ],
                                                                                    rows: output.marks!
                                                                                        .map(
                                                                                          (e) => DataRow(cells: [
                                                                                            DataCell(Container(width: MediaQuery.of(context).size.width / 2, child: Text(e.heading.toString()))),
                                                                                            DataCell(Container(
                                                                                                // width: 200,
                                                                                                child: Text(e.marks.toString()))),
                                                                                          ]),
                                                                                        )
                                                                                        .toList()),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                          }),
                                                        ],
                                                      ),
                                                const SizedBox(
                                                  height: 100,
                                                ),
                                              ],
                                            );
                                          },
                                        )
                        ],
                      ),
          ],
        );
      }),
    );
  }
}
