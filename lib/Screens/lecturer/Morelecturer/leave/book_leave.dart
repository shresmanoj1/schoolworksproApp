import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/book_leave_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/components/panel_widget.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/request/lecturer/leave_request.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_response.dart'
    hide User;
import 'package:schoolworkspro_app/response/lecturer/postleave_response.dart';
import 'package:schoolworkspro_app/services/lecturer/leave_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../api/repositories/lecturer/attendance_repository.dart';
import '../../../../components/shimmer.dart';
import '../../../../config/api_response_config.dart';
import '../../../../constants/colors.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../response/lecturer/attendance_leave_type_response.dart';
import '../../../../response/login_response.dart';
import '../../lecturer_common_view_model.dart';

class BookLeave extends StatefulWidget {
  const BookLeave({Key? key}) : super(key: key);

  @override
  BookLeaveState createState() => BookLeaveState();
}

class BookLeaveState extends State<BookLeave> {
  Future<LeaveResponse>? leave_response;
  bool connected = true;
  User? user;
  String? leaveDuration;

  List<String> durationList = ["Half Day", "All Day"];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDatecontroller = TextEditingController();
  String? _startDate;
  String? _endDate;
  bool isloading = false;
  final PanelController panelController = PanelController();

  late BookLeaveViewModel _provider;

