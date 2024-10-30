import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/admin/ticket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';

class AddRequestAdminScreen extends StatefulWidget {
  const AddRequestAdminScreen({Key? key}) : super(key: key);

  @override
  _AddRequestAdminScreenState createState() => _AddRequestAdminScreenState();
}

class _AddRequestAdminScreenState extends State<AddRequestAdminScreen> {
  List subject_ifDigitech = [
    "Complain",
    "Leave",
    "New Deployment",
    "Upgrade",
    "Update",
    "New Feature",
    "Gyapu",
    "Meetings",
    "Others"
  ];

  List subject_notDigitech = [
    "Complain",
    "Leave",
    "New Deployment",
    "Upgrade",
    "Update",
    "New Feature",
    "Meetings",
    "Others"
  ];

  List severity = [
    "Low",
    "Medium",
    "High",
    "Critical",
  ];
  String? subject_selection;
  String? severity_selection;
  User? user;

  bool _isSelfAssigned = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topic_controller = TextEditingController();
  final TextEditingController request_controller = TextEditingController();
  PickedFile? _imageFile;
  bool isloading = false;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
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

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text(
          "Add Request",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Subjects",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                user?.institution == "digitech"
                    ? DropdownButtonFormField(
                        items: subject_ifDigitech.map((pt) {
                          return DropdownMenuItem(
                            value: pt,
                            child: Text(pt),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            subject_selection = newVal as String?;

                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          filled: true,
                          hintText: 'Select subject',
                        ),
                      )
                    : DropdownButtonFormField(
                        items: subject_notDigitech.map((pt) {
                          return DropdownMenuItem(
                            value: pt,
                            child: Text(pt),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            // print(newVal);
                            subject_selection = newVal as String?;

                            // project_type = newVal;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          filled: true,
                          hintText: 'Select subject',
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Severity",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField(
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

                      // project_type = newVal;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    filled: true,
                    hintText: 'Select severity',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _topic(),
                const SizedBox(
                  height: 10,
                ),
                _request(),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Attach File (Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Self Assign',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                        value: _isSelfAssigned,
                        onChanged: (value) {
                          setState(() {
                            _isSelfAssigned = value as bool;
                          });
                        }),
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
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
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
                            if (subject_selection == null) {
                              snackThis(
                                  context: context,
                                  color: Colors.red,
                                  behavior: SnackBarBehavior.fixed,
                                  duration: 2,
                                  content: const Text(
                                      'Field subject cannot be empty'));
                            } else if (severity_selection == null) {
                              snackThis(
                                  context: context,
                                  color: Colors.red,
                                  behavior: SnackBarBehavior.fixed,
                                  duration: 2,
                                  content: const Text(
                                      'Field severity cannot be empty'));
                            } else if (topic_controller.text.isEmpty ||
                                topic_controller == null) {
                              snackThis(
                                  context: context,
                                  color: Colors.red,
                                  behavior: SnackBarBehavior.fixed,
                                  duration: 2,
                                  content: const Text(
                                      'Field topic cannot be empty'));
                            } else if (request_controller.text.isEmpty ||
                                request_controller == null) {
                              snackThis(
                                  context: context,
                                  color: Colors.red,
                                  behavior: SnackBarBehavior.fixed,
                                  duration: 2,
                                  content: const Text(
                                      'Field request cannot be empty'));
                            } else if (_imageFile != null) {
                              if (_isSelfAssigned == true) {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final res = await AdminTicketService()
                                      .addticketwithimage(
                                          request_controller.text,
                                          topic_controller.text,
                                          severity_selection.toString(),
                                          subject_selection.toString(),
                                          _imageFile!,
                                          user!.username.toString(),
                                          DateTime.now());
                                  if (res.success == true) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isloading = false;
                                    });
                                  } else {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
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
                              } else if (_isSelfAssigned == false) {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final res = await AdminTicketService()
                                      .addticketwithimage(
                                          request_controller.text,
                                          topic_controller.text,
                                          severity_selection.toString(),
                                          subject_selection.toString(),
                                          _imageFile!,
                                          null,
                                          null);
                                  if (res.success == true) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isloading = false;
                                    });
                                  } else {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
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
                            } else if (_imageFile == null) {
                              if (_isSelfAssigned == true) {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final res = await AdminTicketService()
                                      .addticketwithoutimage(
                                          request_controller.text,
                                          topic_controller.text,
                                          severity_selection.toString(),
                                          subject_selection.toString(),
                                          user!.username.toString(),
                                          DateTime.now());
                                  if (res.success == true) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isloading = false;
                                    });
                                  } else {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
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
                              } else if (_isSelfAssigned == false) {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final res = await AdminTicketService()
                                      .addticketwithoutimage(
                                          request_controller.text,
                                          topic_controller.text,
                                          severity_selection.toString(),
                                          subject_selection.toString(),
                                          null,
                                          null);
                                  if (res.success == true) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    setState(() {
                                      isloading = false;
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
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
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topic() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Topic cannot be empty';
            }
            return null;
          },
          controller: topic_controller,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Provide a topic',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          ),
        ),
      ],
    );
  }

  Widget _request() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Request cannot be empty';
            }
            return null;
          },
          controller: request_controller,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Provide a request',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          ),
        ),
      ],
    );
  }
}
