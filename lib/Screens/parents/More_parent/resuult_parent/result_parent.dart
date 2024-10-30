import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/result_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolworkspro_app/response/login_response.dart';

class ResultParent extends StatefulWidget {
  final institution;
  final studentID;
  const ResultParent({
    Key? key,
    this.institution,
    this.studentID,
  }) : super(key: key);

  @override
  _ResultParentState createState() => _ResultParentState();
}

class _ResultParentState extends State<ResultParent> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultViewModel>(
      create: (_) => ResultViewModel(),
      child: ResultBody(
          institution: widget.institution, studentID: widget.studentID),
    );
  }
}

class ResultBody extends StatefulWidget {
  final institution;
  final studentID;
  const ResultBody({Key? key, this.institution, this.studentID})
      : super(key: key);

  @override
  _ResultBodyState createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  late CommonViewModel _commonViewModel;
  late ResultViewModel _resultViewModel;
  String? selected_examType;

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _resultViewModel = Provider.of(context, listen: false);
      _resultViewModel.fetchExamForParents(
          widget.studentID, widget.institution);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Results",
          // style: TextStyle(color: Colors.black),
        ),
        // iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.white,
      ),
      body: Consumer2<CommonViewModel, ResultViewModel>(
          builder: (context, common, result, child) {
        return ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            isLoading(result.examForParentsResponse) ? const VerticalLoader() :
            result.examParents.isEmpty
                ? Image.asset('assets/images/no_content.PNG')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField(
                        hint: const Text('Select exam'),
                        value: selected_examType,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: result.examParents.map((pt) {
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
                            _resultViewModel.fetchresultforParent(
                                selected_examType, widget.studentID);
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
                          : isLoading(result.parentResultApiResponse)
                              ? const VerticalLoader()
                              : result.parentResult.isEmpty
                                  ? const Text("Marks has not been released yet")
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: result.parentResult.length,
                                      itemBuilder: (context, firstindex) {
                                        var firstData =
                                            result.parentResult[firstindex];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'AGG: ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: firstData.totalMarks
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'Grade: ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: firstData.grade
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ...List.generate(
                                                firstData.mark!.length,
                                                (secondIndex) {
                                              var output =
                                                  firstData.mark![secondIndex];
                                              return Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(output
                                                          .module!.moduleTitle
                                                          .toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: 'Grade: ',
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  output.grade,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: 'Marks: ',
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: output.mm
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: DataTable(
                                                          columns: [
                                                            DataColumn(
                                                                label: Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                        'marks title'))),
                                                            DataColumn(
                                                                label: Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                        'marks'))),
                                                          ],
                                                          rows: output.marks!
                                                              .map(
                                                                (e) => DataRow(
                                                                    cells: [
                                                                      DataCell(Container(
                                                                          width:
                                                                              200,
                                                                          child: Text(e
                                                                              .heading
                                                                              .toString()))),
                                                                      DataCell(Container(
                                                                          width:
                                                                              200,
                                                                          child: Text(e
                                                                              .marks
                                                                              .toString()))),
                                                                    ]),
                                                              )
                                                              .toList()),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
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