  bool isHalfDayCheck = false;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<BookLeaveViewModel>(context, listen: false);
      _provider.fetchBookLeave();
    });

    getData();
    _startDate = "";
    _endDate = "";
    checkInternet();
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
    // leave_response = LeaveService().getRefreshLeave(
    //     const Duration(milliseconds: 200), user!.username.toString());

    leave_response = LeaveService().getleave(user?.username ?? "");
    _provider.fetchLecturerAllLeave(user?.username ?? "");
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.13;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    // TODO: implement build
    return Consumer<BookLeaveViewModel>(builder: (context, leave, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        print(
                            "LEAVE::${leave.leave.map((e) => print(e.toJson()))}");
                        return StatefulBuilder(builder: (context, setState) {
                          return MyCustomAlertDialog(
                            // leave: leave,
                            username: user?.username ?? "",
                          );
                        });
                      },
                    );
                  },
                  child: Container(
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
              )
            ],
            elevation: 0.0,
            centerTitle: false,
            title: const Text("Book a leave", style: TextStyle(color: white)),
          ),
          body: connected == false
              ? const NoInternetWidget()
              : isLoading(leave.allLeaveTypeResponse)
                  ? const Center(child: CupertinoActivityIndicator())
                  : Builder(builder: (context) {
                      var showData = leave.allLeaveData.leave;

                      int dataNum = showData?.length ?? 0;

                      List<Event> collection = [];

                      for (int i = 0; i < dataNum; i++) {
                        DateTime start = DateTime.parse(
                            showData?[i].startDate.toString() ?? "");

                        start =
                            start.add(const Duration(hours: 5, minutes: 45));

                        var formattedTime =
                            DateFormat('MM/DD/YY').format(start);
                        collection.add(Event(
                            eventName: showData?[i].leaveType,
                            isAllDay: showData?[i].allDay ?? false,
                            from: DateTime.parse(
                                    showData?[i].startDate.toString() ?? "")
                                .add(const Duration(hours: 5, minutes: 45)),
                            to: DateTime.parse(
                                    showData?[i].endDate.toString() ?? "")
                                .add(const Duration(hours: 5, minutes: 45)),
                            background: Colors.green));
                      }
                      return SlidingUpPanel(
                        controller: panelController,
                        minHeight: panelHeightClosed,
                        maxHeight: panelHeightOpen,
                        parallaxEnabled: true,
                        parallaxOffset: .5,
                        body: SizedBox(
                          child: SfCalendar(
                            view: CalendarView.month,
                            showNavigationArrow: true,
                            todayHighlightColor: kPrimaryColor,
                            selectionDecoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              shape: BoxShape.rectangle,
                            ),
                            timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 9,
                                nonWorkingDays: <int>[DateTime.saturday],
                                endHour: 16),
                            dataSource: MeetingDataSource(collection),
                            monthViewSettings: const MonthViewSettings(
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.appointment),
                            initialSelectedDate: DateTime.now(),
                          ),
                        ),
                        panelBuilder: (controller) => PanelWidget(
                            data: leave.allLeaveData.leave?.reversed.toList(),
                            controller: controller,
                            panelController: panelController,
                            username: user?.username ?? ""),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      );
                    }));
    });
  }

  selectionChanged(DateRangePickerSelectionChangedArgs args) {
    print("TRIGGERED::");
    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate = DateFormat('yyyy-MM-dd')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();

      if (DateTime.parse(_endDate.toString())
              .difference(DateTime.parse(_startDate.toString()))
              .inDays ==
          1) {
        setState(() {
          isHalfDayCheck = true;
          print("HALF DAY CHECK:::$isHalfDayCheck");
        });
      }

      _startDatecontroller.text =
          _startDate.toString() + " " + _endDate.toString();
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Event {
  Event(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}

class MyCustomAlertDialog extends StatefulWidget {
  // final BookLeaveViewModel leave;
  final String username;

  const MyCustomAlertDialog(
      {Key? key,
        // required this.leave,
        required this.username})
      : super(key: key);

  @override
  _MyCustomAlertDialogState createState() => _MyCustomAlertDialogState();
}

class _MyCustomAlertDialogState extends State<MyCustomAlertDialog> {
  String leaveDuration = "All Day";
  List<String> durationList = ['All Day', 'Half Day'];
  String? _mySelection;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDatecontroller = TextEditingController();
  String? _startDate;
  String? _endDate;

  bool isloading = false;
  final PanelController panelController = PanelController();

  bool isHalfDayCheck = false;

  selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate = DateFormat('yyyy-MM-dd')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();

      if (DateTime.parse(_endDate.toString())
              .difference(DateTime.parse(_startDate.toString()))
              .inDays ==
          0) {
        setState(() {
          isHalfDayCheck = true;
        });
      } else {
        setState(() {
          isHalfDayCheck = false;
        });
      }

      _startDatecontroller.text =
          _startDate.toString() + " " + _endDate.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookLeaveViewModel>(
      builder: (context, bookALeave, child) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Request A Leave",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: isHalfDayCheck == false ? 400 : 460,
                    width: double.infinity,
                    child: isLoading(bookALeave.leaveTypeResponse)
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : isError(bookALeave.leaveTypeResponse)
                            ? const Center(
                                child: Text("Something Happened. Please try again."))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Leave Type"),
                                    5.sH,
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        hintText: 'Select leave type',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      icon:
                                          const Icon(Icons.arrow_drop_down_outlined),
                                      items: bookALeave.leave.map((pt) {
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
                                          // print(_mySelection);
                                        });
                                      },
                                      value: _mySelection,
                                    ),
                                    10.sH,
                                    const Text("Leave Description"),
                                    5.sH,
                                    TextFormField(
                                      maxLines: 3,
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
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text('Select Date'),
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
                                                    selectionMode:
                                                        DateRangePickerSelectionMode
                                                            .range,
                                                    onSelectionChanged:
                                                        selectionChanged,
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
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  const Text('OK')),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: TextFormField(
                                        controller: _startDatecontroller,
                                        enabled: false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter date';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.visiblePassword,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(horizontal: 10),
                                          hintText: 'dd / mm /yyyy',
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.grey)),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                    isHalfDayCheck == false
                                        ? const SizedBox()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Leave Duration"),
                                              DropdownButtonFormField(
                                                isExpanded: true,
                                                decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  hintText: 'Leave Duration',
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior.always,
                                                ),
                                                icon: const Icon(
                                                    Icons.arrow_drop_down_outlined),
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
                                                    // print(_mySelection);
                                                  });
                                                },
                                                value: leaveDuration,
                                              ),
                                            ],
                                          ),
                                    10.sH,
                                    isloading == true
                                        ? const Center(
                                            child: CupertinoActivityIndicator())
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                                Colors.white),
                                                        shape: MaterialStateProperty
                                                            .all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  18.0),
                                                        ))),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black)),
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
                                                    onPressed: isloading == true
                                                        ? () {}
                                                        : () async {
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
                                                                  _endDate!.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        'select date for your leave');
                                                              } else if (isHalfDayCheck ==
                                                                      true &&
                                                                  leaveDuration ==
                                                                      null) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Please select Leave Duration");
                                                              } else {
                                                                setState(() {
                                                                  isloading = true;
                                                                });
                                                                DateTime end = DateTime
                                                                        .parse(
                                                                            _endDate!)
                                                                    .add(
                                                                        const Duration(
                                                                            hours: 23,
                                                                            minutes:
                                                                                59))
                                                                    .toUtc();

                                                                final data = LeaveRequest(
                                                                    allDay: leaveDuration ==
                                                                            "All Day"
                                                                        ? true
                                                                        : false,
                                                                    content:
                                                                        _descriptionController
                                                                            .text,
                                                                    endDate: end
                                                                        .toString(),
                                                                    leaveTitle: "",
                                                                    leaveType:
                                                                        _mySelection,
                                                                    startDate: DateTime.parse(
                                                                            _startDate
                                                                                .toString())
                                                                        .toUtc()
                                                                        .toString());

                                                                print(
                                                                    "DATA REQUEST:::${data.toJson()}");

                                                                PostLeaveResponse
                                                                    res =
                                                                    await LeaveService()
                                                                        .postLeave(
                                                                            data);
                                                                if (res.success ==
                                                                    true) {
                                                                  setState(() {
                                                                    isloading = true;
                                                                  });

                                                                  _descriptionController
                                                                      .clear();
                                                                  _startDate = "";
                                                                  _endDate = "";

                                                                  bookALeave.fetchLecturerAllLeave(widget.username);

                                                                  Navigator.pop(
                                                                      context);
                                                                  snackThis(
                                                                      context:
                                                                          context,
                                                                      content: Text(res
                                                                          .message
                                                                          .toString()),
                                                                      color: Colors
                                                                          .green,
                                                                      duration: 4,
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating);
                                                                  setState(() {
                                                                    isloading = false;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    isloading = true;
                                                                  });
                                                                  snackThis(
                                                                      context:
                                                                          context,
                                                                      content: Text(res
                                                                          .message
                                                                          .toString()),
                                                                      color:
                                                                          Colors.red,
                                                                      duration: 4,
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating);
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    isloading = false;
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
                                                                  duration: 4,
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
                                                            MaterialStateProperty.all(
                                                                Colors.green),
                                                        shape: MaterialStateProperty
                                                            .all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  18.0),
                                                        ))),
                                                    child: const Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
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
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
