import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/services/payfees_service.dart';

import '../../../helper/custom_loader.dart';

class IssueTicketPrincipal extends StatefulWidget {

  final datas;
  const IssueTicketPrincipal({Key? key,this.datas}) : super(key: key);

  @override
  _IssueTicketPrincipalState createState() => _IssueTicketPrincipalState();
}

class _IssueTicketPrincipalState extends State<IssueTicketPrincipal> {
  List subject = [
    "General Enquiry",
    "Student Update",
    "Meetings",
    "Liaison",
    "Complain",
    "Leave",
    "Logistics",
    "Fees",
    "IT",
    "Others"
  ];

  String? subject_selection;
  String? severity_selection;
  final TextEditingController topic_controller = TextEditingController();
  final TextEditingController request_controller = TextEditingController();
  bool isloading = false;

  List severity = [
    "Low",
    "Medium",
    "High",
    "Critical",
  ];

  PickedFile? _imageFile;

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
    await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No attachment selected.');
      }
    });
  }


  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "choose photo",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colors.red),
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    print('hy'+widget.datas.toString());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title:  Text(
          'Issue Ticket',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Subjects",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              items: subject.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(pt),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  // print(newVal);
                  subject_selection = newVal as String?;
                  print(subject_selection);
                  // project_type = newVal;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select subject',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Severity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              items: severity.map((ss) {
                return DropdownMenuItem(
                  value: ss,
                  child: Text(ss),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // print(newVal);
                  severity_selection = value as String?;
                  print(severity_selection);
                  // project_type = newVal;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select severity',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Topic",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: topic_controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Provide a topic',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Request",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: request_controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Describe your request',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Attach File (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet(context)));
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text('Upload Image'),
                    ),
                  ),
                ),
              ),
              // child: const ElevatedButton(
              //     onPressed: null, child: Text("Choose File"))
            ),
          ),
          _imageFile == null
              ? const SizedBox(
            height: 1,
          )
              : Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  File(
                    _imageFile!.path,
                  ),
                  height: 100,
                  width: 100,
                ),
              ),
              Positioned(
                top: -8,
                right: -2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _imageFile = null;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: SizedBox(
                  height: 40,
                  width: 95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: SizedBox(
                  height: 40,
                  width: 95,
                  child: ElevatedButton(
                    onPressed: () async {


                      var assigned_to =
                      widget.datas['username'].toString();

                      var assigned_date = DateTime.now();



                      if (_imageFile != null) {
                        try {
                          final res = await PayfeeService()
                              .addfeesticketwithimage(
                              request_controller.text,
                              severity_selection.toString(),
                              topic_controller.text,
                              subject_selection.toString(),

                              _imageFile,
                              assigned_to.toString(),
                              assigned_date);
                          if (res.success == true) {
                            setState(() {
                              isloading = true;
                              Navigator.pop(context);
                              _imageFile = null;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());

                            setState(() {
                              isloading = false;
                            });
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          }
                        } on Exception catch (e) {
                          setState(() {
                            isloading = true;
                          });
                          Fluttertoast.showToast(msg: e.toString());
                          setState(() {
                            isloading = false;
                          });
                          // TODO
                        }
                      } else {
                        try {
                          final res = await PayfeeService()
                              .addfeesticketwithoutimage(
                              request_controller.text,
                              severity_selection.toString(),
                              topic_controller.text,
                              subject_selection.toString(),

                              assigned_to.toString(),
                              assigned_date);
                          if (res.success == true) {
                            setState(() {

                              // _imageFile = null;
                            });
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          }
                        } on Exception catch (e) {
                          setState(() {
                            isloading = true;
                          });
                          Fluttertoast.showToast(msg: e.toString());
                          setState(() {
                            isloading = false;
                          });
                          // TODO
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.green),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
