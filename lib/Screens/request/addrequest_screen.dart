import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/services/addrequest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../components/shimmer.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../helper/custom_loader.dart';
import '../../response/login_response.dart';
import '../../response/student_leave_response.dart';
import '../prinicpal/stats_common_view_model.dart';
import '../widgets/snack_bar.dart';
import 'package:schoolworkspro_app/response/parents/getparentticketdetail_response.dart';

class Addrequestscreen extends StatefulWidget {
  bool isUpdate;
  Request? data;
  bool? isFromRoutine;
  bool showAppbar;
  Map<String, dynamic>? routineData;
  Addrequestscreen(
      {Key? key,
      this.data,
        required this.showAppbar,
      required this.isUpdate,
      required this.isFromRoutine,
      this.routineData})
      : super(key: key);

  @override
  _AddrequestscreenState createState() => _AddrequestscreenState();
}

class _AddrequestscreenState extends State<Addrequestscreen> {
  List subject = [
    "General Enquiry",
    "Student Update",
    "Meetings",
    "Academic Support"
    "Liaison",
    "Complain",
    "Leave",
    "Logistics",
    "Fees",
    "IT",
    "Others"
  ];
  User? user;
  DateTime? fromDueDate;
  DateTime? selectRoutineDate;
  DateTime? selectRoutineEndDate;
  DateTime? toDueDate;
  bool allDayLeave = false;
  List<dynamic> selected_module = [];
  late StatsCommonViewModel _provider;

  bool isloading = false;

  List<dynamic> filteredRoutine = [];
  List<dynamic> fRoutines = [];

  String? subject_selection;
  String? severity_selection;
  TextEditingController topic_controller = TextEditingController();
  TextEditingController request_controller = TextEditingController();

