import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/lecturer/student_filter_leave_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api/api.dart';
import '../../../components/shimmer.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';

class ViewStudentLeaveScreen extends StatefulWidget {
  const ViewStudentLeaveScreen({Key? key}) : super(key: key);

  @override
  State<ViewStudentLeaveScreen> createState() => _ViewStudentLeaveScreenState();
}

class _ViewStudentLeaveScreenState extends State<ViewStudentLeaveScreen> {
  late AttendanceViewModel _provider;
  late StatsCommonViewModel _provider2;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  TextEditingController _searchController = new TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  List<Leaf> _listForDisplay = <Leaf>[];
  List<Leaf> _list = <Leaf>[];
  Widget? cusSearchBar;
  String? selectedBatch;
  String? selectedModule;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<AttendanceViewModel>(context, listen: false);
      _provider2 = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider2.fetchAllBatch();
      DateTime today = DateTime.now();
      DateTime threeDaysAgo = today.subtract(Duration(days: 3));
      fromDateController.text = DateFormat('yyyy-MM-dd').format(threeDaysAgo);
      toDateController.text = DateFormat('yyyy-MM-dd').format(today);

      final request = jsonEncode({
        "startDate": fromDateController.text,
        "endDate": toDateController.text
      });
      _provider.fetchStudentFilterLeave(request).then((_){
        if(_provider.studentFilterLeave.leaves != null || _provider.studentFilterLeave.leaves!.isNotEmpty){
          for (int i = 0; i < _provider.studentFilterLeave.leaves!.length; i++){
            setState(() {
              _list.add(_provider.studentFilterLeave.leaves![i]);
              _listForDisplay = _list;
            });
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // iconTheme: const IconThemeData(
          //   color: Colors.black, //change your color here
          // ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      );
                      this.cusSearchBar = TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        controller: _searchController,
                        style: TextStyle(color:white),
                        decoration: const InputDecoration(
                            hintText: 'Search student name...',
                            hintStyle: TextStyle(color: white),
                            border: InputBorder.none),
                        onChanged: (text) {
                          setState(() {
                            _listForDisplay = _list.where((list) {
                              var itemName = list.user!.firstname
                                  !.toLowerCase() +
                                  " " +
                                  list.user!.lastname!.toLowerCase();
                              print("ITEM NAME:::$itemName");
                              return itemName.contains(text);
                            }).toList();
                          });
                        },
                      );
                    } else {
                      this.cusIcon = const Icon(Icons.search);

                      _listForDisplay = _list;
                      _searchController.clear();
                      this.cusSearchBar = const Text(
                        'Student Stats',
                        style: TextStyle(color: Colors.black),
                      );
                    }
                  });
                },
                icon: cusIcon)
          ],
          centerTitle: false,
          elevation: 0.0,
          title: cusSearchBar,
          // backgroundColor: Colors.white
      ),
      body:
          Consumer2<AttendanceViewModel, StatsCommonViewModel>(builder: (context, attendance, stats, child) {
        return ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("From Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          child: DateTimePicker(
                            controller: fromDateController,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            type: DateTimePickerType.date,
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                fromDateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.parse(val));
                                final request = jsonEncode({
                                  "startDate": fromDateController.text,
                                  "endDate": toDateController.text
                                });
                                _provider.fetchStudentFilterLeave(request);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "To Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          child: DateTimePicker(
                            controller: toDateController,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            type: DateTimePickerType.date,
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                toDateController.text = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(val));
                                final request = jsonEncode({
                                  "startDate": fromDateController.text,
                                  "endDate": toDateController.text
                                });
                                _provider.fetchStudentFilterLeave(request);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading(stats.allbatchtaffApiResponse) ? SizedBox() :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black38)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black38)),
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'All Batch',
                ),
                icon: const Icon(
                    Icons.arrow_drop_down_outlined),
                items: stats.allbatches.map((item) {
                  return DropdownMenuItem(
                    value: item.batch.toString(),
                    child: Text(
                      item.batch.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newVal) async {
                  setState(() {
                    selectedBatch = newVal as String;
                    if( selectedBatch != null){
                      _listForDisplay = _list.where((list) {
                        var itemName = list.user!.batch.toString();
                        print("ITEM NAME:::$itemName");
                        return itemName.contains(selectedBatch!);
                      }).toList();
                    }
                  });
                },
                value: selectedBatch,
              ),
            ),

            isLoading(attendance.studentFilterLeaveApiResponse)
                ? VerticalLoader()
                : attendance.studentFilterLeave.leaves != null
                    ? attendance.studentFilterLeave.leaves!.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                child: DataTable(
                                  dataRowHeight: 60,
                                  showBottomBorder: true,
                                  headingRowColor:
                                      MaterialStateProperty.all(Colors.black),
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                          'Username',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Username'),
                                    DataColumn(
                                        label: Text(
                                          'Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Name'),
                                    DataColumn(
                                        label: Text(
                                          'Section',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Section'),
                                    DataColumn(
                                        label: Text(
                                          'Title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Title'),
                                    DataColumn(
                                        label: Text(
                                          'From',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'From'),
                                    DataColumn(
                                        label: Text(
                                          'To',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'To'),
                                    DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Status'),
                                    DataColumn(
                                        label: Text(
                                          'Request on',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Request on'),
                                    DataColumn(
                                        label: Text(
                                          'Action',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                        tooltip: 'Action'),
                                  ],
                                  rows: _listForDisplay
                                      .map((data) => DataRow(cells: [
                                            DataCell(Text(
                                              data.user != null
                                                  ? data.user!.username
                                                      .toString()
                                                  : "-",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                            DataCell(Text(
                                              data.user != null
                                                  ? "${data.user!.firstname} ${data.user!.lastname}"
                                                  : "-",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                            DataCell(Text(
                                              data.user != null
                                                  ? data.user!.batch.toString()
                                                  : "-",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                            DataCell(Wrap(
                                              children: [
                                                Text(
                                                  data.ticket != null
                                                      ? data.ticket!.topic
                                                          .toString()
                                                      : "-",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            )),
                                            DataCell(Text(
                                              DateFormat.yMMMEd()
                                                  .format(data.startDate!)
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                            DataCell(Text(
                                              DateFormat.yMMMEd()
                                                  .format(data.endDate!)
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                            DataCell(GestureDetector(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: data.ticket != null
                                                          ? data.ticket!
                                                                      .status ==
                                                                  "Pending"
                                                              ? Colors
                                                                  .orangeAccent
                                                              : Colors.green
                                                          : Colors.white,
                                                    ),
                                                    child: Text(
                                                      data.ticket != null
                                                          ? data.ticket!.status
                                                              .toString()
                                                          : "-",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  data.allDay == true
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .grey.shade50,
                                                          ),
                                                          child: const Text(
                                                            "All Day Leave",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            )),
                                            DataCell(
                                              Builder(builder: (context) {
                                                try {
                                                  return data.createdAt == null
                                                      ? Text('')
                                                      : Text(
                                                          DateFormat.yMMMEd()
                                                              .format(data
                                                                  .createdAt!)
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                        );
                                                } on Exception catch (e) {
                                                  return const Text("");
                                                }
                                              }),
                                            ),
                                            DataCell(GestureDetector(
                                              child: InkWell(
                                                  onTap: () {
                                                    showStudentLeaveAlertDialog(
                                                        context, data);
                                                  },
                                                  child: Icon(
                                                      Icons.remove_red_eye)),
                                            )),
                                          ]))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        : Image.asset(
                            "assets/images/no_content.PNG",
                          )
                    : Container(),
          ],
        );
      }),
    );
  }

  showStudentLeaveAlertDialog(
      BuildContext context, dynamic studentLeaveObj) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return studentLeaveObj != null
                  ? Container(
                      height: 580,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Name: ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: studentLeaveObj.user!.firstname
                                                .toString() +
                                            " " +
                                            studentLeaveObj.user!.lastname
                                                .toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Username: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: studentLeaveObj.user!.username
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Batch: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        studentLeaveObj.user!.batch.toString(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Contact: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: studentLeaveObj.user!.contact
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Parent contact: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: studentLeaveObj.user!.parentsContact
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Leave Title: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF03a98a),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: studentLeaveObj.leaveTitle.toString(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Date: ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF2ea033),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "${DateFormat.yMMMd().format(studentLeaveObj.startDate!)} - ${DateFormat.yMMMd().format(studentLeaveObj.endDate!)}",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Leave Status: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF2ea033),
                                  ),
                                ),
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: studentLeaveObj.status == "Pending"
                                          ? Colors.orangeAccent
                                          : Colors.green),
                                  child: Center(
                                      child: Text(
                                    studentLeaveObj.status.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Leave Type: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF2ea033),
                                  ),
                                ),
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: studentLeaveObj.allDay == true
                                          ? Colors.orangeAccent
                                          : Colors.redAccent),
                                  child: Center(
                                      child: Text(
                                    studentLeaveObj.allDay == true
                                        ? "All Day Leave"
                                        : "Subject/Module Wise Leave",
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Requested on: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Center(
                                    child: Text(
                                  DateFormat.yMMMd()
                                      .format(studentLeaveObj.createdAt!),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReadMoreText(
                              studentLeaveObj.content.toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' Read more',
                              trimExpandedText: ' Less',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            studentLeaveObj.allDay == true
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Leave For Following Routines(Module/Subject):",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ...List.generate(
                                          studentLeaveObj.routines!.length,
                                          (innerIndex) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                          "${studentLeaveObj.routines![innerIndex].title} (${studentLeaveObj.routines![innerIndex].classType}) "),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Text(
                                                        "${DateFormat.yMMMd().format(studentLeaveObj.routines![innerIndex].date)}"),
                                                  ),
                                                ],
                                              )),
                                    ],
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Attachments: ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                ...List.generate(
                                    studentLeaveObj.ticket.requestFile.length,
                                    (index) => Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: InkWell(
                                              onTap: () async {
                                                String url = api_url2 +
                                                    '/uploads/files/' +
                                                    studentLeaveObj.ticket
                                                        .requestFile![index];
                                                var attachmentUrl =
                                                    url.split(" ").join("%20");

                                                if (await canLaunch(
                                                    attachmentUrl)) {
                                                  await launch(attachmentUrl);
                                                } else {
                                                  throw 'Could not launch $attachmentUrl';
                                                }
                                              },
                                              child: Text(
                                                studentLeaveObj
                                                    .ticket.requestFile![index]
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.blueAccent),
                                              ),
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Remarks: ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: studentLeaveObj.remarks != null
                                        ? studentLeaveObj.remarks.toString()
                                        : "",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox();
            }),
          );
        });
  }
}
