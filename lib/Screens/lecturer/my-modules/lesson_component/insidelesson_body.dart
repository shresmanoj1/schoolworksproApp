import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/add_assessment/add_assessment.dart';
import 'package:schoolworkspro_app/Screens/lecturer/add_assessment/assessment_submissionscreen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/add_assessment/edit_assessment.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';

class InsideLessonActivity extends StatefulWidget {
  final moduleSlug;
  final lessonSlug;
  final checkNav;
  const InsideLessonActivity(
      {Key? key, this.moduleSlug, this.lessonSlug, this.checkNav})
      : super(key: key);

  @override
  _InsideLessonActivityState createState() =>
      _InsideLessonActivityState();
}

class _InsideLessonActivityState extends State<InsideLessonActivity> {
  String? selected_batch;
  late CommonViewModel _provider;

  late LecturerCommonViewModel _provider2;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider =
          Provider.of<CommonViewModel>(context, listen: false);
      _provider2 = Provider.of<LecturerCommonViewModel>(context,
          listen: false);

      _provider.setSlug(widget.moduleSlug);
      _provider.fetchBatches();
      _provider2 = Provider.of<LecturerCommonViewModel>(context,
          listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.checkNav == true
            ? AppBar(
                title: const Text(
                  "Your Task",
                  style: TextStyle(color: white),
                ),
                elevation: 0.0,
                centerTitle: false,
        )
            : null,
        body: SafeArea(
          child: Consumer2<CommonViewModel, LecturerCommonViewModel>(
              builder: (context, data, value, child) {
            return isLoading(data.atchesApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      const Text(
                        "Batch/Section",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        hint: const Text('Select batch/Section'),
                        value: selected_batch,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                        ),
                        icon: const Icon(
                            Icons.arrow_drop_down_outlined),
                        items: data.batchArr.map((pt) {
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
                            selected_batch = newVal as String?;

                            value.fetchinsideactivity(widget.lessonSlug.toString());

                            // Map<String, dynamic> datas = {
                            //   "batch": selected_batch,
                            //   "moduleSlug": widget.data['moduleSlug']
                            // };
                            // _provider2.fetchAssessmentStats(datas);
                          });
                        },
                      ),
                      selected_batch == null
                          ? Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddActivityScreen(
                                              moduleSlug:
                                                  widget.moduleSlug,
                                              lessonSlug: widget
                                                  .lessonSlug
                                                  .toString(),
                                            ),
                                          ));
                                    },
                                    child:
                                        const Text('Add Task')),
                                Image.asset(
                                    'assets/images/no_content.PNG')
                              ],
                            )
                          : isLoading(value
                                  .insidelessonactivityApiResponse)
                              ? const Center(
                                  child: CupertinoActivityIndicator()
                                )
                              : value.insideActivity.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddActivityScreen(
                                                      moduleSlug: widget
                                                          .moduleSlug,
                                                      lessonSlug: widget
                                                          .lessonSlug
                                                          .toString(),
                                                    ),
                                                  ));
                                            },
                                            child: const Text(
                                                'Add Task')),
                                        Image.asset(
                                            'assets/images/no_content.PNG')
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            bool checkAssessment = false;
                                            try{
                                             for(int i = 0; i < value.insideActivity.length; i++){
                                               if(value.insideActivity[i]['batches'].contains(selected_batch)){
                                                 checkAssessment = true;
                                                 break;
                                               }
                                             }
                                            }catch(e){
                                              print(e);
                                            }
                                            return checkAssessment ==true ?
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                              const ScrollPhysics(),
                                              itemCount: value
                                                  .insideActivity.length,
                                              itemBuilder: (context, i) {
                                                if (value.insideActivity[i]['batches'].contains(selected_batch)) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Container(
                                                          width: double
                                                              .infinity,
                                                          child: Html(
                                                            style: {
                                                              "ol": Style(
                                                                  margin:
                                                                  const EdgeInsets.all(5))
                                                            },
                                                            shrinkWrap:
                                                            true,
                                                            customRender: {
                                                              "table": (context, child) {
                                                                return SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: (context.tree as TableLayoutElement).toWidget(context),
                                                                );
                                                              }
                                                            },
                                                            data: value
                                                                .insideActivity[i]
                                                            [
                                                            'contents'],
                                                            onLinkTap: (String?
                                                            url,
                                                                RenderContext
                                                                context,
                                                                Map<String,
                                                                    String>
                                                                attributes,
                                                                dom.Element?
                                                                element) {
                                                              Future<void>
                                                              _launchInBrowser(
                                                                  Uri url) async {
                                                                if (await launchUrl(
                                                                  url,
                                                                  mode: LaunchMode
                                                                      .externalApplication,
                                                                )) {
                                                                  throw 'Could not launch $url';
                                                                }
                                                              }

                                                              var linkUrl =
                                                              url!.replaceAll(
                                                                  " ",
                                                                  "%20");
                                                              _launchInBrowser(
                                                                  Uri.parse(
                                                                      linkUrl));
                                                            },
                                                            onImageTap: (String?
                                                            url,
                                                                RenderContext
                                                                context,
                                                                Map<String,
                                                                    String>
                                                                attributes,
                                                                dom.Element?
                                                                element) {
                                                              launch(
                                                                  url!);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        width: double
                                                            .infinity,
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        decoration:
                                                        BoxDecoration(
                                                          color: Colors
                                                              .blue
                                                              .shade100,
                                                        ),
                                                        child: Builder(
                                                            builder:
                                                                (context) {
                                                              DateTime now = DateTime.parse(value
                                                                  .insideActivity[
                                                              i][
                                                              'dueDate']
                                                                  .toString());

                                                              now = now.add(
                                                                  const Duration(
                                                                      hours:
                                                                      5,
                                                                      minutes:
                                                                      45));

                                                              var formattedTime =
                                                              DateFormat(
                                                                  'y, MMMM d, EEEE, hh:mm a')
                                                                  .format(
                                                                  now);

                                                              return Text(
                                                                "This task is due on: " +
                                                                    formattedTime
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue
                                                                        .shade700),
                                                              );
                                                            }),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditActivityScreen(
                                                                            data: value.insideActivity[i],
                                                                            moduleSlug:widget.moduleSlug,
                                                                          ),
                                                                    ));
                                                              },
                                                              child: const Text(
                                                                  'Edit Task')),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  primary:
                                                                  Colors
                                                                      .green),
                                                              onPressed:
                                                                  () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AssessmentSubmissionScreen(id: value.insideActivity[i]['_id'], batch: selected_batch.toString()),
                                                                    ));
                                                              },
                                                              child: const Text(
                                                                  "Check submission"))
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                                else{
                                                  return Container();
                                                }
                                              },
                                            ) :
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddActivityScreen(
                                                                  moduleSlug: widget
                                                                      .moduleSlug,
                                                                  lessonSlug: widget
                                                                      .lessonSlug
                                                                      .toString(),
                                                                ),
                                                          ));
                                                    },
                                                    child: const Text(
                                                        'Add Task')),
                                                Image.asset(
                                                    'assets/images/no_content.PNG')
                                              ],
                                            );
                                          }
                                        ),


                                      ],
                                    ),
                    ],
                  );
          }),
        ));
  }
}
