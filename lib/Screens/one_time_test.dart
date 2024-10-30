import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/attendance/all_attendance_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_attendance/singlephoto_view.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
import 'package:schoolworkspro_app/response/lecturer/createnew_attendanceresponse.dart';
import 'package:schoolworkspro_app/services/lecturer/getstudent_service.dart';
import 'package:schoolworkspro_app/services/lecturer/post_attendanceservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../request/lecturer/attendancereport_request.dart';
import '../response/attendance_response.dart';
import '../response/authenticateduser_response.dart';
import '../services/lecturer/attendancereport_service.dart';
import 'lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import 'lecturer/my-modules/attendance/qr_attendance_screen.dart';

class OneTimeAttendanceTest extends StatefulWidget {
  const OneTimeAttendanceTest({Key? key}) : super(key: key);

  @override
  _OneTimeAttendanceTestState createState() => _OneTimeAttendanceTestState();
}

class _OneTimeAttendanceTestState extends State<OneTimeAttendanceTest> {
  String? _myclass;
  List<Color> _colors = <Color>[];
  late CommonViewModel commonViewModel;
  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];
  List<dynamic> _presentStudents = <dynamic>[];
  List<dynamic> _absentStudents = <dynamic>[];

  final present_controller = new TextEditingController();
  final absent_controller = new TextEditingController();
  final date_controller = new TextEditingController();
  final _searchController = new TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;
  bool isloading = false;

  bool markAllValue = false;

  User? user;

  late PrinicpalCommonViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AttendanceViewModel>(context, listen: false).fetchclass();
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _provider2 =
          Provider.of<PrinicpalCommonViewModel>(context, listen: false);
    });
    setDate();
    cusSearchBar = const Text(
      "Attendance",
      style: TextStyle(color: Colors.black),
    );
    super.initState();
    getuserData();
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

  setDate() async {
    DateTime now = DateTime.parse(DateTime.now().toString());

    var formattedTime = DateFormat('yyyy/MM/dd, EEEE').format(now);

    setState(() {
      date_controller.text = formattedTime.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: cusSearchBar,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (cusIcon.icon == Icons.search) {
                    cusIcon = const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    );
                    cusSearchBar = TextField(
                      autofocus: true,
                      textInputAction: TextInputAction.go,
                      controller: _searchController,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          hintText: "Search by name..."),
                      onChanged: (text) {
                        setState(() {
                          _listForDisplay = _list.where((list) {
                            var name =
                                list['firstname'] + ' ' + list['lastname'];
                            var itemName = name.toLowerCase();
                            return itemName.contains(text);
                          }).toList();
                        });
                      },
                    );
                  } else {
                    cusIcon = const Icon(Icons.search);
                    _listForDisplay = _list;
                    _searchController.clear();
                    cusSearchBar = const Text(
                      "Attendance",
                      style: TextStyle(color: Colors.black),
                    );
                  }
                });
              },
              icon: cusIcon)
        ],
      ),
      body: Consumer4<AttendanceViewModel, CommonViewModel,
              ModuleAttendanceLecturer, PrinicpalCommonViewModel>(
          builder: (context, value, common, module, pValue, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  isLoading(value.classApiResponse) &&
                          isLoading(module.getAttendacenApiResponse) &&
                          isLoading(module.getAllAttendanceStatusApiResponse)
                      ? const CustomShimmer.rectangular(
                          height: 20.0,
                          width: double.infinity,
                        )
                      : value.classes.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "You need to be a class teacher to do this attendance",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  hintText: 'Select class',
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                items: value.classes.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) async {
                                  setState(() {
                                    _myclass = newVal as String?;

                                    value.checkAttendance('School',
                                        _myclass.toString(), "Theory");
                                    module.fetchStudentAttendance(
                                      'School',
                                      _myclass.toString(),
                                    );

                                    module.fetchStudentAllAttendanceStatus(
                                        'School', _myclass.toString());
                                    Map<String, dynamic> request = {
                                      "batch": _myclass.toString(),
                                      "moduleSlug": "School"
                                    };

                                    pValue.fetchallattendance(request);

                                    _list.clear();
                                    _listForDisplay.clear();
                                    _presentStudents.clear();
                                    _absentStudents.clear();

                                    value
                                        .fetchStudentOnlyForAttendance(
                                            _myclass.toString())
                                        .then((_) {
                                      Map<String, dynamic> scannedRequest = {
                                        "attendanceType": "Theory",
                                        "batch": _myclass.toString(),
                                        "moduleSlug": "School",
                                      };
                                      value
                                          .fetchScannedAttendance(
                                              scannedRequest)
                                          .then((_) {
                                        for (int i = 0;
                                            i <
                                                value
                                                    .studentOnlyForAttendanceList
                                                    .length;
                                            i++) {
                                          _list.add(value
                                              .studentOnlyForAttendanceList[i]);

                                          _listForDisplay = _list;
                                          _absentStudents.add(value
                                                  .studentOnlyForAttendanceList[
                                              i]['username']);

                                          if (value.scannedAttendanceList !=
                                                  null &&
                                              value.scannedAttendanceList
                                                  .isNotEmpty) {
                                            if (value.scannedAttendanceList
                                                .contains(value
                                                        .studentOnlyForAttendanceList[
                                                    i]["username"])) {
                                              setState(() {
                                                _presentStudents.add(value
                                                        .studentOnlyForAttendanceList[
                                                    i]['username']);
                                                // Remove the student from _absentStudents if present
                                                for (int i = 0; i < _absentStudents.length;
                                                i++) {
                                                  if (_presentStudents.contains(_absentStudents[i])) {
                                                    _absentStudents.removeAt(i);
                                                  }
                                                }
                                              });
                                            }
                                          }

                                          present_controller.text =
                                              "Present: ${_presentStudents.length.toString()}";
                                          absent_controller.text =
                                              "Absent: ${_absentStudents.length.toString()}";
                                        }
                                      });
                                    });
                                  });
                                },
                                value: _myclass,
                              ),
                            ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: date_controller,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        hintText: "Today's Date",
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: present_controller,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Present: 0",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: absent_controller,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Absent: 0",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _myclass == null
                      ? const SizedBox()
                      : isLoading(value.checkApiResponse)
                          ? const VerticalLoader()
                          : value.Status == true
                              ? const Text(
                                  "Today's attendance already taken",
                                  style: TextStyle(color: Colors.green),
                                )
                              : isLoading(value
                                          .studentOnlyForAttendanceListApiResponse) &&
                                      isLoading(value
                                          .scannedAttendanceListApiResponse)
                                  ? const VerticalLoader()
                                  : value.studentOnlyForAttendanceList.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 10.0),
                                          child: Text(
                                            "No student available",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : isLoading(
                                              pValue.allAttendanceApiResponse)
                                          ? const VerticalLoader()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
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
                                                            "batch": _myclass,
                                                            "moduleSlug": "School",
                                                            "classType": "Theory",
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
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 20),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            'Mark All',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          Transform.translate(
                                                            offset: const Offset(0, 0),
                                                            child: Checkbox(
                                                              value: markAllValue,
                                                              activeColor: Colors.green,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  if (value!) {
                                                                    for (int i = 0;
                                                                    i < _listForDisplay.length;
                                                                    i++) {
                                                                      setState(() {
                                                                        _absentStudents.clear();
                                                                        _presentStudents.add(
                                                                            _listForDisplay[i]
                                                                            ['username']);
                                                                        markAllValue = true;
                                                                      });
                                                                    }
                                                                  } else {
                                                                    markAllValue = false;
                                                                    setState(() {
                                                                      _presentStudents.clear();
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return _listItem(
                                                        index,
                                                        module
                                                            .getStudentAttendance,
                                                        module
                                                            .getAllAttendanceStatus
                                                            .attendance,
                                                        pValue,
                                                        value);
                                                  },
                                                  itemCount:
                                                      _listForDisplay.length,
                                                ),
                                                common.isLoading == false
                                                    ? ElevatedButton(
                                                        child: const Text(
                                                            "Upload"),
                                                        onPressed:
                                                            () async {
                                                          try {
                                                            final request = StudentAttendanceRequest(
                                                                batch: _myclass,
                                                                absentStudents:
                                                                    _absentStudents,
                                                                moduleSlug:
                                                                    'School',
                                                                presentStudents:
                                                                    _presentStudents,
                                                                attendanceType:
                                                                    "Theory");

                                                            CreateNewAttendanceResponse
                                                                response =
                                                                await PostAttendanceService()
                                                                    .addnewAttendance(
                                                              request,
                                                            );
                                                            common.setLoading(
                                                                true);
                                                            if (response
                                                                    .success ==
                                                                true) {
                                                              value.checkAttendance(
                                                                  'School',
                                                                  _myclass
                                                                      .toString(),
                                                                  "Theory");
                                                              snackThis(
                                                                context:
                                                                    context,
                                                                content: Text(
                                                                    "${response.message}"),
                                                                color: Colors
                                                                    .green,
                                                              );

                                                              common.setLoading(
                                                                  false);
                                                            } else {
                                                              snackThis(
                                                                context:
                                                                    context,
                                                                content: Text(
                                                                    "${response.message}"),
                                                                color: Colors
                                                                    .green,
                                                              );
                                                              common.setLoading(
                                                                  false);
                                                            }
                                                          } catch (e) {
                                                            common.setLoading(
                                                                false);
                                                            Fluttertoast.showToast(
                                                                msg: e
                                                                    .toString());
                                                            common.setLoading(
                                                                false);
                                                          }
                                                        },
                                                      )
                                                    : ElevatedButton(
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3,
                                                        ),
                                                        onPressed: () {
                                                          return;
                                                        })
                                              ],
                                            )
                ],
              )),
        );
      }),
    );
  }

  _listItem(index, List getStudentAttendance, List<dynamic>? attendance,
      PrinicpalCommonViewModel pValue, AttendanceViewModel attendanceApi) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
                radius: 25.0,
                backgroundColor:
                    _colors.length > 0 ? _colors[index] : Colors.grey,
                child: _listForDisplay[index]['userImage'] == null ||
                        _listForDisplay[index]['userImage'].isEmpty
                    ? Text(
                        "${_listForDisplay[index]['firstname'].toString()[0].toUpperCase()}${_listForDisplay[index]['lastname'].toString()[0].toUpperCase()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    : ClipOval(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) {
                                      return SingleImageViewer(
                                        imageIndex: 0,
                                        imageList: _listForDisplay[index]
                                                ['userImage']
                                            .toString(),
                                      );
                                    },
                                    fullscreenDialog: true));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: api_url2 +
                                  '/uploads/users/' +
                                  _listForDisplay[index]['userImage']
                                      .toString(),
                              placeholder: (context, url) => Container(
                                  child: const Center(
                                      child: CupertinoActivityIndicator())),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      )),
            title: Builder(builder: (context) {
              var name = _listForDisplay[index]['firstname'] +
                  " " +
                  _listForDisplay[index]['lastname'];
              return RichText(
                text: TextSpan(
                  text: 'Name: ',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: name.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              );
            }),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Student Id: ',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: _listForDisplay[index]['username'].toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  int indexValue = getStudentAttendance.length < 5
                      ? getStudentAttendance.length
                      : 5;
                  List<dynamic> attendacenValue =
                      getStudentAttendance.sublist(0, indexValue);
                  List<Widget> outer = [];
                  for (int i = 0; i < attendacenValue.length; i++) {
                    if (attendacenValue[i]['present_students']
                        .contains(_listForDisplay[index]['username'])) {
                      outer.add(const Icon(
                        Icons.check,
                        color: Colors.green,
                      ));
                    } else {
                      outer.add(const Icon(
                        Icons.close,
                        color: Colors.red,
                      ));
                    }
                  }
                  return outer.isNotEmpty
                      ? Row(
                          children: outer.reversed.toList(),
                        )
                      : const Text("");
                }),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                attendanceApi.scannedAttendanceList
                        .contains(_listForDisplay[index]['username'])
                    ? const Icon(Icons.qr_code_2)
                    : const SizedBox(),
                Checkbox(
                  value: _presentStudents
                      .contains(_listForDisplay[index]['username']),
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _presentStudents
                            .add(_listForDisplay[index]['username']);
                        _absentStudents.removeWhere((element) =>
                            element == _listForDisplay[index]['username']);
                      } else {
                        _absentStudents.add(_listForDisplay[index]['username']);
                        _presentStudents
                            .remove(_listForDisplay[index]['username']);
                      }
                      setState(() {
                        present_controller.text =
                            "Present: ${_presentStudents.length.toString()}";
                        absent_controller.text =
                            "Absent: ${_absentStudents.length.toString()}";
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