  int totalDays = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
    });
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
    _provider.fetchAllRoutines(user!.batch.toString());
    if (widget.data != null) {
      try {
        print("SUBJECT::::${widget.data?.subject}");
        subject_selection = widget.data?.subject ?? "General Enquiry";
        severity_selection = widget.data?.severity;
        topic_controller = TextEditingController(text: widget.data?.topic);
        request_controller = TextEditingController(text: widget.data?.request);

        List<dynamic> module = [];

        if (widget.data?.subject != null && widget.data?.subject == "Leave") {
          fromDueDate = DateTime.parse(widget.data!.leaves["startDate"])
              .add(Duration(hours: 5, minutes: 45));
          toDueDate = DateTime.parse(widget.data!.leaves["endDate"])
              .add(Duration(hours: 5, minutes: 45));
          allDayLeave = widget.data!.leaves["allDay"];
          Duration diff = toDueDate!.difference(fromDueDate!);
          module.clear();
          for (var i = 0; i < widget.data!.leaves["routines"].length; i++) {
            module.add(widget.data!.leaves["routines"][i]["id"]);
          }
          selected_module = [...selected_module, ...module];
          fRoutines.clear();
          multiModule(_provider, fromDueDate, toDueDate);
          for (var i = 0; i < filteredRoutine.length; i++) {
            if (selected_module.contains(filteredRoutine[i]["_id"])) {
              print("SELECTED VALUE:::$selected_module");
              fRoutines.add({
                "moduleSlug": filteredRoutine[i]["moduleSlug"],
                "title": filteredRoutine[i]["title"],
                "id": filteredRoutine[i]["_id"],
                "date": filteredRoutine[i]["date"],
                "classType": filteredRoutine[i]["classType"]
              });
            }
          }
        }
      } catch (e) {}
    }

    try {
      print("ROUTINE::::::${widget.isFromRoutine}");
      if (widget.isFromRoutine == true) {
        subject_selection = "Leave";

        if (widget.routineData != null && widget.routineData!["date"] != null) {
          // Get current date
          final today = DateTime.now();

          // Get weekday of routine end date
          // DateTime date =  DateTime.parse(val);
          final routineEnd = DateTime(
              widget.routineData!["date"]!.year,
              widget.routineData!["date"]!.month,
              widget.routineData!["date"]!.day,
              0,
              1,
              0);

          final routineEndWeekday = routineEnd.weekday;

          final diff = (routineEndWeekday - today.weekday + 7) % 7;

          final latestWeekdayDate = today.add(Duration(days: diff)).toLocal();

          selectRoutineDate = DateTime(latestWeekdayDate.year,
              latestWeekdayDate.month, latestWeekdayDate.day, 0, 1, 0);
          selectRoutineEndDate = DateTime(latestWeekdayDate.year,
              latestWeekdayDate.month, latestWeekdayDate.day, 23, 58, 0);
        }
      }
    } catch (e) {}
  }

  multiModule(
      StatsCommonViewModel stats, DateTime? fromDueDate, DateTime? toDueDate) {
    print("hello");
    if (fromDueDate != null && toDueDate != null) {
      List<int> daysList = [];
      List<String> dateList = [];

      DateTime sDate = DateTime(
          fromDueDate.year, fromDueDate.month, fromDueDate.day, 13, 15);
      while (sDate.isBefore(toDueDate)) {
        int sDayNum = sDate.weekday;
        totalDays = daysList.length;
        daysList.add(sDayNum);
        dateList.add(
            '${sDate.year}-${sDate.month.toString().padLeft(2, '0')}-${sDate.day.toString().padLeft(2, '0')}');
        sDate = sDate.add(const Duration(days: 1));
      }
      filteredRoutine.clear();
      for (var element in stats.routines) {
        int slDayNum = DateTime.parse(element['end']).weekday;
        int findIndex = daysList.indexOf(slDayNum);
        if (findIndex != -1) {
          filteredRoutine.add({...element, "date": dateList[findIndex]});
        }
      }
      // for(var i = 0; i < filteredRoutine.length; i++ ){
      //   if(selected_module.contains(filteredRoutine[i]["_id"])){
      //     print("SELECTED VALUE:::$selected_module");
      //     fRoutines.add({"moduleSlug":filteredRoutine[i]["moduleSlug"], "title":filteredRoutine[i]["title"], "id":filteredRoutine[i]["_id"],"date":filteredRoutine[i]["date"], "classType": filteredRoutine[i]["classType"] });
      //   }
      // }
    }
  }

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
        Fluttertoast.showToast(msg: 'No image selected.');
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
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar:
      widget.isUpdate || widget.showAppbar == true
          ? AppBar(
              elevation: 0.0,
              title: Text(
                !widget.isUpdate ? "Add Request" : "Update Request",
                style: const TextStyle(color: white),
              ),
              // iconTheme: const IconThemeData(
              //   color: Colors.black, //change your color here
              // ),
              // backgroundColor: Colors.white
      )
          : null,
      body: SingleChildScrollView(
        child: Consumer<StatsCommonViewModel>(builder: (context, stats, child) {
          return isLoading(stats.allroutineApiResponse)
              ? const VerticalLoader()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Subjects",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: widget.isFromRoutine == true ||
                                widget.isUpdate == true
                            ? true
                            : false,
                        child: Padding(
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
                              hintText: 'Select subject',
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
                      ),
                      widget.isFromRoutine == true
                          ? SizedBox()
                          : Column(
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
                                      if (value == null &&
                                          widget.isFromRoutine == false) {
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
                      widget.isFromRoutine == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IgnorePointer(
                                      ignoring: true,
                                      child: Builder(builder: (context) {
                                        print(
                                            "INITIAL VALUE::::::${selectRoutineDate.toString()}");
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DateTimePicker(
                                            type: DateTimePickerType.date,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                            initialDate: selectRoutineDate,
                                            initialValue:
                                                selectRoutineDate.toString(),
                                            dateLabelText: 'Date',
                                            timePickerEntryModeInput: true,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                DateTime date =
                                                    DateTime.parse(val);
                                                selectRoutineDate = DateTime(
                                                    date.year,
                                                    date.month,
                                                    date.day,
                                                    0,
                                                    1,
                                                    0);
                                                selectRoutineEndDate = DateTime(
                                                    date.year,
                                                    date.month,
                                                    date.day,
                                                    23,
                                                    58,
                                                    0);
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Date can't be empty";
                                              }
                                              return null;
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Modules/Subject",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                widget.routineData!["title"] == null ||
                                        widget.routineData!["title"] == ""
                                    ? SizedBox()
                                    : Builder(builder: (context) {
                                        final finalDate =
                                            "${selectRoutineDate?.year}-${selectRoutineDate?.month}-${selectRoutineDate?.day}";
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "${widget.routineData!["title"].toString()} (${widget.routineData!["classType"]}) @ ${finalDate.toString()}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }),
                                widget.routineData!["title"] == null ||
                                        widget.routineData!["title"] == ""
                                    ? SizedBox()
                                    : Builder(builder: (context) {
                                        final finalDate =
                                            "${selectRoutineDate?.year}-${selectRoutineDate?.month}-${selectRoutineDate?.day}";
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "You are requesting subject wise leave for ${widget.routineData!["title"].toString()} (${widget.routineData!["classType"] != null ? widget.routineData!["classType"] : ""}) on ${finalDate.toString()}.To take all day leave or multiple module/subject leave navigate to new request.",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subject_selection == "Leave"
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "From",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      DateTimePicker(
                                                        type: DateTimePickerType
                                                            .date,
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100),
                                                        initialValue:
                                                            fromDueDate
                                                                .toString(),
                                                        dateLabelText: 'Date',
                                                        timePickerEntryModeInput:
                                                            true,
                                                        decoration:
                                                            const InputDecoration(
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .always,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red)),
                                                        ),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            DateTime date =
                                                                DateTime.parse(
                                                                    val);
                                                            fromDueDate =
                                                                DateTime(
                                                                    date.year,
                                                                    date.month,
                                                                    date.day,
                                                                    0,
                                                                    1,
                                                                    0);
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (subject_selection ==
                                                                  "Leave" &&
                                                              widget.isFromRoutine ==
                                                                  false) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter from date';
                                                            } else if (toDueDate!
                                                                .isBefore(
                                                                    fromDueDate!)) {
                                                              return "From date can't be after To date";
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "To",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      DateTimePicker(
                                                        type: DateTimePickerType
                                                            .date,
                                                        initialValue: toDueDate
                                                            .toString(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100),
                                                        dateLabelText: 'Date',
                                                        timePickerEntryModeInput:
                                                            true,
                                                        decoration:
                                                            const InputDecoration(
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .always,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red)),
                                                        ),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            DateTime date =
                                                                DateTime.parse(
                                                                    val);
                                                            toDueDate =
                                                                DateTime(
                                                                    date.year,
                                                                    date.month,
                                                                    date.day,
                                                                    23,
                                                                    59,
                                                                    0);

                                                            multiModule(
                                                                stats,
                                                                fromDueDate,
                                                                toDueDate);
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (subject_selection ==
                                                                  "Leave" &&
                                                              widget.isFromRoutine ==
                                                                  false) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter to date';
                                                            } else if (toDueDate!
                                                                .isBefore(
                                                                    fromDueDate!)) {
                                                              return "To date can't be before from date";
                                                            } else if (!allDayLeave) {
                                                              if (fromDueDate !=
                                                                      null &&
                                                                  toDueDate !=
                                                                      null) {
                                                                final difference =
                                                                    (fromDueDate!
                                                                            .difference(toDueDate!))
                                                                        .abs();
                                                                if (difference >
                                                                    const Duration(
                                                                        days:
                                                                            7)) {
                                                                  snackThis(
                                                                      context:
                                                                          context,
                                                                      content: Text(
                                                                          "Only All Days Leave can be greater than 7 days. For Subject/Module Leave create different leave request."),
                                                                      color: Colors
                                                                          .red);
                                                                  return "";
                                                                }
                                                              }
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          toDueDate != null &&
                                                  fromDueDate != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Builder(
                                                          builder: (context) {
                                                        return const Text(
                                                          "Total Days: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      }),
                                                      toDueDate!.isAfter(
                                                              fromDueDate!)
                                                          ? Text(totalDays
                                                              .toString())
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "All Day Leave",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                CupertinoSwitch(
                                                  activeColor: CupertinoColors
                                                      .activeGreen,
                                                  trackColor: CupertinoColors
                                                      .inactiveGray,
                                                  thumbColor:
                                                      CupertinoColors.white,
                                                  value: allDayLeave,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      allDayLeave = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          !allDayLeave
                                              ? Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8),
                                                        child: Text(
                                                          "Modules/Subject",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      MultiSelectDialogField<
                                                          dynamic>(
                                                        validator: (value) {
                                                          if (!allDayLeave &&
                                                              widget.isFromRoutine ==
                                                                  false) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please select module';
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                        items: filteredRoutine
                                                            .map((e) =>
                                                                MultiSelectItem(
                                                                    e["_id"],
                                                                    "${e["title"]}(${e["classType"]}), ${DateFormat("E h:mm a").format(DateTime.parse(e['start']).add(Duration(hours: 5, minutes: 45)))}"))
                                                            .toList(),
                                                        listType:
                                                            MultiSelectListType
                                                                .CHIP,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        onConfirm:
                                                            (dynamic values) {
                                                          setState(() {
                                                            selected_module =
                                                                values;
                                                            fRoutines.clear();
                                                            for (var i = 0;
                                                                i <
                                                                    filteredRoutine
                                                                        .length;
                                                                i++) {
                                                              if (selected_module
                                                                  .contains(
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "_id"])) {
                                                                print(
                                                                    "SELECTED VALUE:::$selected_module");
                                                                fRoutines.add({
                                                                  "moduleSlug":
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "moduleSlug"],
                                                                  "title":
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "title"],
                                                                  "id":
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "_id"],
                                                                  "date":
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "date"],
                                                                  "classType":
                                                                      filteredRoutine[
                                                                              i]
                                                                          [
                                                                          "classType"]
                                                                });
                                                              }
                                                            }
                                                            print(
                                                                "Data::::::$fRoutines");
                                                          });
                                                        },
                                                        initialValue:
                                                            selected_module,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
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
                          "Attach File(Optional)",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(context)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(4),
                            padding: EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: Text('Upload image'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      _imageFile == null
                          ? const SizedBox(
                              height: 1,
                            )
                          : Stack(children: <Widget>[
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
                            ]),
                      widget.isFromRoutine == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 95,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  solidRed),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel",
                                          style: TextStyle(
                                              fontSize: 14, color: white)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 95,
                                    child: ElevatedButton(
                                      onPressed: isloading ? (){} : !widget.isUpdate
                                          ? () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (subject_selection ==
                                                    "Leave") {
                                                  // if (!allDayLeave) {
                                                  final difference =
                                                      (fromDueDate!.difference(
                                                              toDueDate!))
                                                          .abs();
                                                  if (difference >
                                                      Duration(days: 7) && !allDayLeave) {
                                                    snackThis(
                                                        context: context,
                                                        content: const Text(
                                                            "Select Module/Subject or Take All Day Leave"),
                                                        color: Colors.red,
                                                        duration: 7);
                                                  }
                                                  else {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    try {
                                                      Map<String, dynamic>
                                                          request = {
                                                        "request":
                                                            request_controller
                                                                .text,
                                                        "severity":
                                                            severity_selection,
                                                        "topic":
                                                            topic_controller
                                                                .text,
                                                        "subject":
                                                            subject_selection,
                                                        "startDate": fromDueDate?.toUtc()
                                                            .toString(),
                                                        "endDate": toDueDate?.toUtc()
                                                            .toString(),
                                                        "allDay": allDayLeave
                                                            .toString(),
                                                        "routines": !allDayLeave
                                                            ? jsonEncode(
                                                                fRoutines)
                                                            : jsonEncode([]),
                                                      };

                                                      print(
                                                          "REQUEST:::${request}");

                                                      setState(() {
                                                        isloading = true;
                                                      });

                                                      StudentLeaveResponse res =
                                                          await Addrequestservice()
                                                              .addLeaveWithImage(
                                                                  request,
                                                                  _imageFile);
                                                      if (res.success == true) {
                                                        setState(() {
                                                          isloading = false;
                                                        });
                                                        Navigator.pop(context);
                                                        snackThis(
                                                            context: context,
                                                            content: Text(res
                                                                .message
                                                                .toString()),
                                                            color: Colors.green,
                                                            duration: 1,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating);
                                                      }
                                                      else {
                                                        setState(() {
                                                          isloading = false;
                                                        });
                                                        snackThis(
                                                            context: context,
                                                            content: Text(res
                                                                .message
                                                                .toString()),
                                                            color: Colors.red,
                                                            duration: 1,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating);
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              e.toString()),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                    }
                                                  }
                                                  // }
                                                }
                                                else {
                                                  print("hello");
                                                  if (_imageFile == null) {
                                                    print(request_controller
                                                        .text);
                                                    print(
                                                        topic_controller.text);
                                                    print(subject_selection);
                                                    print(severity_selection);
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    final result = await Addrequestservice()
                                                        .addmyrequestwithoutimage(
                                                            request_controller
                                                                .text,
                                                            severity_selection!,
                                                            topic_controller
                                                                .text,
                                                            subject_selection!,
                                                            user!.institution
                                                                .toString());
                                                    if (result.success ==
                                                        true) {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.pop(context);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            result.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.pop(context);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            result.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
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
                                                            request_controller
                                                                .text,
                                                            severity_selection!,
                                                            topic_controller
                                                                .text,
                                                            subject_selection!,
                                                            user!.institution
                                                                .toString(),
                                                            _imageFile);
                                                    if (result.success ==
                                                        true) {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.pop(context);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            result.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    }
                                                    else {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.pop(context);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            result.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          : () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (subject_selection !=
                                                    "Leave") {
                                                  updateMyReqeust(widget
                                                      .data!.id
                                                      .toString());
                                                } else {
                                                  updateLeaveRequest(widget
                                                      .data!.id
                                                      .toString());
                                                }
                                              }
                                            },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  logoTheme),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ))),
                                      child: Text(
                                        !widget.isUpdate ? "Post" : "Update",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: ElevatedButton(
                                  onPressed: isloading == true
                                      ? () {}
                                      : () {
                                          routineAddLeaveRequest();
                                        },
                                  child: isloading == true
                                      ? CircularProgressIndicator()
                                      : Text("Request Leave"))),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  updateMyReqeust(String id) async {
    print("hello test");
    final result = await Addrequestservice().updateMyRequestWithImage(
        request_controller.text,
        severity_selection!,
        topic_controller.text,
        subject_selection!,
        user!.institution.toString(),
        _imageFile,
        id);
    if (result.success == true) {
      Navigator.popUntil(context, (route) => route.isFirst);
      final snackBar = SnackBar(
        content: Text(result.message!),
        backgroundColor: (Colors.black),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text(result.message!),
        backgroundColor: (Colors.black),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  updateLeaveRequest(String id) async {
    List<dynamic> finalRoutineList = [];
    for (var i = 0; i < filteredRoutine.length; i++) {
      if (fRoutines.contains(filteredRoutine[i]["id"])) {
        finalRoutineList.add(filteredRoutine);
      }
    }

    Map<String, dynamic> request = {
      "request": request_controller.text,
      "severity": severity_selection,
      "topic": topic_controller.text,
      "subject": subject_selection,
      "startDate":
          fromDueDate?.subtract(Duration(hours: 5, minutes: 45)).toString(),
      "endDate":
          toDueDate?.subtract(Duration(hours: 5, minutes: 45)).toString(),
      "allDay": allDayLeave.toString(),
      "routines": !allDayLeave ? jsonEncode(fRoutines) : jsonEncode([]),
    };

    setState(() {
      isloading = true;
    });

    Commonresponse res =
        await Addrequestservice().updateLeaveRequest(request, _imageFile, id);
    if (res.success == true) {
      setState(() {
        isloading = false;
      });
      Navigator.popUntil(context, (route) => route.isFirst);
      snackThis(
          context: context,
          content: Text(res.message.toString()),
          color: Colors.green,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    } else {
      setState(() {
        isloading = false;
      });
      snackThis(
          context: context,
          content: Text(res.message.toString()),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }

  routineAddLeaveRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        Map<String, dynamic> routineD = {
          "date": selectRoutineDate?.toString(),
          "id": widget.routineData!["id"],
          "moduleSlug": widget.routineData!["moduleSlug"],
          "title": widget.routineData!["title"],
          "classType": widget.routineData!["classType"],
        };

        Map<String, dynamic> request = {
          "request": request_controller.text,
          "severity": "Low",
          "topic": topic_controller.text,
          "subject": subject_selection,
          "startDate": selectRoutineDate?.toUtc().toString(),
          "endDate": selectRoutineEndDate?.toUtc().toString(),
          "allDay": "false",
          "routines": jsonEncode([routineD]),
        };

        print("REQUEST:::${request}");

        setState(() {
          isloading = true;
        });

        StudentLeaveResponse res =
            await Addrequestservice().addLeaveWithImage(request, _imageFile);
        if (res.success == true) {
          setState(() {
            isloading = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
          snackThis(
              context: context,
              content: Text(res.message.toString()),
              color: Colors.green,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        } else {
          setState(() {
            isloading = false;
          });
          snackThis(
              context: context,
              content: Text(res.message.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        }
      } catch (e) {
        setState(() {
          isloading = false;
        });
        snackThis(
            context: context,
            content: Text(e.toString()),
            color: Colors.red,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      }
    }
  }
}
