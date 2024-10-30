import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/components/menu_bar.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/request/lecturer/leave_request.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_response.dart';
import 'package:schoolworkspro_app/response/lecturer/postleave_response.dart';
import 'package:schoolworkspro_app/services/lecturer/leave_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../helper/custom_loader.dart';
import '../book_leave_view_model.dart';

class PanelWidget extends StatefulWidget {
  List<Leave>? data;
  final ScrollController controller;
  final PanelController panelController;
  final String username;

  PanelWidget(
      {Key? key,
      required this.controller,
      required this.panelController,
      this.data, required this.username})
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Consumer<BookLeaveViewModel>(builder: (context, datas2, child) {
      return ListView(
        controller: widget.controller,
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          buildDragHandle(),
          const SizedBox(
            height: 6,
          ),
          const Center(
            child: Text(
              'Edit/Delete',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data?.length,
            itemBuilder: (context, index) {
              var formattedTime;
              var formattedTime2;

              if(widget.data != null){

                DateTime now =
                DateTime.parse(widget.data?[index].startDate.toString() ?? "");

                now = now.add(const Duration(hours: 5, minutes: 45));

                formattedTime = DateFormat('yMMMMd').format(now);

                DateTime now2 =
                DateTime.parse(widget.data![index].endDate.toString());

                now2 = now2.add(const Duration(hours: 5, minutes: 45));

                formattedTime2 = DateFormat('yMMMMd').format(now2);

              }else{
                  formattedTime = DateFormat('yMMMMd').format(DateTime.now());
                 formattedTime2 = DateFormat('yMMMMd').format(DateTime.now());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Text(
                              "leave type: ${widget.data?[index].leaveType}"),
                        ),
                        widget.data?[index].status.toString() == "Pending"
                            ? Expanded(
                                flex: 1,
                                child: PopupMenuButton<String>(
                                  onSelected: (choice) async {
                                    if (choice == menubar12.edit) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EditLeaveAlertBox(
                                            data: widget.data,
                                            index: index,
                                            datas2: datas2,
                                            username: widget.username,
                                          );
                                        },
                                      );
                                    } else if (choice == menubar12.delete) {
                                      try {
                                        final res = await LeaveService()
                                            .deleteleave(widget.data![index].id
                                                .toString());
                                        if (res.success == true) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          datas2.fetchLecturerAllLeave(widget.username);
                                          snackThis(
                                              context: context,
                                              content:
                                                  Text(res.message.toString()),
                                              color: Colors.green,
                                              duration: 1,
                                              behavior:
                                                  SnackBarBehavior.floating);
                                          setState(() {
                                            isloading = false;
                                          });
                                        } else {
                                          setState(() {
                                            isloading = true;
                                          });
                                          snackThis(
                                              context: context,
                                              content:
                                                  Text(res.message.toString()),
                                              color: Colors.red,
                                              duration: 1,
                                              behavior:
                                                  SnackBarBehavior.floating);
                                          setState(() {
                                            isloading = false;
                                          });
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
                                            behavior:
                                                SnackBarBehavior.floating);
                                        setState(() {
                                          isloading = false;
                                        });
                                      }
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return menubar12.settings
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Text("Start date: $formattedTime"),
                    Text("End date: $formattedTime2"),
                    Text("Status: ${widget.data![index].status}"),
                    Text("leave title: ${widget.data![index].leaveTitle}"),
                    Text("leave content: ${widget.data![index].content}"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    });
  }

  Widget buildDragHandle() => GestureDetector(
        onTap: tooglePanel,
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  Widget buildAboutText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: Text(
              "Edit/Delete",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            )),
            for (int i = 0; i < 100; i++) Text("This is text"),
          ],
        ),
      );

  void tooglePanel() => widget.panelController.isPanelOpen
      ? widget.panelController.close()
      : widget.panelController.open();
}

class EditLeaveAlertBox extends StatefulWidget {
  List<Leave>? data;
  int index;
  BookLeaveViewModel datas2;
  String? username;
  EditLeaveAlertBox(
      {Key? key, required this.data, required this.index, required this.datas2, required this.username})
      : super(key: key);

  @override
  State<EditLeaveAlertBox> createState() => _EditLeaveAlertBoxState();
}

class _EditLeaveAlertBoxState extends State<EditLeaveAlertBox> {
  bool isloading = false;
  bool isHalfDayCheck = false;
  String? leaveDuration;
  String? _mySelection;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDatecontroller = TextEditingController();
  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate = DateFormat('yyyy-MM-dd')
          .format(
              args.value.endDate ?? args.value.startDate.add(Duration(days: 1)))
          .toString();

      if (DateTime.parse(_endDate.toString())
              .difference(DateTime.parse(_startDate.toString()))
              .inDays ==
          0) {
        setState(() {
          isHalfDayCheck = false;
        });
      } else {
        setState(() {
          isHalfDayCheck = true;
        });
      }

