import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/principal/attendancereport_response.dart';

class CancelledClass extends StatefulWidget {
  List<AttendanceNotTaken>? data;
  CancelledClass({Key? key, this.data}) : super(key: key);

  @override
  _CancelledClassState createState() => _CancelledClassState();
}

class _CancelledClassState extends State<CancelledClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          "Remaining Attendance",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: widget.data!.isNotEmpty ?
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
                                text: 'Batch/Section: ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        widget.data?[index].batch.toString() ??
                                            "",
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
          SizedBox(height: 50,)
        ],
      ) : Image.asset("assets/images/no_content.PNG"),
    );
  }
}
