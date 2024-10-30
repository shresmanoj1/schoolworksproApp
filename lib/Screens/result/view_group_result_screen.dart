import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../components/shimmer.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../lecturer/my-modules/components/group_result/group_result_view_model.dart';

class ViewGroupResultScreen extends StatefulWidget {
  const ViewGroupResultScreen({Key? key}) : super(key: key);

  @override
  State<ViewGroupResultScreen> createState() => _ViewGroupResultScreenState();
}

class _ViewGroupResultScreenState extends State<ViewGroupResultScreen> {
  String? resultType;
  String? resultStructure;

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupResultViewModel>(
        builder: (context, groupResult, child) {
      return Scaffold(
          body: isLoading(groupResult.allResultTypeApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: [
                    groupResult.allResultType.allResultType == null
                        ? Container()
                        : DropdownButtonFormField(
                            hint: const Text('Result Types'),
                            value: resultType,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            items: groupResult.allResultType.allResultType!
                                .map((pt) {
                              return DropdownMenuItem(
                                value: pt.resultSlug ?? "",
                                child: Text(
                                  pt.resultTitle.toString(),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                print(newVal);
                                resultType = newVal as String?;
                                resultStructure = null;
                                groupResult
                                    .fetchGroupResultStructure(
                                        resultType.toString())
                                    .then((value) => {
                                          print(jsonEncode(groupResult
                                              .groupResultStructure
                                              .allResultStructure))
                                        });
                              });
                            },
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    resultType == null
                        ? Container()
                        : isLoading(groupResult.groupResultStructureApiResponse)
                            ? Container(
                                // scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return const CustomShimmer.rectangular(
                                          height: 10.0,
                                          width: double.infinity,
                                        );
                                      },
                                    )
                                  ],
                                ),
                              )
                            : groupResult.groupResultStructure
                                            .allResultStructure ==
                                        null ||
                                    groupResult.groupResultStructure
                                        .allResultStructure!.isEmpty
                                ? Container()
                                : DropdownButtonFormField(
                                    hint: const Text('Result Structure'),
                                    value: resultStructure,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                    ),
                                    icon: const Icon(
                                        Icons.arrow_drop_down_outlined),
                                    items: groupResult.groupResultStructure
                                        .allResultStructure!
                                        .map((pt) {
                                      return DropdownMenuItem(
                                        value: pt.id ?? "",
                                        child: Text(
                                          pt.identifier.toString(),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        resultStructure = newVal as String?;
                                        print("VALUE::::${resultStructure}");
                                        Map<String, dynamic> requestData = {
                                          "resultType": resultType,
                                          "groupResult": resultStructure
                                        };
                                        groupResult.fetchGroupResultStudentMark(
                                            requestData);
                                      });
                                    },
                                  ),
                    const SizedBox(
                      height: 20,
                    ),
                    resultStructure == null
                        ? Container()
                        : isLoading(groupResult.groupResultStudentMarkApiResponse)
                            ? const VerticalLoader()
                            : groupResult.groupResultStudentMark.studentList != null ||
                                    groupResult
                                        .groupResultStudentMark.studentList!.isNotEmpty
                                ? Builder(builder: (context) {
                                    List<Widget> output = [];

                                    for (var i = 0;
                                        i <
                                            (groupResult.groupResultStudentMark
                                                            .studentList ==
                                                        null ||
                                                    groupResult.groupResultStudentMark
                                                        .studentList!.isEmpty
                                                ? 0.0
                                                : groupResult.groupResultStudentMark
                                                    .studentList!.length);
                                        i++) {
                                      for (var j = 0;
                                          j <
                                              (groupResult.groupResultStudentMark
                                                              .studentList![i].marks ==
                                                          null ||
                                                      groupResult.groupResultStudentMark
                                                          .studentList![i].marks!.isEmpty
                                                  ? 0
                                                  : groupResult.groupResultStudentMark
                                                      .studentList![i].marks!.length);
                                          j++) {
                                        output.add(Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              groupResult
                                                  .groupResultStudentMark
                                                  .studentList![i]
                                                  .marks![j]
                                                  .moduleData!
                                                  .moduleTitle
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Overall: ${groupResult.groupResultStudentMark.studentList![i].marks![j].calculatedOverall}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            groupResult
                                                            .groupResultStudentMark
                                                            .studentList![i]
                                                            .marks![j]
                                                            .remarks ==
                                                        null ||
                                                    groupResult
                                                            .groupResultStudentMark
                                                            .studentList![i]
                                                            .marks![j]
                                                            .remarks ==
                                                        ""
                                                ? SizedBox()
                                                : Text(
                                                    "Remarks: ${groupResult.groupResultStudentMark.studentList![i].marks![j].remarks.toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Builder(builder: (context) {
                                              List<Widget> innerWidget = [];
                                              for (var k = 0;
                                                  k <
                                                      (groupResult
                                                                      .groupResultStudentMark
                                                                      .studentList![i]
                                                                      .marks![j]
                                                                      .marks ==
                                                                  null ||
                                                              groupResult
                                                                  .groupResultStudentMark
                                                                  .studentList![i]
                                                                  .marks![j]
                                                                  .marks!
                                                                  .isEmpty
                                                          ? 0
                                                          : groupResult
                                                              .groupResultStudentMark
                                                              .studentList![i]
                                                              .marks![j]
                                                              .marks!
                                                              .length);
                                                  k++) {
                                                innerWidget.add(Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 3, vertical: 4),
                                                  child: ListTileTheme(
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
                                                    dense: true,
                                                    horizontalTitleGap: 0.0,
                                                    minLeadingWidth: 0,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey.shade200)),
                                                      child: Theme(
                                                        data: Theme.of(context).copyWith(
                                                            dividerColor:
                                                                Colors.transparent),
                                                        child: ExpansionTile(
                                                          childrenPadding:
                                                              const EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                  vertical: 10),
                                                          title: Row(
                                                            children: [
                                                              Text(
                                                                  groupResult
                                                                      .groupResultStudentMark
                                                                      .studentList![i]
                                                                      .marks![j]
                                                                      .marks![k]
                                                                      .title
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: black)),
                                                            ],
                                                          ),
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: DataTable(
                                                                    border: TableBorder.all(
                                                                        width: 1,
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        color:
                                                                            Colors.grey,
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    5)),
                                                                    showBottomBorder:
                                                                        true,
                                                                    columns: [
                                                                      DataColumn(
                                                                          label:
                                                                              Container(
                                                                                  // width: MediaQuery.of(context).size.width / 2,
                                                                                  child: const Text(
                                                                                      'Mark Title',
                                                                                      style:
                                                                                          TextStyle(fontWeight: FontWeight.bold)))),
                                                                      DataColumn(
                                                                          label:
                                                                              Container(
                                                                                  // width: 200,
                                                                                  child: const Text(
                                                                                      'Marks',
                                                                                      style:
                                                                                          TextStyle(fontWeight: FontWeight.bold)))),
                                                                    ],
                                                                    rows: groupResult
                                                                        .groupResultStudentMark
                                                                        .studentList![i]
                                                                        .marks![j]
                                                                        .marks![k]
                                                                        .headings!
                                                                        .map(
                                                                          (e) => DataRow(
                                                                              cells: [
                                                                                DataCell(Container(
                                                                                    // width: MediaQuery.of(context).size.width / 2,
                                                                                    child: Text(e.title))),
                                                                                DataCell(Container(
                                                                                    // width: 200,
                                                                                    child: Text(e.marks.toString()))),
                                                                              ]),
                                                                        )
                                                                        .toList()),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              child: Text(
                                                                  "Total Marks: ${groupResult.groupResultStudentMark.studentList![i].marks![j].marks![k].calculatedTotal}",
                                                                  style: const TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                              }

                                              return Column(children: [
                                                ...innerWidget,
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ]);
                                            })
                                          ],
                                        ));
                                      }
                                    }
                                    return ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        ...output,
                                        SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    );
                                  })
                                : Container()
                  ],
                ));
    });
  }
}