      _startDatecontroller.text =
          _startDate.toString() + " " + _endDate.toString();
    });
  }

  List<String> durationList = ["Half Day", "All Day"];

  @override
  void initState() {
    _mySelection = widget.data?[widget.index].leaveType.toString();

    _descriptionController.text = widget.data?[widget.index].content.toString() ?? "";

    _startDate = DateFormat('yyyy-MM-dd')
        .format(widget.data![widget.index].startDate!
            .add(const Duration(hours: 5, minutes: 45)))
        .toString();
    _endDate = DateFormat('yyyy-MM-dd')
        .format(widget.data![widget.index].endDate!)
        .toString();

    _startDatecontroller.text =
        _startDate.toString() + " " + _endDate.toString();

    isHalfDayCheck = DateTime.parse(_endDate!)
            .difference(DateTime.parse(_startDate.toString()))
            .inDays !=
        0;

    if (widget.data![widget.index].allDay != null) {
      leaveDuration =
          widget.data![widget.index].allDay == true ? "All Day" : "Half Day";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      // title:
      child: SizedBox(
        height: isHalfDayCheck == true ? 410 : 480,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Request A Leave", style: TextStyle(fontSize: 18),),
              10.sH,
              const Text("Leave Type", style: TextStyle(fontSize: 15)),
              5.sH,
              DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintText: 'Select leave type',
                ),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                items: widget.datas2.leave.map((pt) {
                  return DropdownMenuItem(
                    value: pt.leaveType,
                    child: Text(
                      pt.leaveType.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _mySelection = newVal as String?;
                  });
                },
                value: _mySelection,
              ),
              10.sH,
              const Text("Leave Description", style: TextStyle(fontSize: 15)),
              5.sH,
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter leave description';
                  }
                  return null;
                },
                controller: _descriptionController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                ),
              ),
              10.sH,
              const Text('Select Date', style: TextStyle(fontSize: 15)),
              5.sH,
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          insetAnimationCurve: Curves.bounceIn,
                          insetAnimationDuration:
                          const Duration(milliseconds: 50),
                          title: const Text('Drag to select'),
                          content: SizedBox(
                            height: 250,
                            child: SfDateRangePicker(
                              enablePastDates: true,
                              controller: _controller,
                              selectionMode: DateRangePickerSelectionMode.range,
                              onSelectionChanged: selectionChanged,
                              allowViewNavigation: false,
                            ),
                          ),
                          actions: <Widget>[
                            ButtonBar(
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK')),
                                  ],
                                ),
                              ],
                            )
                          ],
                        );
                      });
                },
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  controller: _startDatecontroller,
                  enabled: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: 'dd / mm /yyyy',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
              ),
              10.sH,
              isHalfDayCheck == true
                  ? const SizedBox()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Leave Duration", style: TextStyle(fontSize: 15)),
                  5.sH,
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Leave Duration',
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: durationList.map((pt) {
                      return DropdownMenuItem(
                        value: pt,
                        child: Text(
                          pt.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        leaveDuration = newVal as String;
                      });
                    },
                    value: leaveDuration,
                  ),
                ],
              ),
              10.sH,
              isloading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
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
                            style: TextStyle(
                                fontSize: 14, color: Colors.black)),
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
                            if (_mySelection == null) {
                              Fluttertoast.showToast(
                                  msg: 'Select leave Type');
                            } else if (_descriptionController
                                .text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Description can't be empty");
                            } else if (_startDate!.isEmpty &&
                                _endDate!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'select date for your leave');
                            } else if (isHalfDayCheck == false &&
                                leaveDuration == null) {
                              Fluttertoast.showToast(
                                  msg: "Please select Leave Duration");
                            } else {
                              setState(() {
                                isloading = true;
                              });

                              DateTime end = DateTime.parse(_endDate!)
                                  .add(Duration(hours: 23, minutes: 59))
                                  .toUtc();

                              var finalLeaveDuration = end
                                  .difference(DateTime.parse(
                                  _startDate.toString()))
                                  .inDays ==
                                  0;

                              final data = LeaveRequest(
                                  allDay: finalLeaveDuration == true
                                      ? leaveDuration == "All Day"
                                      ? true
                                      : false
                                      : true,
                                  content: _descriptionController.text,
                                  endDate: end.toString(),
                                  leaveTitle: "",
                                  leaveType: _mySelection,
                                  startDate:
                                  DateTime.parse(_startDate.toString())
                                      .toUtc()
                                      .toString());

                              PostLeaveResponse res = await LeaveService()
                                  .editleave(
                                  data,
                                  widget.data![widget.index].id
                                      .toString());
                              if (res.success == true) {
                                _descriptionController.clear();
                                _startDate = "";
                                _endDate = "";

                                widget.datas2.fetchLecturerAllLeave(widget.username ?? "");

                                snackThis(
                                    context: context,
                                    content:
                                    Text("Leave Edited successfully"),
                                    color: Colors.green,
                                    duration: 4,
                                    behavior: SnackBarBehavior.floating);
                                Navigator.of(context).pop();
                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                snackThis(
                                    context: context,
                                    content: Text(res.message.toString()),
                                    color: Colors.red,
                                    duration: 4,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            }
                          } catch (e) {
                            snackThis(
                                context: context,
                                content: Text(e.toString()),
                                color: Colors.red,
                                duration: 4,
                                behavior: SnackBarBehavior.floating);
                            setState(() {
                              isloading = false;
                            });
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
                          "Save",
                          style:
                          TextStyle(fontSize: 14, color: Colors.white),
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
}
