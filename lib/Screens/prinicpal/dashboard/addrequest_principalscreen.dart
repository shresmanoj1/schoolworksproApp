import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/dashboard/addrequest_principalservice.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/admin/getstaff_service.dart';
import 'package:schoolworkspro_app/services/admin/ticket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../response/login_response.dart';

class AddRequestPrincipalScreen extends StatefulWidget {
  const AddRequestPrincipalScreen({Key? key}) : super(key: key);

  @override
  _AddRequestPrincipalScreenState createState() =>
      _AddRequestPrincipalScreenState();
}

class _AddRequestPrincipalScreenState extends State<AddRequestPrincipalScreen> {
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
  String? staff;
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

  String? display;

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

  FocusNode? assign_node;

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

    return Consumer<CommonViewModel>(
      builder: (context,common,child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0.0,
            title: Text(
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
                      height: 14,
                    ),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                          focusNode: assign_node,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(assign_node);
                            showMyDialog();
                          },
                          child: const Text(
                            "Assign Ticket",
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    staff == null
                        ? Text("")
                        : RichText(
                            text: TextSpan(
                              text: 'This ticket will be assigned to: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: staff.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Attach File (Optional)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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

                                  if (staff == null) {
                                    common.setLoading(true);
                                    final res = await AddRequestPrincipalService()
                                        .addticketprincipalwithimage(
                                            request_controller.text,
                                            severity_selection.toString(),
                                            topic_controller.text,
                                            subject_selection.toString(),
                                            _imageFile,
                                            staff.toString(),
                                            false);
                                    if (res.success == true) {
                                      Navigator.of(context).pop();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: const Text(
                                              'Request successfully created'));
                                    } else {
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content:
                                              const Text('Failed creating request'));
                                    }
                                    common.setLoading(false);
                                  } else if (staff != null) {
                                    common.setLoading(true);
                                    final res = await AddRequestPrincipalService()
                                        .addticketprincipalwithimage(
                                            request_controller.text,
                                            severity_selection.toString(),
                                            topic_controller.text,
                                            subject_selection.toString(),
                                            _imageFile,
                                            staff.toString(),
                                            true);
                                    if (res.success == true) {
                                      Navigator.of(context).pop();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: Text('Request assigned to $staff'));
                                    } else {
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: Text(
                                              'Failed assigning request to $staff'));
                                    }
                                    common.setLoading(false);
                                  }
                                } else if (_imageFile == null) {
                                  if (staff == null) {
                                    common.setLoading(true);
                                    final res = await AddRequestPrincipalService()
                                        .addticketprincipalwithoutimage(
                                            request_controller.text,
                                            severity_selection.toString(),
                                            topic_controller.text,
                                            subject_selection.toString(),
                                            staff.toString(),
                                            false);
                                    if (res.success == true) {
                                      Navigator.of(context).pop();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: const Text(
                                              'Request successfully created'));
                                    } else {
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content:
                                              const Text('Failed creating request'));
                                    }
                                    common.setLoading(false);
                                  } else if (staff != null) {
                                    common.setLoading(true);
                                    final res = await AddRequestPrincipalService()
                                        .addticketprincipalwithoutimage(
                                            request_controller.text,
                                            severity_selection.toString(),
                                            topic_controller.text,
                                            subject_selection.toString(),
                                            staff.toString(),
                                            true);
                                    if (res.success == true) {
                                      Navigator.of(context).pop();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: Text('Request assigned to $staff'));
                                    } else {
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          content: Text(
                                              'Failed assigning request to $staff'));
                                    }
                                    common.setLoading(false);
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

  void showMyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content:
            StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
          return const AlertItem();
        }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          staff = value;
        });
      }
    });
  }
}

class AlertItem extends StatefulWidget {
  const AlertItem({Key? key}) : super(key: key);

  @override
  State<AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<AlertItem> {
  String? staff;
  String? department;
  String? staff_username;
  List<dynamic> department_list = <dynamic>[];
  List<dynamic> staff_list = <dynamic>[];
  bool assignloading = false;
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  @override
  void initState() {
    // TODO: implement initState
    getStaff();
    super.initState();
  }

  getStaff() async {
    final dropdown = await StaffService().getStaff();
    for (int i = 0; i < dropdown.users!.length; i++) {
      setState(() {
        department_list.add(dropdown.users![i]['type']);
      });
    }
  }

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            final jsonList = department_list.map((e) => e).toList();

            final uniqueJsonList = jsonList.toSet().toList();

            final result = uniqueJsonList.map((e) => e).toList();

            return DropdownButton(
                value: department,
                items: result.map((pt) {
                  return DropdownMenuItem(
                    value: pt,
                    child: Text(pt),
                  );
                }).toList(),
                onChanged: (newVal) async {
                  setState(() {
                    department = newVal.toString();
                    staff_list.clear();
                  });

                  final result = await StaffService().getStaff();
                  for (int i = 0; i < result.users!.length; i++) {
                    if (result.users![i]['type'] == department) {
                      setState(() {
                        staff = null;

                        staff_list.add(result.users![i]);
                      });
                    }
                  }
                },
                hint: Text("Select department"));
          }),
        ),
        department == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                    value: staff,
                    items: staff_list.map((pt) {
                      return DropdownMenuItem(
                          value: pt['username'],
                          child: Text(pt['firstname'] + " " + pt['lastname']));
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        staff = newVal.toString();
                      });
                    },
                    hint: const Text("Select staffs"))),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                )),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, staff);
                },
                child: const Text('Confirm')),
          ],
        )
      ],
    );
  }
}
