import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/lecturerstudentstats_screen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/course_response.dart';
import 'package:schoolworkspro_app/response/lecturer/batchpercourse_response.dart';
import 'package:schoolworkspro_app/services/course_service.dart';
import 'package:schoolworkspro_app/services/lecturer/batchperservice.dart';

class StudentStatsFilter extends StatefulWidget {
  const StudentStatsFilter({Key? key}) : super(key: key);

  @override
  _StudentStatsFilterState createState() => _StudentStatsFilterState();
}

class _StudentStatsFilterState extends State<StudentStatsFilter> {
  Future<CourseResponse>? courseResponse;
  Future<BatchpercourseResponse>? batch_response;

  String? selected_course;
  String? selected_batch;
  @override
  void initState() {
    // TODO: implement initState
    courseResponse = CourseService().getCourse();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0.0,
          title: const Text(
            'Student stats',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            selected_batch != null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => LecturerStudentStats(
                              //         selected_batch: selected_batch,
                              //         selected_course: selected_course,
                              //       ),
                              //     ));
                            },
                            child: const Text('View all Students')),
                      ],
                    ),
                  ),
            FutureBuilder<CourseResponse>(
              future: courseResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Course",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          hint: const Text('Select a course'),
                          value: selected_course,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: snapshot.data?.courses?.map((pt) {
                            return DropdownMenuItem(
                              value: pt.courseSlug.toString(),
                              child: Text(
                                pt.courseName.toString(),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selected_course = newVal as String?;

                              selected_batch = null;
                              print(selected_course);
                            });
                            //
                            setState(() {
                              batch_response = Batchperservice()
                                  .getbatchpercourse(
                                      selected_course.toString());
                            });
                          },
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return Center(
                    child: SpinKitDualRing(
                      color: kPrimaryColor,
                    ),
                  );
                }
              },
            ),
            FutureBuilder<BatchpercourseResponse>(
              future: batch_response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Batch",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          hint: const Text('Select a batch'),
                          value: selected_batch,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: snapshot.data?.batches?.map((pt) {
                            return DropdownMenuItem(
                              value: pt['batch'],
                              child: Text(
                                pt['batch'],
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selected_batch = newVal as String?;
                            });
                            //
                          },
                        ),
                        // ...List.generate(
                        //     snapshot.data!.batches!.length,
                        //     (index) => Column(
                        //           children: [
                        //             Text(
                        //                 snapshot.data!.batches![index]['batch'])
                        //           ],
                        //         ))
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return SizedBox();
                }
              },
            ),
            selected_batch == null && selected_course == null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            onPressed: () {},
                            child: const Text('View students')),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
