import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/submission_stats.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

import '../../../../constants/colors.dart';
import '../lesson_component/insidelesson_body.dart';

class ActivitiesScreen extends StatefulWidget {
  final data;
  const ActivitiesScreen({Key? key, this.data}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String? selected_batch;
  List<bool> _isExpandedList = <bool>[];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _provider = Provider.of<CommonViewModel>(context, listen: false);

      _provider.setSlug(widget.data['moduleSlug']);
      _provider.fetchBatches();
    });

    Fluttertoast.showToast(msg: "Select batch to procced");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CommonViewModel, LecturerCommonViewModel>(
          builder: (context, data, value, child) {
        return isLoading(data.atchesApiResponse)
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const Text(
                    "Batch/Section",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  DropdownSearch<String>(
                    dropdownSearchDecoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black38)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black38)),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      filled: true,
                      hintText: 'Select batch',
                    ),
                    showSearchBox: true,
                    maxHeight: MediaQuery.of(context).size.height / 1.2,
                    items: data.batchArr.map<String>((pt) {
                      return pt.toString();
                    }).toList(),
                    mode: Mode.BOTTOM_SHEET,

                    onChanged: (newVal) {
                      setState(() {
                        // print(newVal);

                        selected_batch = newVal as String?;
                        var _provider2 = Provider.of<LecturerCommonViewModel>(
                            context,
                            listen: false);
                        Map<String, dynamic> datas = {
                          "batch": selected_batch,
                          "moduleSlug": widget.data['moduleSlug']
                        };
                        _provider2.fetchAssessmentStats(datas);
                        _isExpandedList = List.generate(
                            widget.data["lessons"].length, (index) => false);
                      });
                    },
                  ),



                  const SizedBox(
                    height: 10,
                  ),
                  selected_batch == null
                      ? const SizedBox()
                      : isLoading(value.assessmentStatsApiResponse)
                          ? const Center(
                              child: CupertinoActivityIndicator(),
                            )
                          : value.assessmentWeeks.isEmpty
                              ? Center(
                                  child: Image.asset(
                                      'assets/images/no_content.PNG'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: value.assessmentWeeks.length,
                                  itemBuilder: (context, index) {
                                    return value.assessmentWeeks[index]
                                            .assessments!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: grey_400)),
                                              child: ExpansionTile(
                                                trailing: _isExpandedList[index]
                                                    ? const Icon(
                                                        Icons.remove,
                                                        color: grey_600,
                                                      )
                                                    : const Icon(
                                                        Icons.add,
                                                        color: grey_600,
                                                      ),
                                                onExpansionChanged:
                                                    (isExpanded) {
                                                  setState(() {
                                                    _isExpandedList[index] =
                                                        isExpanded;
                                                    for (int i = 0;
                                                        i <
                                                            _isExpandedList
                                                                .length;
                                                        i++) {
                                                      if (i != index) {
                                                        _isExpandedList[i] =
                                                            false;
                                                      }
                                                    }
                                                  });
                                                },
                                                maintainState: true,
                                                childrenPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                title: Text(
                                                  "Week ${value.assessmentWeeks[index].week}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                children: [
                                                  ...List.generate(
                                                      value
                                                          .assessmentWeeks[
                                                              index]
                                                          .assessments!
                                                          .length, (i) {
                                                    var assessment = value
                                                        .assessmentWeeks[index]
                                                        .assessments![i];
                                                    var ac = i + 1;
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          border: i ==
                                                                  (value
                                                                          .assessmentWeeks[
                                                                              index]
                                                                          .assessments!
                                                                          .length -
                                                                      1)
                                                              ? null
                                                              : const Border(
                                                                  bottom: BorderSide(
                                                                      color:
                                                                          grey_400))),
                                                      child: ListTile(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          InsideLessonActivity(
                                                                    moduleSlug:
                                                                        widget.data[
                                                                            'moduleSlug'],
                                                                    lessonSlug: assessment
                                                                        .lessonSlug
                                                                        .toString(),
                                                                    checkNav:
                                                                        true,
                                                                  ),
                                                                ));
                                                          },
                                                          trailing: Text(
                                                              "${assessment.submissionCount}/${assessment.totalCount}"),
                                                          title: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const WidgetSpan(
                                                                  child: Icon(
                                                                      Icons
                                                                          .play_arrow_outlined,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 20),
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        " Task ${ac.toString()} ",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                                TextSpan(
                                                                    text: assessment
                                                                        .lessonTitle
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15)),
                                                              ],
                                                            ),
                                                          )
                                                          ),
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                          );
                                  },
                                ),
                ],
              );
      }),
    );
  }
}
