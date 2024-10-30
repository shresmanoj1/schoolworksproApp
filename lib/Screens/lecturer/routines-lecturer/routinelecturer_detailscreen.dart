import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/new_attendance.dart';
import 'package:schoolworkspro_app/Screens/lecturer/routines-lecturer/routine_attendance_update.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/services/lecturer/addnoticelecturer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/api_response_config.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/authenticateduser_response.dart';
import '../../../services/lecturer/routinelecturer_service.dart';
import '../my-modules/attendance/qr_attendance_screen.dart';
import '../my-modules/components/overview.dart';

class Routinelecturerdetailscreen extends StatefulWidget {
  final data;
  const Routinelecturerdetailscreen({Key? key, this.data}) : super(key: key);

  @override
  _RoutinelecturerdetailscreenState createState() =>
      _RoutinelecturerdetailscreenState();
}

class _RoutinelecturerdetailscreenState
    extends State<Routinelecturerdetailscreen> {
  final title_controller = TextEditingController();
  final content_controller = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  late CommonViewModel _commonViewModel;
  bool reminder = false;
  DateTime? duedate;
  late AttendanceViewModel _provider;
  User? user;

  bool readMore = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _provider = Provider.of<AttendanceViewModel>(context, listen: false);
      _provider.checkAttendance(widget.data['moduleSlug'], widget.data['batch'],
          widget.data['classType']);
      _provider.fetchClassType(widget.data['moduleSlug'], widget.data['batch']);
      _commonViewModel.fetchotatrue();
      // getData();
    });
    getuserData();
    super.initState();
  }

  getuserData() async {
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
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text("Routine Reminder"),
                      content: SizedBox(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xfff5c6cb),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    readMore = !readMore;
                                  });
                                },
                                child: Text(
                                  "**  Note: Choose how many minutes before your routine you want to be reminded. For example, if your routine is at 9:00 AM and you select '2 minutes,' you'll get a reminder at 8:58 AM. ** ",
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                  maxLines: readMore ? 2 : 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text('Reminder'),
                            Transform.scale(
                              scale: 1.5,
                              child: Switch(
                                  value: reminder,
                                  onChanged: (value) {
                                    setState(() {
                                      reminder = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Select Time'),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DateTimePicker(
                                controller: dateController,
                                initialTime: TimeOfDay.now(),
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 10.0, left: 10.0, right: 10.0),
                                  // labelText: 'widget.title',
                                ),
                                type: DateTimePickerType.time,
                                timeLabelText: "Hour",
                                timePickerEntryModeInput: true,
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                              ),
                            ),
                            Row(
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
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
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
                                      onPressed: () async {
                                        try {
                                          setState(() {
                                            isloading = true;
                                          });
                                          String data = jsonEncode({
                                            "routineReminder": reminder,
                                            "reminderTime": dateController.text,
                                          });

                                          final res =
                                              await RoutineLecturerService()
                                                  .routineReminder(
                                                      data, widget.data["_id"]);
                                          if (res.success == true) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                            setState(() {
                                              isloading = false;
                                            });
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          } else {
                                            setState(() {
                                              isloading = true;
                                            });
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                            setState(() {
                                              isloading = false;
                                            });
                                          }
                                        } on Exception catch (e) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                          setState(() {
                                            isloading = false;
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
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
            },
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Consumer3<CommonViewModel, AttendanceViewModel,
              LecturerCommonViewModel>(
          builder: (context, common, snapshot, state, child) {
        return ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.data['title'].toString(),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OverViewScreen(
                                              modulSlug:
                                                  widget.data['moduleSlug'],
                                              tabIndex: state.tabIndex,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  // height: 25,
                                  // width: 25,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Color(0xffCF407F)),
                                  child: Image.asset(
                                    'assets/icons/gpsnavigation.png',
                                    width: 20,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.data["isCancelled"] == null ||
                          widget.data["cancelledDate"] == null
                      ? Container()
                      : widget.data["isCancelled"] == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Class Cancelled for: ${DateTime.parse(widget.data["cancelledDate"].toString()).day}/${DateTime.parse(widget.data["cancelledDate"].toString()).month}/${DateTime.parse(widget.data["cancelledDate"].toString()).year}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : Container(),
                  Builder(
                    builder: (context) {
                      DateTime start =
                          DateTime.parse(widget.data['start'].toString());

                      var startDate = DateFormat('hh:mm a').format(
                          start.add(const Duration(hours: 5, minutes: 45)));
                      var day = DateFormat('EEEE').format(start);

                      DateTime end =
                          DateTime.parse(widget.data['end'].toString());

                      var endDate = DateFormat('hh:mm a').format(
                          end.add(const Duration(hours: 5, minutes: 45)));

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "(" + day.toString() + ") ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text: startDate.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: ' - ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: endDate.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Batch: ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: widget.data['batch'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Room: ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: widget.data['classRoom'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Class Type: ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: widget.data['classType'].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        launch("widget.data['classLink']");
                      },
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: "Class Link: ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: widget.data['classLink'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        launch("widget.data['classLink']");
                      },
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: "Routine Reminder: ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: widget.data['routineReminder'] == null ||
                                      widget.data['routineReminder'] == ""
                                  ? "OFF"
                                  : widget.data['routineReminder'] == true
                                      ? "ON"
                                      : "OFF",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {},
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: "Routine Reminder Time: ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: widget.data['reminderTime'] == null ||
                                      widget.data['reminderTime'] == ""
                                  ? "00:00"
                                  : DateFormat('hh:mm').format(DateTime.parse(
                                          widget.data['reminderTime'])
                                      .add(const Duration(
                                          hours: 5, minutes: 45))),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.data['effectiveDate'] == null ||
                          widget.data['effectiveDate'] == ""
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text: "Effective Date: ",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: DateFormat("d MMM , h:mm a").format(
                                      DateTime.parse(
                                              widget.data['effectiveDate'])
                                          .add(const Duration(
                                              hours: 5, minutes: 45))),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  common.otabatch.contains(widget.data['batch'])
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Only Class Teachers are allowed to do attendance from homepage",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Column(
                          children: [
                            isLoading(snapshot.classTypeApiResponse)
                                ? const CircularProgressIndicator()
                                : snapshot.classType.classTypes == null ||
                                        snapshot
                                            .classType.classTypes!.isEmpty ||
                                        !snapshot.classType.classTypes!
                                            .contains(widget.data["classType"])
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: Text(
                                            "Not found in today's routine",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    : snapshot.Status == true
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Today's attendance has been already taken",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .grey),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => RoutineAttendanceUpdateScreen(
                                                                    moduleSlug:
                                                                        widget.data[
                                                                            'moduleSlug'],
                                                                    batch: widget
                                                                            .data[
                                                                        'batch'],
                                                                    selected_attendance_type:
                                                                        widget.data[
                                                                            'classType']),
                                                              ));
                                                        },
                                                        child: const Text(
                                                          "Edit",
                                                        )),
                                                    SizedBox(width: 10),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .redAccent),
                                                        onPressed: () {
                                                          Map<String, dynamic>
                                                              data = {
                                                            "attendanceBy": user ==
                                                                    null
                                                                ? ""
                                                                : user!.username
                                                                    .toString(),
                                                            "batch": widget
                                                                .data["batch"],
                                                            "moduleSlug": widget
                                                                    .data[
                                                                "moduleSlug"],
                                                            "classType": widget
                                                                    .data[
                                                                "classType"],
                                                            "institution": user ==
                                                                    null
                                                                ? ""
                                                                : user!
                                                                    .institution
                                                                    .toString(),
                                                          };
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      QrAttendanceScreen(
                                                                          data:
                                                                              data)));
                                                        },
                                                        child: const Icon(
                                                            Icons.qr_code_2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.green),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => NewAttendanceScreen(
                                                                batch: widget
                                                                        .data[
                                                                    'batch'],
                                                                module_slug: widget
                                                                        .data[
                                                                    'moduleSlug'],
                                                                attendanceType:
                                                                    widget.data[
                                                                        'classType']),
                                                          )).then((value) {
                                                        snapshot.fetchclass();
                                                        snapshot.checkAttendance(
                                                            widget.data[
                                                                'moduleSlug'],
                                                            widget
                                                                .data['batch'],
                                                            widget.data[
                                                                'classType']);
                                                      });
                                                    },
                                                    child: const Text(
                                                        "Attendance")),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .redAccent),
                                                    onPressed: () {
                                                      Map<String, dynamic>
                                                          data = {
                                                        "attendanceBy":
                                                            user == null
                                                                ? ""
                                                                : user!.username
                                                                    .toString(),
                                                        "batch": widget
                                                            .data["batch"],
                                                        "moduleSlug": widget
                                                            .data["moduleSlug"],
                                                        "classType": widget
                                                            .data["classType"],
                                                        "institution": user ==
                                                                null
                                                            ? ""
                                                            : user!.institution
                                                                .toString(),
                                                      };

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  QrAttendanceScreen(
                                                                      data:
                                                                          data)));
                                                    },
                                                    child: const Icon(
                                                        Icons.qr_code_2)),
                                              ],
                                            ),
                                          )
                          ],
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    height: 5,
                    thickness: 5,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                      child: Text(
                    'Add Notice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Title'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: title_controller,
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Title cant be empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Response',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Content'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: content_controller,
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'content cant be empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Response',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
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
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: () async {
                              try {
                                final data = {
                                  "noticeTitle": title_controller.text,
                                  "noticeContent": content_controller.text,
                                  "batch": widget.data['batch'],
                                  "type": "Batch"
                                };
                                Commonresponse res =
                                    await Addnoticelecturerservice()
                                        .addnotice(data);
                                if (_formKey.currentState!.validate()) {
                                  if (res.success == true) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    title_controller.clear();
                                    content_controller.clear();
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    setState(() {
                                      isloading = false;
                                    });
                                  } else {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: res.message.toString());
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                }
                              } on Exception catch (e) {
                                setState(() {
                                  isloading = true;
                                });
                                Fluttertoast.showToast(msg: e.toString());
                                setState(() {
                                  isloading = false;
                                });
                                // TODO
                              }
                            },
                            child: const Text("Add notice")),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
