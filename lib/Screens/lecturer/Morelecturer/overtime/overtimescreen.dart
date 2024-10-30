import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/overtime_request.dart';
import 'package:schoolworkspro_app/response/lecturer/addovertime_response.dart';
import 'package:schoolworkspro_app/services/lecturer/overtime_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../helper/custom_loader.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({Key? key}) : super(key: key);

  @override
  _OvertimeScreenState createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  DateTime? _fromdatecontroller = DateTime.now();
  DateTime? _todatecontroller;
  final TextEditingController _descriptioncontroller = TextEditingController();
  String? _startDate;
  String? _endDate;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    _startDate = "";
    _endDate = "";
    super.initState();
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
          elevation: 0.0,
          centerTitle: false,
          title:  const Text("Request Overtime",
              style: TextStyle(color: white)),
          // backgroundColor: Colors.white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("From Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              const SizedBox(height: 5,),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: _fromdatecontroller.toString(),
                // initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                timePickerEntryModeInput: true,
                onChanged: (val) {
                  setState(() {
                    _fromdatecontroller = DateTime.parse(val);
                    print("THIS IS DATEE:::::${_fromdatecontroller.toString()}");
                  });
                },
                validator: (val) {
                  print(val);
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("To Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5,),
                    DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: null,
                      // initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                      firstDate: _fromdatecontroller ?? DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: const Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      timePickerEntryModeInput: true,
                      onChanged: (val) {
                        setState(() {
                          _todatecontroller = DateTime.parse(val);
                          print("THIS IS DATEE:::::${_todatecontroller.toString()}");
                        });
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptioncontroller,
                  maxLines: 5,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'Reason for overtime',
                    label: Text('Purpose'),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
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
                  isloading == true ? const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ) :
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: SizedBox(
                      height: 40,
                      width: 95,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_fromdatecontroller == null) {
                            Fluttertoast.showToast(msg: 'Select From Date');
                          } else if (_todatecontroller == null) {
                            Fluttertoast.showToast(msg: 'Select To Date');
                          }
                          else if(_todatecontroller!.isBefore(_fromdatecontroller!)){
                            Fluttertoast.showToast(msg: "To date can't be before From date");
                          }
                          else if (_descriptioncontroller.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Description can't be empty");
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            final request = OvertimeRequest(
                              startDate: _fromdatecontroller?.subtract(Duration(hours: 5, minutes: 45)).toString(),
                              endDate: _todatecontroller?.subtract(Duration(hours: 5, minutes: 45)).toString(),
                              purpose: _descriptioncontroller.text,
                            );

                            AddOvertimeResponse res =
                                await OvertimeService().postovertime(request);
                            try {
                              if (res.success == true) {
                                setState(() {
                                  isloading = true;
                                });
                                snackThis(
                                    context: context,
                                    content: Text(res.message.toString()),
                                    color: Colors.green,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);

                                _descriptioncontroller.clear();
                                setState(() {
                                  isloading = false;
                                });
                              }
                              else {
                                setState(() {
                                  isloading = true;
                                });
                                snackThis(
                                    context: context,
                                    content: Text(res.message.toString()),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            }
                            catch (e) {
                              setState(() {
                                isloading = true;
                              });
                              snackThis(
                                  context: context,
                                  content: Text(res.message.toString()),
                                  color: Colors.red,
                                  duration: 1,
                                  behavior: SnackBarBehavior.floating);
                              setState(() {
                                isloading = false;
                              });
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
                          "Request",
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
      ),
    );
  }

  // selectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   setState(() {
  //     _startDate = DateFormat('yyyy-MM-dd').format(args.value).toString();
  //
  //     _fromdatecontroller.text = _startDate.toString();
  //   });
  // }
  //
  // selectionChanged2(DateRangePickerSelectionChangedArgs args) {
  //   setState(() {
  //     _endDate = DateFormat('yyyy-MM-dd').format(args.value).toString();
  //
  //     _todatecontroller.text = _endDate.toString();
  //   });
  // }
}
