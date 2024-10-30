import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_view_model.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
// import '../../response/assignment_details_response.dart';
import '../../response/common_response.dart';
import '../my_learning/homework/assignment_view_model.dart';
import '../../response/assignment_response.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  final Assignment args;
  final String moduleSlug;
  const AssignmentDetailsScreen(
      {Key? key, required this.args, required this.moduleSlug})
      : super(key: key);

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  bool isloading = false;
  String? selectedBatch;
  late AssignmentViewModel _provider3;
  late CommonViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider3 = Provider.of<AssignmentViewModel>(context, listen: false);
      _provider2.setSlug(widget.moduleSlug);
      _provider2.fetchBatches();
      // fetchBatch(_provider2.selectModuleSlug);
    });
    super.initState();
  }

  _launchURL(String abc, String content) async {
    var linkUrl = content.replaceAll(" ", "%20");
    String url = "https://api.schoolworkspro.com/uploads/${abc}/${linkUrl}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int SNValue = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssignmentViewModel, CommonViewModel>(
        builder: (context, snapShot, common, child) {
      return Scaffold(
        appBar: AppBar(
          // backgroundColor: white,
          elevation: 0,
          title: Text(
            widget.args.assignmentTitle.toString(),
            style: const TextStyle(color: white, fontWeight: FontWeight.w800),
          ),
        ),
        body: isLoading(common.atchesApiResponse)
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      "Select modules/subject",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      items: common.batchArr.map((pt) {
                        return DropdownMenuItem(
                          value: pt,
                          child: Text(pt),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedBatch = newVal as String?;
                        });
                        _provider3
                            .fetchLecturerAssignmentDetails(
                                widget.args.id.toString(),
                                selectedBatch.toString())
                            .then((value) {
                          _provider3.fetchStudentReportPlag(
                              widget.args.id.toString());
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: kPrimaryColor)),
                        filled: true,
                        hintText: 'Select a batch/Section',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    selectedBatch == null
                        ? Center(
                            child: Text(
                              "Please select a Batch/Section",
                              style: TextStyle(fontSize: 16, color: solidRed),
                            ),
                          )
                        : isLoading(snapShot
                                    .lecturerAssignmentDetailsApiResponse) ||
                                isLoading(snapShot.studentReportPlagApiResponse)
                            ? const Center(child: CupertinoActivityIndicator())
                            : snapShot.lecturerAssignmentDetails.submission ==
                                        null ||
                                    snapShot.lecturerAssignmentDetails
                                        .submission!.isEmpty
                                ? Center(
                                    child: Text(
                                    "No submission yet",
                                    style: TextStyle(
                                        fontSize: 16, color: solidRed),
                                  ))
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        DataTable(
                                          showBottomBorder: true,
                                          headingRowColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                          columns: const [
                                            DataColumn(
                                                label: Text(
                                                  '/',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                tooltip: '/'),
                                            DataColumn(
                                                label: Text(
                                                  'Student Id',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                tooltip: 'Student Id'),
                                            DataColumn(
                                                label: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                tooltip: 'Name'),
                                            DataColumn(
                                                label: Text(
                                                  'File',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                tooltip: 'File'),
                                            DataColumn(
                                                label: Text(
                                                  'Date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                tooltip: 'Date'),
                                          ],
                                          rows: snapShot
                                              .lecturerAssignmentDetails
                                              .submission!
                                              .map((data) {
                                            SNValue += 1;
                                            return DataRow(cells: [
                                              DataCell(GestureDetector(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Column(
                                                    children: [
                                                      Builder(
                                                          builder: (context) {
                                                        try {
                                                          return Text("");
                                                        } on Exception catch (e) {
                                                          return const Text("");
                                                        }
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                              DataCell(Text(
                                                data.username.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )),
                                              DataCell(
                                                  Builder(builder: (context) {
                                                return Text(
                                                    "${data.firstname} ${data.lastname}");
                                              })),
                                              DataCell(
                                                  Builder(builder: (context) {
                                                List<Widget> listForDisplay =
                                                    [];
                                                try {
                                                  if (snapShot.studentReportPlag
                                                                  .data[
                                                              data.username] !=
                                                          null &&
                                                      data.submission != null &&
                                                      (data.submission
                                                                  ?.reportLoading ==
                                                              "SUCCESS" ||
                                                          data.submission
                                                                  ?.reportLoading ==
                                                              "FAILURE")) {
                                                    listForDisplay.add(Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            // _launchURL(data.assignment!.folderToUpload.toString(), data.submission!.contents.toString());
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Open",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        lightTabBlue),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .open_in_new,
                                                                  size: 25,
                                                                  color:
                                                                      lightTabBlue),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "${snapShot.studentReportPlag.data[data.username]["total_percentage"].toString()}%",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: snapShot.studentReportPlag.data[data.username]["total_percentage"] < 30.0
                                                                        ? Colors.green
                                                                        : snapShot.studentReportPlag.data[data.username]["total_percentage"] < 60.0
                                                                            ? Colors.yellow[700]
                                                                            : Colors.red),
                                                              ),
                                                            ),
                                                            Icon(Icons.check,
                                                                size: 20,
                                                                color: snapShot.studentReportPlag.data[data.username]
                                                                            [
                                                                            "total_percentage"] <
                                                                        30.0
                                                                    ? Colors
                                                                        .green
                                                                    : snapShot.studentReportPlag.data[data.username]["total_percentage"] <
                                                                            60.0
                                                                        ? Colors.yellow[
                                                                            700]
                                                                        : Colors
                                                                            .red),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                  } else if (data.submission
                                                              ?.reportLoading ==
                                                          "SUCCESS" &&
                                                      data.submission != null) {
                                                    listForDisplay.add(Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            _launchURL(
                                                                data.assignment!
                                                                    .folderToUpload
                                                                    .toString(),
                                                                data.submission!
                                                                    .contents
                                                                    .toString());
                                                          },
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                "Open",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        lightTabBlue),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .open_in_new,
                                                                  size: 25,
                                                                  color:
                                                                      lightTabBlue),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: const [
                                                            Text(
                                                              "N/A",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      lightTabBlue),
                                                            ),
                                                            Icon(Icons.check,
                                                                size: 20,
                                                                color:
                                                                    lightTabBlue),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                  } else if (data.submission !=
                                                          null &&
                                                      data.submission
                                                              ?.reportLoading ==
                                                          "INITIAL") {
                                                    listForDisplay.add(Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            _launchURL(
                                                                data.assignment!
                                                                    .folderToUpload
                                                                    .toString(),
                                                                data.submission!
                                                                    .contents
                                                                    .toString());
                                                          },
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                "Open",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        lightTabBlue),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .open_in_new,
                                                                  size: 25,
                                                                  color:
                                                                      lightTabBlue),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: const [
                                                            Text(
                                                              "N/A",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      lightTabBlue),
                                                            ),
                                                            Icon(Icons.check,
                                                                size: 20,
                                                                color:
                                                                    lightTabBlue),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                  } else if (data.submission ==
                                                      null) {
                                                    listForDisplay
                                                        .add(const Text(
                                                      "Not\n Submitted",
                                                      style: TextStyle(
                                                          color: solidRed2),
                                                    ));
                                                  }
                                                  return Column(
                                                    children: listForDisplay,
                                                  );
                                                } on Exception catch (e) {
                                                  print(e.toString());

                                                  return const Text("");
                                                }
                                              })),
                                              DataCell(
                                                  Builder(builder: (context) {
                                                try {
                                                  return data.submission == null
                                                      ? Text(
                                                          "N/A",
                                                          style: TextStyle(
                                                              color: solidRed),
                                                        )
                                                      : Text(
                                                          "${DateFormat.yMMMd().format(DateTime.parse(data.submission!.updatedAt.toString()))}  ${DateFormat.jm().format(DateTime.parse(data.submission!.updatedAt.toString()))}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        );
                                                } on Exception catch (e) {
                                                  return Text(e.toString());
                                                }
                                              })),
                                            ]);
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                  ],
                ),
              ),
      );
    });
  }
}
