import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/announcement_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/notice_repository.dart';
import 'package:schoolworkspro_app/api/repositories/principal/notice_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/principal/add_noticeservice.dart';

class AddNoticePrincipalScreen extends StatefulWidget {
  const AddNoticePrincipalScreen({Key? key}) : super(key: key);

  @override
  _AddNoticePrincipalScreenState createState() =>
      _AddNoticePrincipalScreenState();
}

class _AddNoticePrincipalScreenState extends State<AddNoticePrincipalScreen> {
  final title_controller = TextEditingController();
  final content_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List type = [
    {"value": "Common", "name": "Common"},
    {"value": "Staff", "name": "Staff"},
    {"value": "Course", "name": "Class/Course"},
    {"value": "Batch", "name": "Section/Batch"},
    {"value": "Club", "name": "Club"},
    {"value": "Alumnus", "name": "Alumnus"},
    {"value": "Lecturer", "name": "Lecturer"},
    {"value": "Part Time Staff", "name": "Part Time Staff"},
    {"value": "Full Time Staff", "name": "Full Time Staff"},
  ];
  String? selected_post;
  List<String> selected_class = <String>[];
  List<String> selected_batch = <String>[];
  List<String> selected_club = <String>[];
  List<String> selectedDepartment = <String>[];

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

  late PrinicpalCommonViewModel _provider;
  late StatsCommonViewModel _provider2;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider.fetchCourses();

      _provider2 = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider2.fetchAllBatch();
      _provider2.fetchAllClub();
      _provider2.fetchDepartments();
    });
    super.initState();
  }

  bool course = false;
  bool batch = false;
  bool club = false;
  @override
  Widget build(BuildContext context) {
    return Consumer4<PrinicpalCommonViewModel, StatsCommonViewModel,
            CommonViewModel, AnnouncementViewModel>(
        builder: (context, value, stats, common, ann, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            "Add notice",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Form(
            key:_formKey,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Title'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: title_controller,
                  validator: (value){
                    if(value!.isEmpty || value == null){
                      return 'Please enter title';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter title of notice',
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
                child: Text('Content'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: content_controller,
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if(value!.isEmpty || value == null){
                      return 'Please enter title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Post To'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      hint: const Text('Post To'),
                      value: selected_post,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                      ),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      items: type.map((pt) {
                        return DropdownMenuItem(
                          value: pt['value'],
                          child: Text(
                            pt['name'].toString(),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selected_post = newVal as String?;
                          if (selected_post == "Common") {
                            course = false;
                            batch = false;
                            club = false;
                            selected_batch.clear();
                            selected_class.clear();
                            selected_club.clear();
                          } else if (selected_post == "Staff") {
                            course = false;
                            batch = false;
                            club = false;
                            selected_batch.clear();
                            selected_class.clear();
                            selected_club.clear();
                          } else if (selected_post == "Course") {
                            course = true;
                            batch = false;
                            club = false;
                            selected_batch.clear();
                            selected_class.clear();
                            selected_club.clear();
                          } else if (selected_post == "Batch") {
                            course = false;
                            batch = true;
                            club = false;
                            selected_batch.clear();
                            selected_class.clear();
                            selected_club.clear();
                          } else if (selected_post == "Club") {
                            course = false;
                            batch = false;
                            club = true;
                            selected_batch.clear();
                            selected_class.clear();
                            selected_club.clear();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              selected_post == "Course"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Course/Class'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDialogField(
                            // validator: ,
                            items: value.courses
                                .map((e) => MultiSelectItem(
                                    e.courseSlug.toString(),
                                    e.courseName.toString()))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            initialValue: selected_class,
                            autovalidateMode: AutovalidateMode.always,
                            onConfirm: (List<String> values) {
                              setState(() {
                                selected_class = values;
                                print(selected_class);
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              selected_post == "Batch"
                  ? Visibility(
                      visible: batch,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Batch/Section'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MultiSelectDialogField(
                              // validator: ,
                              items: stats.allbatches
                                  .map((e) => MultiSelectItem(
                                      e.batch.toString(), e.batch.toString()))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: selected_batch,
                              autovalidateMode: AutovalidateMode.always,
                              onConfirm: (List<String> values) {
                                setState(() {
                                  selected_batch = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              selected_post == "Club"
                  ? Visibility(
                      visible: club,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Clubs'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MultiSelectDialogField(
                              // validator: ,
                              items: stats.allclub
                                  .map((e) => MultiSelectItem(
                                      e.clubName.toString(),
                                      e.clubName.toString()))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: selected_club,
                              autovalidateMode: AutovalidateMode.always,
                              onConfirm: (List<String> values) {
                                setState(() {
                                  selected_club = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              selected_post == "Lecturer" || selected_post == "Staff"
                  ? Visibility(
                      // visible: club,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Departments'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MultiSelectDialogField(
                              // validator: ,
                              items: stats.department
                                  .map((e) =>
                                      MultiSelectItem(e.toString(), e.toString()))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: selectedDepartment,
                              autovalidateMode: AutovalidateMode.always,
                              onConfirm: (List<String> values) {
                                setState(() {
                                  selectedDepartment = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
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
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text('Add attachment (optional)'),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "cancel",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () async {
                          if(_formKey.currentState != null && _formKey.currentState!.validate()){
                            if (selected_post == "Batch" &&
                                selected_batch.isEmpty) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              Fluttertoast.showToast(
                                  msg: "Please select at least one batch");
                              // const SnackBar(
                              //     content: Text("Please select batch")));
                            }
                            else if (selected_post == "Course" &&
                                selected_class.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please select at least one class");
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content: Text("Please select at least one class")));
                            }
                            else {
                              try {
                                common.setLoading(true);
                                Map<String, dynamic> datas = {
                                  "noticeTitle": title_controller.text,
                                  "noticeContent": content_controller.text,
                                  "type": selected_post,

                                  if (selected_post == 'Lecturer' ||
                                      selected_post == 'Staff')
                                    "department": selectedDepartment.join(','),

                                  if (selected_post == 'Batch')
                                    "batch": selected_batch.join(','),

                                  if (selected_post == 'Course')
                                    "courseSlug": selected_class.join(','),

                                  if (selected_post == 'Club')
                                    "clubName": selected_club.join(','),

                                  // if(selected_post == 'Course')
                                  //   "courseSlug": selected_class.join(','),

                                  // selected_post == "Course"
                                  //         ? "courseSlug"
                                  //         : selected_post == "Batch"
                                  //             ? "batch"
                                  //             : selected_post == "Common" ||
                                  //                     selected_post == "Staff"
                                  //                 ? ""
                                  //                 : "clubName":
                                  //     selected_post == "Course"
                                  //         ? selected_class.join(',')
                                  //         : selected_post == "Batch"
                                  //             ? selected_batch.join(',')
                                  //             : selected_post == "Common" ||
                                  //                     selected_post == "Staff"
                                  //                 ? ""
                                  //                 : selected_club.join(',')
                                };

                                print(datas);

                                final data = await NoticePrincipalRepository()
                                    .addNoticeWithImage(datas, _imageFile);
                                print('DATA1::${data.message}');
                                if (data.success == true) {
                                  Navigator.pop(context);
                                  ann.fetchmynotices();
                                  Fluttertoast.showToast(
                                      msg: data.message.toString());
                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: data.message.toString());
                                }
                                common.setLoading(false);
                              } on Exception catch (e) {
                                print(e.toString());
                                common.setLoading(true);
                                Fluttertoast.showToast(msg: e.toString());
                                common.setLoading(false);
                                // TODO
                              }
                            }
                          }
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
