import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_details.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/student_homework_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/digital_diary/digital_diary_details.dart';
import 'package:schoolworkspro_app/components/date_formatter.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/api_response_config.dart';
import '../../../response/authenticateduser_response.dart';
import 'package:intl/intl.dart';

import '../../../response/digital_diary_response.dart';

class DigitalDiaryScreen extends StatefulWidget {
  const DigitalDiaryScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<DigitalDiaryScreen> createState() => _DigitalDiaryScreenState();
}

class _DigitalDiaryScreenState extends State<DigitalDiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => StudentHomeworkViewModel(),
        child: DigitalDiaryBodyScreen());
  }
}

class DigitalDiaryBodyScreen extends StatefulWidget {
  DigitalDiaryBodyScreen({Key? key}) : super(key: key);

  @override
  State<DigitalDiaryBodyScreen> createState() => _DigitalDiaryBodyScreenState();
}

class _DigitalDiaryBodyScreenState extends State<DigitalDiaryBodyScreen> {
  late StudentHomeworkViewModel _provider;
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StudentHomeworkViewModel>(context, listen: false);
      _fetchDigitalDiaryData();
    });
  }

  Future<void> _fetchDigitalDiaryData() async {
    try {
      final formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
      _provider.fetchDigitalDiary(formattedDate);
    } catch (error) {
      // Handle errors
      print('Error fetching digital diary data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Diary"),
      ),
      body: Consumer<StudentHomeworkViewModel>(
        builder: (context, getHomeWork, child) {
          return _buildDigitalDiaryContent(getHomeWork);
        },
      ),
    );
  }

  Widget _buildDigitalDiaryContent(StudentHomeworkViewModel getHomeWork) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        DateTimePicker(
          type: DateTimePickerType.date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDate: _selectedDate,
          decoration: datePickerDecoration(),
          initialValue: DateFormat('MM/dd/yyyy').format(_selectedDate),
          dateLabelText: 'Date',
          timePickerEntryModeInput: true,
          onChanged: (val) {
            setState(() {
              DateTime originalDate = DateTime.parse(val);

              String formattedDate =
                  DateFormat('MM/dd/yyyy').format(originalDate);

              _provider.fetchDigitalDiary(formattedDate);
            });
          },
        ),
        const SizedBox(height: 10),
        isLoading(getHomeWork.getDigitalDiary)
            ? const Center(child: CupertinoActivityIndicator())
            : isError(getHomeWork.getDigitalDiary)
                ? const Center(
                    child: Text(
                        'Unable to load Digital Diary. Please try again later.'))
                : getHomeWork.digitalDiaryData.tasks?.isNotEmpty == true
                    ? getHomeWork.digitalDiaryData.tasks == null
                        ? Container()
                        : _buildTasksList(
                            getHomeWork.digitalDiaryData.tasks ?? [], getHomeWork.digitalDiaryData.allTitles ?? [])
                    : Image.asset("assets/images/no_content.PNG"),
      ],
    );
  }

  Widget _buildTasksList(List<Task> tasks, List<AllTitle> allTitles) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            var task = tasks[index];
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DigitalDiaryDetailScreen(
                                    moduleSlug: task.moduleSlug ?? "",
                                    task: task,
                                  )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.taskname ?? '',
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            var taskTitle;
                            try{
                              taskTitle = allTitles.firstWhere((element) =>
                            element.moduleSlug == task.moduleSlug);

                            }catch(e){
                              taskTitle = {"moduleTitle": ""};
                            }

                            return Text("Module Name: ${taskTitle.moduleTitle.toString()}");
                          }
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xffD03579),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            "Due on: ${DateFormat("d MMM, yyy HH:mm a, EEEE").format(task.dueDate!)}",
                            style: const TextStyle(
                              color: white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  index != tasks.length - 1
                      ? const Divider(
                    color: Color(0xff767676),
                    height: 10,
                  )
                      : Container(),
                ],
              ),
            );
          },
        ));
  }

  InputDecoration datePickerDecoration() {
    return const InputDecoration(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}
