import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:intl/intl.dart';
import '../../../api/repositories/user_repository.dart';
import '../../../constants.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../widgets/snack_bar.dart';

class AddLogsScreen extends StatefulWidget {
  final String username;
  const AddLogsScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<AddLogsScreen> createState() => _AddLogsScreenState();
}

class _AddLogsScreenState extends State<AddLogsScreen> {
  final _remarksController = TextEditingController();
  final eventController = TextEditingController();
  DateTime? selectDate;
  String? recordType;
  String? currentStatus;
  String? outDate;
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _remarksController.dispose();
    eventController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(
        builder: (context, commonVM, child) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            title: const Text(
              "Add Logs",
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                const Text(
                  "Event",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                5.sH,
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event cannot be empty';
                    }
                    return null;
                  },
                  controller: eventController,
                  keyboardType: TextInputType.text,
                  decoration: _decoration(),
                ),
                10.sH,
                const Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                5.sH,
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_today,
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(),
                      filled: true,
                      hintText: "dd/mm/yy"),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  timePickerEntryModeInput: true,
                  onChanged: (val) {
                    setState(() {
                      selectDate = DateTime.parse(val);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date cannot be empty';
                    }
                    return null;
                  },
                ),
                10.sH,
                const Text(
                  "Record Type",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                5.sH,
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select record type';
                    }
                    return null;
                  },
                  value: recordType,
                  isExpanded: true,
                  decoration: _decoration(),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  items: ["Call Log", "Gate Pass"].map((pt) {
                    return DropdownMenuItem(
                      value: pt,
                      child: Text(
                        pt.toString(),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      recordType = newVal as String;
                    });
                  },
                ),
                recordType == "Gate Pass"
                    ? Column(
                        children: [
                          10.sH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Current Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    5.sH,
                                    DropdownButtonFormField(
                                      validator: (value) {
                                        if (recordType == "Gate Pass") {
                                          if (value == null) {
                                            return 'Please select type';
                                          }
                                          return null;
                                        }
                                        return null;
                                      },
                                      value: currentStatus,
                                      isExpanded: true,
                                      decoration: _decoration(),
                                      icon: const Icon(
                                          Icons.arrow_drop_down_outlined),
                                      items:
                                          ["Out", "In"].map((pt) {
                                        return DropdownMenuItem(
                                          value: pt,
                                          child: Text(
                                            pt.toString(),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          currentStatus = newVal as String;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              8.sW, // Add space between the widgets
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      currentStatus == "In" ? "In Date" : "Out Date",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    5.sH,
                                    DateTimePicker(
                                      type: DateTimePickerType.time,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.timer, color: Colors.grey,),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: kPrimaryColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintText: "--:-- --",
                                      ),
                                      timeLabelText: "Hour",
                                      timePickerEntryModeInput: true,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val.isNotEmpty) {
                                            outDate = val;
                                          }
                                        });
                                      },
                                      onSaved: (val){
                                        if (val != null && val.isNotEmpty) {
                                          outDate = val;
                                        }
                                      },
                                      validator: (value) {
                                        if (recordType == "Gate Pass") {
                                          if (value == null || value.isEmpty) {
                                            return 'Time cannot be empty';
                                          }
                                          return null;
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                10.sH,
                const Text(
                  "Remarks",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                5.sH,
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Remarks cant be empty';
                    }
                    return null;
                  },
                  decoration: _decoration(),
                ),
                10.sH,
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: logoTheme,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          customLoadStart();
                          String _date = DateFormat('yyyy-MM-dd')
                              .format(selectDate ?? DateTime.now())
                              .toString();

                          String requestData = jsonEncode({
                            "username": widget.username,
                            "event": eventController.text,
                            "remarks": _remarksController.text,
                            "recordType": recordType,
                            "date": _date,
                            if(recordType == "Gate Pass") "recordStatus":currentStatus,
                            if(recordType == "Gate Pass") "statusHistory": [
                                {
                                  "value": currentStatus,
                                  "statusTime": outDate
                                }
                              ]
                          });

                          print(requestData);

                          final res = await UserRepository()
                              .addStudentLogs(requestData);

                          if (res.success == true) {
                            commonVM.fetchStudentLogs(widget.username);
                            Navigator.of(context).pop();
                            successSnackThis(
                                context: context,
                                content: Text(res.message.toString()));
                          }
                          else {
                            errorSnackThis(
                                context: context,
                                content: Text(res.message.toString()));
                          }
                        } on Exception catch (e) {
                          errorSnackThis(
                              context: context, content: Text(e.toString()));
                        } finally {
                          customLoadStop();
                        }
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(fontSize: 17),
                    )),
                100.sH,
              ],
            ),
          ));
    });
  }

  InputDecoration _decoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      filled: true,
    );
  }
}
