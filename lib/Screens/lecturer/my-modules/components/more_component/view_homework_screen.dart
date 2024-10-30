import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/add_homework_task_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/check_submission.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/edit_homework_task.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/grade_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/homework_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import '../../../../../api/repositories/lecturer/homework_repository.dart';
import 'package:intl/intl.dart';
import '../../../../../constants.dart';
import '../../../../../constants/colors.dart';

//lecturer view

class ViewHomeworkScreen extends StatefulWidget {
  String moduleSlug;
  String moduleTitle;
  ViewHomeworkScreen(
      {Key? key, required this.moduleSlug, required this.moduleTitle})
      : super(key: key);
  @override
  State<ViewHomeworkScreen> createState() => _ViewHomeworkScreenState();
}

class _ViewHomeworkScreenState extends State<ViewHomeworkScreen> {
  late HomeworkViewModel _provider2;
  late CommonViewModel _provider;
  bool isloading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.setSlug(widget.moduleSlug);
      _provider.fetchBatches();

      _provider2 = Provider.of<HomeworkViewModel>(context, listen: false);
    });
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  String? selected_batch;
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CommonViewModel, HomeworkViewModel>(
          builder: (context, common, homework, child) {
        return isLoading(common.atchesApiResponse)
            ? const Center(child: CupertinoActivityIndicator())
            :  ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'select batch/section',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: common.batchArr.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_batch = newVal as String?;

                  var batch = newVal?.split(" ").join("%20");

                  _provider2.fetchHomework(widget.moduleSlug, batch);
                });
              },
              value: selected_batch,
            ),
            selected_batch != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(logoTheme),
                        ),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  PageTransition(
                                      child: HomeWorkTaskScreen(
                                        moduleSlug: widget.moduleSlug,
                                        moduleTitle: widget.moduleTitle,
                                      ),
                                      type: PageTransitionType.leftToRight))
                              .then((value) {
                            _provider2.fetchHomework(
                                widget.moduleSlug, selected_batch.toString());
                          });
                        },
                        child: const Text("New Homework/Diary"),
                      ),
                    ),
                  )
                : const SizedBox(),
            selected_batch == null
                ? const Center(child: Text(" Choose batch to proceed"))
                : isLoading(homework.homeworkApiResponse)
                    ? const Center(child: CupertinoActivityIndicator())
                    : homework.data.task.isEmpty
                        ? Image.asset('assets/images/no_content.PNG')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: homework.data.task.length,
                            itemBuilder: (context, index) {
                              var tasks = homework.data.task[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Column(
                                      children: [
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              tasks.taskname ?? "N?A",
                                              maxLines: 10,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditHomeWorkScreen(
                                                                    taskData:
                                                                        tasks,
                                                                    moduleSlug:
                                                                        widget
                                                                            .moduleSlug,
                                                                    moduleTitle:
                                                                        widget
                                                                            .moduleTitle),
                                                          )).then((value) {
                                                        homework.fetchHomework(
                                                            widget.moduleSlug,
                                                            selected_batch
                                                                .toString());
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      color: Colors.orange,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            // title: const Text('Are you sure'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this task?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // _dismissDialog();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No')),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  var res = await HomeworkRepository()
                                                                      .deleteHomework(
                                                                          tasks
                                                                              .id!);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  try {
                                                                    if (res.success ==
                                                                        true) {
                                                                      setState(
                                                                          () {
                                                                        isloading =
                                                                            true;
                                                                      });
                                                                      _provider2.fetchHomework(
                                                                          widget
                                                                              .moduleSlug,
                                                                          selected_batch);
                                                                      snackThis(
                                                                          context:
                                                                              context,
                                                                          content: Text(res.message ??
                                                                              "Successfully deleted"),
                                                                          color: Colors
                                                                              .green,
                                                                          duration:
                                                                              1,
                                                                          behavior:
                                                                              SnackBarBehavior.floating);
                                                                      setState(
                                                                          () {
                                                                        isloading =
                                                                            false;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        isloading =
                                                                            true;
                                                                      });
                                                                      snackThis(
                                                                          context:
                                                                              context,
                                                                          content: Text(res.message ??
                                                                              "Error"),
                                                                          color: Colors
                                                                              .red,
                                                                          duration:
                                                                              1,
                                                                          behavior:
                                                                              SnackBarBehavior.floating);
                                                                      setState(
                                                                          () {
                                                                        isloading =
                                                                            false;
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      isloading =
                                                                          true;
                                                                    });
                                                                    snackThis(
                                                                        context:
                                                                            context,
                                                                        content:
                                                                            Text(e
                                                                                .toString()),
                                                                        color: Colors
                                                                            .red,
                                                                        duration:
                                                                            1,
                                                                        behavior:
                                                                            SnackBarBehavior.floating);
                                                                    setState(
                                                                        () {
                                                                      isloading =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Text('Yes'),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    color: Colors.red,
                                                    child: Icon(Icons.delete,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${tasks.assignedDate!.month}/${tasks.assignedDate!.day}/${tasks.assignedDate!.year}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Text(" - "),
                                            Text(
                                              "${tasks.dueDate!.month}/${tasks.dueDate!.day}/${tasks.dueDate!.year}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(
                                                              0xff38853B)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckSubmission(
                                                              tasks: tasks,
                                                              selected_batch:
                                                                  selected_batch),
                                                    ));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.check,
                                                    color: white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("View Submission"),
                                                ],
                                              )),
                                        )
                                      ],
                                    )),
                              );
                            }),
            const SizedBox(
              height: 65,
            )
          ],
        );
      }),
    );
  }
}
