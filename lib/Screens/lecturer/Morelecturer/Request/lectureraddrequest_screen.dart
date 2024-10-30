import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/addrequest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/colors.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../response/login_response.dart';

class LecturerAddRequestScreen extends StatefulWidget {
  const LecturerAddRequestScreen({Key? key}) : super(key: key);

  @override
  _LecturerAddRequestScreenState createState() =>
      _LecturerAddRequestScreenState();
}

class _LecturerAddRequestScreenState extends State<LecturerAddRequestScreen> {
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
  final _formKey = GlobalKey<FormState>();

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
        print('No image selected.');
      }
    });
  }

  var alertStyle = AlertStyle(
    overlayColor: Colors.blue,
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );

  User ? user;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
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
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Subjects",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //     items: subject.map((pt) {
              //       return DropdownMenuItem(
              //         value: pt,
              //         child: Text(pt),
              //       );
              //     }).toList(),
              //     onChanged: (newVal) {
              //       setState(() {
              //         // print(newVal);
              //         subject_selection = newVal as String?;
              //         print(subject_selection);
              //         // project_type = newVal;
              //       });
              //     },
              //     icon: const Icon(Icons.arrow_drop_down_outlined),
              //     decoration: const InputDecoration(
              //       border: InputBorder.none,
              //       filled: true,
              //       hintText: 'Select subject',
              //     ),
              //   ),
              // ),
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
                      subject_selection = newVal as String?;
                      print("TEST::::$subject_selection");
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select subject';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Select Subject',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    floatingLabelBehavior:
                    FloatingLabelBehavior.always,
                  ),
                  value: subject_selection,
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     "Severity",
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //     items: severity.map((ss) {
              //       return DropdownMenuItem(
              //         value: ss,
              //         child: Text(ss),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         // print(newVal);
              //         severity_selection = value as String?;
              //         print(severity_selection);
              //         // project_type = newVal;
              //       });
              //     },
              //     icon: const Icon(Icons.arrow_drop_down_outlined),
              //     decoration: const InputDecoration(
              //       border: InputBorder.none,
              //       filled: true,
              //       hintText: 'Select severity',
              //     ),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Severity",
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
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
                          severity_selection = value as String?;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select severity';
                        }
                        return null;
                      },
                      icon: const Icon(
                          Icons.arrow_drop_down_outlined),
                      decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Select severity',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                      ),
                      value: severity_selection,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Topic",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: topic_controller,
              //     keyboardType: TextInputType.text,
              //     decoration: const InputDecoration(
              //       hintText: 'Provide a topic',
              //       filled: true,
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.grey)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.green)),
              //       floatingLabelBehavior: FloatingLabelBehavior.always,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a topic';
                    }
                    return null;
                  },
                  controller: topic_controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: request_controller,
              //     keyboardType: TextInputType.text,
              //     decoration: const InputDecoration(
              //       hintText: 'Describe your request',
              //       filled: true,
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.grey)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.green)),
              //       floatingLabelBehavior: FloatingLabelBehavior.always,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: request_controller,
                  keyboardType: TextInputType.text,
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter request details';
                    }
                    return null;
                  },
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10),
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
                            MaterialStateProperty.all(solidRed),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel",
                            style: TextStyle(fontSize: 14, color: white)),
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
                          try {
                            if (subject_selection == null) {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.warning,
                                title: "Choose subject of request",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            } else if (severity_selection == null) {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.warning,
                                title: "Choose severity",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            } else if (topic_controller.text.isEmpty) {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.warning,
                                title: "Topic can't be empty",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            } else if (request_controller.text.isEmpty) {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.warning,
                                title: "Request body can't be empty",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            } else if (_imageFile == null) {
                              setState(() {
                                isloading = true;
                              });
                              final result = await Addrequestservice()
                                  .addmyrequestwithoutimage(
                                      request_controller.text,
                                      severity_selection!,
                                      topic_controller.text,
                                      subject_selection!,user!.institution.toString());
                              if (result.success == true) {
                                setState(() {
                                  isloading = true;
                                });
                                Navigator.pop(context);
                                snackThis(
                                    context: context,
                                    content: Text(result.message.toString()),
                                    color: Colors.green,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                // Navigator.pop(context);
                                setState(() {
                                  isloading = true;
                                });
                                snackThis(
                                    context: context,
                                    content: Text(result.message.toString()),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            } else {
                              setState(() {
                                isloading = true;
                              });
                              final result = await Addrequestservice()
                                  .addmyrequestwithimage(
                                      request_controller.text,
                                      severity_selection!,
                                      topic_controller.text,
                                      subject_selection!,user!.institution.toString(),
                                      _imageFile);
                              if (result.success == true) {
                                setState(() {
                                  isloading = true;
                                });
                                Navigator.pop(context);
                                snackThis(
                                    context: context,
                                    content: Text(result.message.toString()),
                                    color: Colors.green,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                setState(() {
                                  isloading = true;
                                });
                                // Navigator.pop(context);
                                snackThis(
                                    context: context,
                                    content: Text(result.message.toString()),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            }
                          } catch (e) {
                            setState(() {
                              isloading = true;
                            });
                            snackThis(
                                context: context,
                                content: Text(e.toString()),
                                color: Colors.red,
                                duration: 1,
                                behavior: SnackBarBehavior.floating);
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(logoTheme),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                        child: const Text(
                          "Post",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
