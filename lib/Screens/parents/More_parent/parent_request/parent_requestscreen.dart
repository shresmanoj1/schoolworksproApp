import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/view_parentrequestscreen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/services/addrequest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/colors.dart';
import '../../../../response/login_response.dart';

class Parentrequestscreen extends StatefulWidget {
  final Getchildrenresponse res;
  final int index;
  final String institution;
  const Parentrequestscreen({Key? key, required this.res, required this.index, required this.institution})
      : super(key: key);

  @override
  _ParentrequestscreenState createState() => _ParentrequestscreenState();
}

class _ParentrequestscreenState extends State<Parentrequestscreen> {
  String subject_selection = 'Parents';
  String severity_selection = 'High';
  String? student_name;
  String? username;
  final TextEditingController topic_controller = TextEditingController();
  final TextEditingController request_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user;

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
    student_name = widget.res.children![widget.index].firstname! +
        " " +
        widget.res.children![widget.index].lastname!;
    username = widget.res.children![widget.index].username!;

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
    print("USER DETAILS::::${user!.username}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
      //   child: FloatingActionButton.extended(
      //
      //           label: const Text("My Request"),
      //           icon: const Icon(Icons.visibility_sharp),
      //           backgroundColor: Colors.green, onPressed: () {
      //
      //             Navigator.pushNamed(context, '/viewparentrequestscreen');
      //   },
      //         ),
      // ),

      appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            "Create new ticket",
            style: TextStyle(color: white),
          ),
          // iconTheme: const IconThemeData(
          //   color: Colors.black, //change your color here
          // ),
          // backgroundColor: Colors.white
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Topic cant be empty';
                    }
                    return null;
                  },
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Request cant be empty';
                    }
                    return null;
                  },
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                          if (_formKey.currentState!.validate()) {
                            if (_imageFile == null) {
                              try {
                                print("USER INSTIFUTION:::::${user!.institution.toString()}");
                                final result = await Addrequestservice()
                                    .addmyrequestwithoutimage(
                                        request_controller.text +
                                            " Student name: $student_name Username:$username",
                                        severity_selection,
                                        topic_controller.text,
                                        subject_selection,
                                        widget.institution.toString());

                                if (result.success == true) {
                                  Navigator.pop(context);
                                  snackThis(
                                      context: context,
                                      color: Colors.green,
                                      duration: 2,
                                      content: Text(result.message.toString()));
                                  setState(() {
                                    request_controller.clear();
                                    topic_controller.clear();
                                    _imageFile = null;
                                  });
                                } else {
                                  snackThis(
                                      context: context,
                                      color: Colors.red,
                                      duration: 2,
                                      content: Text(result.message.toString()));
                                }
                              } on Exception catch (e) {
                                snackThis(
                                    context: context,
                                    color: Colors.red,
                                    duration: 2,
                                    content: Text(e.toString()));

                                // TODO
                              }
                            } else {
                              try {
                                final result = await Addrequestservice()
                                    .addmyrequestwithimage(
                                        request_controller.text +
                                            " Student name: $student_name Username:$username",
                                        severity_selection,
                                        topic_controller.text,
                                        subject_selection,
                                    widget.institution.toString(),
                                        _imageFile);
                                if (result.success == true) {
                                  Navigator.pop(context);
                                  snackThis(
                                      context: context,
                                      color: Colors.green,
                                      duration: 2,
                                      content: Text(result.message.toString()));
                                  setState(() {
                                    request_controller.clear();
                                    topic_controller.clear();
                                    _imageFile = null;
                                  });
                                } else {
                                  snackThis(
                                      context: context,
                                      color: Colors.red,
                                      duration: 2,
                                      content: Text(result.message.toString()));
                                }
                              } on Exception catch (e) {
                                snackThis(
                                    context: context,
                                    color: Colors.red,
                                    duration: 2,
                                    content: Text(e.toString()));

                                // TODO
                              }
                            }

                            // _imageFile == null
                            //     ? Addwithoutimage(
                            //         context,
                            //         request_controller,
                            //         severity_selection!,
                            //         topic_controller,
                            //         subject_selection!,
                            //       )
                            //     : Addwithimage(
                            //         context,
                            //         request_controller,
                            //         severity_selection!,
                            //         topic_controller,
                            //         subject_selection!,
                            //         _imageFile!);
                            // TODO submit
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        child: const Text(
                          "Post",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
