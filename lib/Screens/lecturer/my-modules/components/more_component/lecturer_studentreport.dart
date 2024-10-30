import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

class LecturerStudentReport extends StatefulWidget {
  final moduleSlug;
  const LecturerStudentReport({Key? key, this.moduleSlug}) : super(key: key);

  @override
  _LecturerStudentReportState createState() => _LecturerStudentReportState();
}

class _LecturerStudentReportState extends State<LecturerStudentReport> {
  String? selected_batch;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var common = Provider.of<CommonViewModel>(context, listen: false);
      common.setSlug(widget.moduleSlug);
      common.fetchBatches();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonViewModel, LecturerCommonViewModel>(
        builder: (context, value, lecturer, child) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text(
              "Student Report",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              DropdownButtonFormField(
                hint: const Text('Select batch'),
                value: selected_batch,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                ),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                items: value.batchArr.map((pt) {
                  return DropdownMenuItem(
                    value: pt,
                    child: Text(
                      pt,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    // print(newVal);

                    selected_batch = newVal as String?;

                    Map<String, dynamic> datass = {
                      "moduleSlug": widget.moduleSlug,
                    };
                    Provider.of<LecturerCommonViewModel>(context, listen: false)
                        .fetchStudentReport(datass, selected_batch);
                  });
                },
              ),
              selected_batch == null
                  ? SizedBox()
                  : isLoading(lecturer.studentreportactivityApiResponse)
                      ? const Center(
                          child: SpinKitDualRing(
                            color: kPrimaryColor,
                          ),
                        )
                      : lecturer.lessonStatus.isEmpty
                          ? Image.asset('assets/images/no_content.PNG')
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: lecturer.lessonStatus.length,
                              itemBuilder: (context, index) {
                                var sr = lecturer.lessonStatus[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                  child: Card(
                                    child: ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                          text: 'Name: ',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: sr.name.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Batch/Section: ',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: sr.batch.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Total time spent: ',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: sr.timeSpent.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
            ],
          ));
    });
  }
}
