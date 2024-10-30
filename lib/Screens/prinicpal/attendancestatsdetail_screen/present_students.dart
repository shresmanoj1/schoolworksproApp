import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/principal/attendancereport_response.dart';

class PresentStudents extends StatefulWidget {
  List<AttendanceTaken>? data;
  bool? title;
  PresentStudents({Key? key, this.data, this.title}) : super(key: key);

  @override
  _PresentStudentsState createState() => _PresentStudentsState();
}

class _PresentStudentsState extends State<PresentStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: widget.title == true
            ? const Text(
                "Present student's",
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                "Today's class",
                style: TextStyle(color: Colors.black),
              ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Builder(
        builder: (context) {
          return widget.data!.isNotEmpty ?
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              ...List.generate(
                  widget.data!.length,
                  (index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: widget.data?[index].moduleTitle != null ? RichText(
                              text: TextSpan(
                                text: 'Subject name: ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.data?[index].moduleTitle.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ) : null,
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Teacher name: ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            widget.data?[index].lecturer.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Present: ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            widget.data?[index].present.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Absent: ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.data?[index].absent.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
              SizedBox(
                height: 50,
              )
            ],
          ) : Image.asset("assets/images/no_content.PNG");
        }
      ),
    );
  }
}
