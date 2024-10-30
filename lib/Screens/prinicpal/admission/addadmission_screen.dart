import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/principal/advisor_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/request/postadvisor_request.dart';
import 'package:schoolworkspro_app/response/principal/postadvisor_response.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class AddnewAdmission extends StatefulWidget {
  const AddnewAdmission({Key? key}) : super(key: key);

  @override
  _AddnewAdmissionState createState() => _AddnewAdmissionState();
}

class _AddnewAdmissionState extends State<AddnewAdmission> {
  List<String> provience = [
    "Province 1",
    "Province 2",
    "Province 3",
    "Province 4",
    "Province 5",
    "Province 6",
    "Province 7",
  ];

  List<String> genders = ["Male", "Female", "Others"];

  String? selected_gender;

  List<String> background = ["+2", "A-Levels", "School", "Others"];

  List<String> faculty = [
    "Science",
    "Management",
    "Humanities",
    "Others",
  ];

  List<String> means = [
    "Direct Phone Call",
    "Messenger",
    "Zoom",
    "Viber",
    "Email",
    "Others",
  ];

  List<String> source = [
    "Friends / Family / Relatives",
    "Newspaper / Magazines",
    "Web Portals",
    "Education Fair",
    "Television",
    "Others",
  ];
  String? selected_provience;
  String? selected_background;
  String? selected_faculty;
  String? selected_means;
  String? selected_course;
  String? selected_source;
  final TextEditingController firstname_controller =
      new TextEditingController();
  final TextEditingController lastname_controller = new TextEditingController();
  final TextEditingController contact_controller = new TextEditingController();
  final TextEditingController email_controller = new TextEditingController();
  final TextEditingController dob_controller = new TextEditingController();
  final TextEditingController gender_controller = new TextEditingController();
  final TextEditingController address_controller = new TextEditingController();
  final TextEditingController city_controller = new TextEditingController();
  final TextEditingController provience_controller =
      new TextEditingController();
  final TextEditingController school_controller = new TextEditingController();
  final TextEditingController college_controller = new TextEditingController();
  final TextEditingController dateController = new TextEditingController();
  DateTime? dob;
  final TextEditingController percentage_controller =
      new TextEditingController();
  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrinicpalCommonViewModel>(context, listen: false)
          .fetchCourses();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Add new student",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: firstname_controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter your first name',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'First name'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: lastname_controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter your last name',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'last name'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: email_controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Enter your email',
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Email'),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: address_controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter your address',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Address'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: city_controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter your city',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'city'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      setState(() {
                        dob = date;
                      });
                    },
                    readOnly: true,
                    controller: dateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter DOB',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'DOB'),
                  ),
                  // TextField(
                  //   readOnly: true,
                  //   controller: dateController,
                  //   decoration: InputDecoration(hintText: 'Select DOB'),
                  //   onTap: () async {
                  //     var date = await showDatePicker(
                  //         context: context,
                  //         initialDate: DateTime.now(),
                  //         firstDate: DateTime(1900),
                  //         lastDate: DateTime(2100));
                  //     dateController.text = date.toString().substring(0, 10);
                  //   },
                  // ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      hintText: 'Select gender',
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: genders.map((pt) {
                      return DropdownMenuItem(
                        value: pt,
                        child: Text(
                          pt,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        selected_gender = newVal as String?;
                        // print(_mySelection);
                      });
                    },
                    value: selected_gender,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text("Province"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select province',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: provience.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_provience = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_provience,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: school_controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Enter your school',
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'School'),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: college_controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Enter your college',
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'College'),
            ),
            SizedBox(
              height: 12,
            ),
            const Text("Background"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select background',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: background.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_background = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_background,
            ),
            SizedBox(
              height: 12,
            ),
            const Text("Faculty"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select faculty',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: faculty.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_faculty = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_faculty,
            ),
            SizedBox(
              height: 18,
            ),
            TextFormField(
              controller: percentage_controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Enter your percentage/grade',
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Percentage/Grade'),
            ),
            SizedBox(
              height: 12,
            ),
            const Text("Source"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select source',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: source.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_source = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_source,
            ),
            SizedBox(
              height: 12,
            ),
            const Text("Means of communication"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select means of communication',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: means.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_means = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_means,
            ),
            SizedBox(
              height: 12,
            ),
            const Text("Course/class"),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select course/class',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: value.courses.map((pt) {
                return DropdownMenuItem(
                  value: pt.courseName.toString(),
                  child: Text(
                    pt.courseName.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_course = newVal as String?;
                  // print(_mySelection);
                });
              },
              value: selected_course,
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
                        var date = DateTime.parse(dateController.text);
                        try {
                          final data = PostAdvisorRequest(
                              email: email_controller.text,
                              address: address_controller.text,
                              background: selected_background,
                              city: city_controller.text,
                              college: college_controller.text,
                              communication: selected_means,
                              contact: contact_controller.text,
                              course: selected_course,
                              faculty: selected_faculty,
                              firstName: firstname_controller.text,
                              gender: selected_gender,
                              lastName: lastname_controller.text,
                              percentage: percentage_controller.text,
                              province: selected_provience,
                              school: school_controller.text,
                              source: selected_source,
                              dob: dob);

                          final res =
                              await AdvisorRepository().postAdvisor(data);
                          if (res.success == true) {
                            Fluttertoast.showToast(
                                msg: "Student details added");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Failed to add student details");
                          }
                        } on Exception catch (e) {
                          print(e.toString());
                          // TODO
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
            SizedBox(
              height: 100,
            ),
          ],
        ),
      );
    });
  }
}
