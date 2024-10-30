import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/components/menu_bar.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/components/menubar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/request/lecturer/leave_request.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_response.dart';
import 'package:schoolworkspro_app/response/lecturer/postleave_response.dart';
import 'package:schoolworkspro_app/services/lecturer/leave_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../helper/custom_loader.dart';

class PanelWidgetAdmin extends StatefulWidget {
  List<Leave>? data;
  final ScrollController controller;
  final PanelController panelController;

  PanelWidgetAdmin(
      {Key? key,
      required this.controller,
      required this.panelController,
      this.data})
      : super(key: key);

  @override
  State<PanelWidgetAdmin> createState() => _PanelWidgetAdminState();
}

class _PanelWidgetAdminState extends State<PanelWidgetAdmin> {
  bool isloading = false;
  List inst = [
    'Personal',
    'Annual Leave (min: 3 days: 10 days)',
    'Maternal Leave (Female: 3.5 months, Male: 7 days)',
    'Bereavement Leave (15 days)',
    'Sick Leave',
    'Half Day Leave',
    'Others',
  ];

  String? _mySelection;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDatecontroller = TextEditingController();
  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();
  // final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    // setData();
    super.initState();
  }

  // setData() async {
  //   for (int i = 0; i < widget.data!.length; i++) {
  //     _descriptionController.text = widget.data![i].content.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.zero,
      children: <Widget>[
        10.sH,
        buildDragHandle(),
        6.sH,
        const Center(
          child: Text(
            'Edit/Delete',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ),
        24.sH,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.data?.length,
          itemBuilder: (context, index) {
            DateTime now =
                DateTime.parse(widget.data![index].startDate.toString());

            now = now.add(const Duration(hours: 5, minutes: 45));

            var formattedTime = DateFormat('yMMMMd').format(now);

            DateTime now2 =
                DateTime.parse(widget.data![index].endDate.toString());

            now2 = now2.add(const Duration(hours: 5, minutes: 45));

            var formattedTime2 = DateFormat('yMMMMd').format(now2);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text("leave type: " +
                            widget.data![index].leaveType.toString()),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<String>(
                          onSelected: (choice) async {
                            if (choice == menubar12.edit) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    _descriptionController.text =
                                        widget.data![index].content.toString();

                                    _startDate = DateFormat('yyyy-MM-dd')
                                        .format(widget.data![index].startDate!)
                                        .toString();
                                    _endDate = DateFormat('yyyy-MM-dd')
                                        .format(widget.data![index].endDate ??
                                            widget.data![index].endDate!
                                                .add(Duration(days: 1)))
                                        .toString();

                                    _startDatecontroller.text =
                                        _startDate.toString() +
                                            " " +
                                            _endDate.toString();

                                    return AlertDialog(
                                      title: const Text("Request A Leave"),
                                      content: SizedBox(
                                        height: 320,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Leave Type"),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: 'Select leave type',
                                              ),
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              items: inst.map((pt) {
                                                return DropdownMenuItem(
                                                  value: pt,
                                                  child: Text(
                                                    pt,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _mySelection =
                                                      newVal as String?;
                                                });
                                              },
                                              value: _mySelection,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text("Leave Description"),
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter leave description';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  _descriptionController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter description',
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                kPrimaryColor)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.green)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text('Select Date'),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        insetAnimationCurve:
                                                            Curves.bounceIn,
                                                        insetAnimationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                        title: const Text(
                                                            'Drag to select'),
                                                        content: SizedBox(
                                                          height: 250,
                                                          child:
                                                              SfDateRangePicker(
                                                            enablePastDates:
                                                                true,
                                                            controller:
                                                                _controller,
                                                            selectionMode:
                                                                DateRangePickerSelectionMode
                                                                    .range,
                                                            onSelectionChanged:
                                                                selectionChanged,
                                                            allowViewNavigation:
                                                                false,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          ButtonBar(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'OK')),
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select date';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    _startDatecontroller,
                                                enabled: false,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'dd / mm /yyyy',
                                                  filled: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  kPrimaryColor)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .green)),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    width: 95,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          ))),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 15.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    width: 95,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        try {
                                                          if (_mySelection ==
                                                              null) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Select leave Type');
                                                          } else if (_descriptionController
                                                              .text.isEmpty) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Description can't be empty");
                                                          } else if (_startDate!
                                                                  .isEmpty &&
                                                              _endDate!
                                                                  .isEmpty) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'select date for your leave');
                                                          } else {
                                                            setState(() {
                                                              isloading = true;
                                                            });
                                                            final data = LeaveRequest(
                                                                content:
                                                                    _descriptionController
                                                                        .text,
                                                                endDate:
                                                                    _endDate,
                                                                leaveTitle: "",
                                                                leaveType:
                                                                    _mySelection,
                                                                startDate:
                                                                    _startDate);

                                                            PostLeaveResponse
                                                                res =
                                                                await LeaveService()
                                                                    .editleave(
                                                                        data,
                                                                        widget
                                                                            .data![index]
                                                                            .id
                                                                            .toString());
                                                            if (res.success ==
                                                                true) {
                                                              setState(() {
                                                                isloading =
                                                                    true;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _descriptionController
                                                                  .clear();
                                                              _startDate = "";
                                                              _endDate = "";

                                                              snackThis(
                                                                  context:
                                                                      context,
                                                                  content: Text(
                                                                      "Leave Edited successfully"),
                                                                  color: Colors
                                                                      .green,
                                                                  duration: 1,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating);
                                                              setState(() {
                                                                isloading =
                                                                    false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                isloading =
                                                                    true;
                                                              });
                                                              snackThis(
                                                                  context:
                                                                      context,
                                                                  content: Text(
                                                                      "Leave Edited failed"),
                                                                  color: Colors
                                                                      .red,
                                                                  duration: 1,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating);
                                                              setState(() {
                                                                isloading =
                                                                    false;
                                                              });
                                                            }
                                                          }
                                                        } catch (e) {
                                                          setState(() {
                                                            isloading = true;
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
                                                          setState(() {
                                                            isloading = false;
                                                          });
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          ))),
                                                      child: const Text(
                                                        "Save",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            } else if (choice == menubar12.delete) {
                              try {
                                final res = await LeaveService().deleteleave(
                                    widget.data![index].id.toString());
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
                                  setState(() {
                                    isloading = false;
                                  });
                                } else {
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
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return menubar12.settings.map((String choice) {
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
                      ),
                    ],
                  ),
                  Text("Start date: " + formattedTime.toString()),
                  Text("End date: " + formattedTime2.toString()),
                  Text("Status: " + widget.data![index].status.toString()),
                  Text("leave title: " +
                      widget.data![index].leaveTitle.toString()),
                  Text("leave content: " +
                      widget.data![index].content.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
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

  selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate = DateFormat('yyyy-MM-dd')
          .format(
              args.value.endDate ?? args.value.startDate.add(Duration(days: 1)))
          .toString();

      _startDatecontroller.text =
          _startDate.toString() + " " + _endDate.toString();
    });
  }

  Widget buildAboutText() => Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
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
