import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/gallery/view_photo.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_attendance/singlephoto_view.dart';
import 'package:schoolworkspro_app/Screens/request/DateRequest.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/principal/staffattendanceprincipal_response.dart';

import '../../../constants/colors.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({Key? key}) : super(key: key);

  @override
  _StaffAttendanceState createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  List<AttendanceDatum> _list = <AttendanceDatum>[];
  List<AttendanceDatum> _listForDisplay = <AttendanceDatum>[];

  List<AttendanceDatum> _list2 = <AttendanceDatum>[];
  List<AttendanceDatum> _listForDisplay2 = <AttendanceDatum>[];
  List<AttendanceDatum> _originalList = <AttendanceDatum>[];
  Widget? cusSearchBar;
  Widget? cusSearchBar2;
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _searchController2 = new TextEditingController();
  int presentCount = 0;
  int presentCount2 = 0;
  int totalCount = 0;
  int totalCount1 = 0;
  Icon cusIcon = const Icon(Icons.search);
  Icon cusIcon2 = const Icon(Icons.search);
  late PrinicpalCommonViewModel _provider;

  String? selectedTeacher;

  String title = 'Teachers';
  int selectedIndex = 0;

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = "Teachers";
          }
          break;
        case 1:
          {
            title = "Staffs";
          }
          break;
      }
    });
  }

  PageController pagecontroller = PageController();

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      final date = DateRequest(date: DateTime.now());
      _provider.fetchallattendanceforstaffs(date).then((_){
        getData1();
        getData2();
        _provider.fetchDRolls();
        _provider.fetchStaffTypes();
      });
    });
    super.initState();
  }

  getData1() async {
    for (int i = 0; i < _provider.attendanceStaff.length; i++) {
      setState(() {
        _list.add(_provider.attendanceStaff[i]);
        _listForDisplay = _list;
      });

      if (_provider.attendanceStaff[i].attendance == 1) {
        setState(() {
          presentCount = presentCount + 1;
        });
      }

      setState(() {
        totalCount = totalCount + 1;
      });

      cusSearchBar = Text(
        "${presentCount.toString()}/${totalCount.toString()}",

      );
    }
  }

  getData2() async {
    _listForDisplay2.clear();
    _list2.clear();
    for (int i = 0; i < _provider.attendanceStaff.length; i++) {
      setState(() {
        _list2.add(_provider.attendanceStaff[i]);
        _listForDisplay2 = _list2;
      });

      if (_provider.attendanceStaff[i].attendance == 1) {
        setState(() {
          presentCount2 = presentCount2 + 1;
        });
      }

      setState(() {
        totalCount1 = totalCount1 + 1;
      });
      cusSearchBar2 = Text(
        "${presentCount2.toString()}/${totalCount1.toString()}",

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          child: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == menubar.all) {
                if (selectedIndex == 0) {
                  setState(() {
                    _listForDisplay.clear();
                    _list.clear();
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    // if (_provider.attendanceStaff[i].type == "Lecturer" ||
                    //     _provider.attendanceStaff[i].type == "Head Lecturer") {
                    setState(() {
                      _list.add(_provider.attendanceStaff[i]);
                      _listForDisplay = _list;
                    });
                    // }
                  }
                } else if (selectedIndex == 1) {
                  setState(() {
                    _listForDisplay2.clear();
                    _list2.clear();
                    selectedTeacher = null;
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    // if (_provider.attendanceStaff[i].type != "Lecturer" &&
                    //     _provider.attendanceStaff[i].type != "Head Lecturer") {
                    setState(() {
                      _list2.add(_provider.attendanceStaff[i]);
                      _listForDisplay2 = _list2;
                    });
                  }
                  // }
                }
              } else if (value == menubar.arrived) {
                if (selectedIndex == 0) {
                  setState(() {
                    _listForDisplay.clear();
                    _list.clear();
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    if (_provider.attendanceStaff[i].attendance == 1) {
                      // if (_provider.attendanceStaff[i].type == "Lecturer" ||
                      //     _provider.attendanceStaff[i].type ==
                      //         "Head Lecturer") {
                      setState(() {
                        _list.add(_provider.attendanceStaff[i]);
                        _listForDisplay = _list;
                      });
                      // }
                    }
                  }
                } else if (selectedIndex == 1) {
                  setState(() {
                    _listForDisplay2.clear();
                    _list2.clear();
                    selectedTeacher = null;
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    if (_provider.attendanceStaff[i].attendance == 1) {
                      // if (_provider.attendanceStaff[i].type != "Lecturer" &&
                      //     _provider.attendanceStaff[i].type !=
                      //         "Head Lecturer") {
                      setState(() {
                        _list2.add(_provider.attendanceStaff[i]);
                        _listForDisplay2 = _list2;
                        selectedTeacher = null;
                      });
                      // }
                    }
                  }
                }
              } else if (value == menubar.not_arrived) {
                if (selectedIndex == 0) {
                  setState(() {
                    _listForDisplay.clear();
                    _list.clear();
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    if (_provider.attendanceStaff[i].attendance == 0) {
                      // if (_provider.attendanceStaff[i].type == "Lecturer" ||
                      //     _provider.attendanceStaff[i].type ==
                      //         "Head Lecturer") {
                      setState(() {
                        _list.add(_provider.attendanceStaff[i]);
                        _listForDisplay = _list;
                      });
                      // }
                    }
                  }
                } else if (selectedIndex == 1) {
                  setState(() {
                    _listForDisplay2.clear();
                    _list2.clear();
                    selectedTeacher = null;
                  });
                  DateTime now = DateTime.now();

                  final date = DateRequest(date: DateTime.now());
                  // Map<String, dynamic> datas = {"date": DateTime.now().toString()};
                  _provider.fetchallattendanceforstaffs(date);

                  for (int i = 0; i < _provider.attendanceStaff.length; i++) {
                    if (_provider.attendanceStaff[i].attendance == 0) {
                      // if (_provider.attendanceStaff[i].type != "Lecturer" &&
                      //     _provider.attendanceStaff[i].type !=
                      //         "Head Lecturer") {
                      setState(() {
                        _list2.add(_provider.attendanceStaff[i]);
                        _listForDisplay2 = _list2;
                      });
                      // }
                    }
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return menubar.settings.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: selectedIndex == 0 ? cusSearchBar : cusSearchBar2,
          actions: [
            selectedIndex == 0
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if (cusIcon.icon == Icons.search) {
                          cusIcon = const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          );
                          cusSearchBar = TextField(
                            style: const TextStyle(color: white),
                            autofocus: true,
                            textInputAction: TextInputAction.go,
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'search ...',
                                border: InputBorder.none),
                            onChanged: (text) {
                              setState(() {
                                _listForDisplay = _list.where((list) {
                                  var itemName = "${list.firstname
                                          .toString()
                                          .toLowerCase()} ${list.lastname.toString().toLowerCase()}";
                                  return itemName.contains(text);
                                }).toList();
                              });
                            },
                          );
                        } else {
                          cusIcon = const Icon(Icons.search);
                          _listForDisplay = _list;
                          _searchController.clear();
                          cusSearchBar = Text(
                            "${presentCount.toString()}/${totalCount.toString()}",

                          );
                        }
                      });
                    },
                    icon: cusIcon)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        if (cusIcon2.icon == Icons.search) {
                          cusIcon2 = const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          );
                          cusSearchBar2 = TextField(
                            autofocus: true,
                            style: const TextStyle(color: white),
                            textInputAction: TextInputAction.go,
                            controller: _searchController2,
                            decoration: const InputDecoration(
                                hintText: 'search ...',

                                hintStyle: TextStyle(color: Colors.grey),

                                border: InputBorder.none),
                            onChanged: (text) {
                              setState(() {
                                _listForDisplay2 = _list2.where((lists) {
                                  var itemName = "${lists.firstname
                                          .toString()
                                          .toLowerCase()} ${lists.lastname.toString().toLowerCase()}";
                                  return itemName.contains(text);
                                }).toList();
                              });
                            },
                          );
                        } else {
                          this.cusIcon2 = Icon(Icons.search);
                          _listForDisplay2 = _list2;
                          _searchController2.clear();
                          this.cusSearchBar2 = Text(
                            "${presentCount.toString()}/${totalCount1.toString()}",

                          );
                        }
                      });
                    },
                    icon: selectedIndex == 0 ? cusIcon : cusIcon2)
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: _itemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/file.png',
                height: 20,
                width: 20,
                color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
              ),
              label: "Teachers",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/more.png',
                height: 20,
                width: 20,
                color: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
              ),
              label: 'Staffs',
            ),
          ],
        ),
        body: Consumer<PrinicpalCommonViewModel>(
            builder: (context, viewModel, child) {
          return PageView(
            controller: pagecontroller,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                child: _listForDisplay.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? _searchBar()
                                    : _listItem(index - 1);
                              },
                              itemCount: _listForDisplay.length + 1,
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context) {
                      return DropdownButtonFormField(
                        value: selectedTeacher,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: black)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          filled: true,
                        ),
                        hint: const Text("Select Role"),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: viewModel.dRolls.where((pt) {
                          final roleName = pt["name"].toString();
                          return roleName != "LECTURER" &&
                              roleName != "HEAD_LECTURER" &&
                              roleName != "STUDENT";
                        }).map((pt) {
                          return DropdownMenuItem(
                            value: pt["_id"],
                            child: Text(
                              pt["name"].toString(),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedTeacher = newVal as String;

                            if (_list2.isNotEmpty) {
                              _listForDisplay2 = _list2.where((list) {
                                var itemName = list.drole;
                                return itemName == newVal;
                              }).toList();
                            }
                          });
                        },
                      );
                    }),
                  ),
                  Expanded(
                    child: Container(
                      child: _listForDisplay2.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index2) {
                                      return index2 == 0
                                          ? _searchBar()
                                          : _listItem2(index2 - 1);
                                    },
                                    itemCount: _listForDisplay2.length + 1,
                                  ),
                                  const SizedBox(
                                    height: 75,
                                  ),
                                ],
                              ),
                            )
                          : _listForDisplay2.isEmpty && _list2.isNotEmpty
                              ? const Center(child: Text("No data"))
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  _searchBar() {
    return const SizedBox();
  }

  _listItem(index) {
    // _listForDisplay[index].counter>0
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            _listForDisplay[index].firstname.toString() +
                " " +
                _listForDisplay[index].lastname.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _listForDisplay[index].email.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _listForDisplay[index].designation == null ||
                      _listForDisplay[index].designation == ""
                  ? const SizedBox()
                  : Chip(
                      backgroundColor: Color(0xff17a2b8),
                      padding: const EdgeInsets.all(4),
                      labelPadding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      label: Text(
                        _listForDisplay[index].designation.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
              _listForDisplay[index].punchInOut == "absent"
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          if (_listForDisplay[index].punchInOut[0]['punchIn'] !=
                              null) {
                            DateTime now = DateTime.parse(_listForDisplay[index]
                                .punchInOut[0]['punchIn']
                                .toString());

                            now = now.add(Duration(hours: 5, minutes: 45));

                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Text("In time: " + formattedTime);
                          }
                          return Text("");
                        }),
                        Builder(builder: (context) {
                          if (_listForDisplay[index].punchInOut[0]
                                  ['punchOut'] !=
                              null) {
                            DateTime now = DateTime.parse(_listForDisplay[index]
                                .punchInOut[0]['punchOut']
                                .toString());

                            DateTime innow = DateTime.parse(
                                _listForDisplay[index]
                                    .punchInOut[0]['punchIn']
                                    .toString());
                            innow = innow.add(Duration(hours: 5, minutes: 45));
                            now = now.add(Duration(hours: 5, minutes: 45));

                            Duration diff = now.difference(innow).abs();
                            final hours = diff.inHours;
                            final minutes = diff.inMinutes % 60;
                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Out Time: " + formattedTime.toString()),
                                Text("Work duration: " +
                                    hours.toString() +
                                    " hours " +
                                    minutes.toString() +
                                    " minutes")
                              ],
                            );
                          }
                          return Text("");
                        }),
                      ],
                    )
            ],
          ),
          leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: _listForDisplay[index].userImage == null
                  ? Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  : Colors.white,
              child: _listForDisplay[index].userImage == null ||
                      _listForDisplay[index].userImage!.isEmpty
                  ? Text(
                      _listForDisplay[index]
                              .firstname
                              .toString()[0]
                              .toUpperCase() +
                          "" +
                          _listForDisplay[index]
                              .lastname
                              .toString()[0]
                              .toUpperCase(),
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
                                          .userImage
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
                                _listForDisplay[index].userImage.toString(),
                            placeholder: (context, url) => Container(
                                child: const Center(
                                    child: CupertinoActivityIndicator())),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    )),
          trailing: _listForDisplay[index].attendance == 0
              ? const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
        ),
      ],
    );
  }

  _listItem2(index) {
    // _listForDisplay[index].counter>0
    print("desination::::${_listForDisplay2[index].designation}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: _listForDisplay2[index].userImage == null
                  ? Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  : Colors.white,
              child: _listForDisplay2[index].userImage == null ||
                      _listForDisplay2[index].userImage!.isEmpty
                  ? Text(
                      _listForDisplay2[index]
                              .firstname
                              .toString()[0]
                              .toUpperCase() +
                          "" +
                          _listForDisplay2[index]
                              .lastname
                              .toString()[0]
                              .toUpperCase(),
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
                                      imageList: _listForDisplay2[index]
                                          .userImage
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
                                _listForDisplay2[index].userImage.toString(),
                            placeholder: (context, url) => Container(
                                child: const Center(
                                    child: CupertinoActivityIndicator())),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    )),
          title: Text(
            _listForDisplay2[index].firstname.toString() +
                " " +
                _listForDisplay2[index].lastname.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _listForDisplay2[index].email.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _listForDisplay2[index].designation == null ||
                      _listForDisplay2[index].designation == ""
                  ? Chip(
                      backgroundColor: Colors.black45,
                      label: Text(
                        _listForDisplay2[index].type.toString(),
                        style: const TextStyle(color: Colors.white),
                      ))
                  : Chip(
                      backgroundColor: Color(0xff17a2b8),
                      padding: const EdgeInsets.all(4),
                      labelPadding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      label: Text(
                        _listForDisplay2[index].designation.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
              _listForDisplay2[index].punchInOut == "absent"
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          if (_listForDisplay2[index].punchInOut[0]
                                  ['punchIn'] !=
                              null) {
                            DateTime now = DateTime.parse(
                                _listForDisplay2[index]
                                    .punchInOut[0]['punchIn']
                                    .toString());

                            now = now.add(Duration(hours: 5, minutes: 45));

                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Text("In time: " + formattedTime);
                          }
                          return Text("");
                        }),
                        Builder(builder: (context) {
                          if (_listForDisplay2[index].punchInOut[0]
                                  ['punchOut'] !=
                              null) {
                            DateTime now = DateTime.parse(
                                _listForDisplay2[index]
                                    .punchInOut[0]['punchOut']
                                    .toString());

                            DateTime innow = DateTime.parse(
                                _listForDisplay2[index]
                                    .punchInOut[0]['punchIn']
                                    .toString());
                            innow = innow.add(Duration(hours: 5, minutes: 45));
                            now = now.add(Duration(hours: 5, minutes: 45));

                            Duration diff = now.difference(innow).abs();
                            final hours = diff.inHours;
                            final minutes = diff.inMinutes % 60;
                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Out Time: " + formattedTime.toString()),
                                Text("Work duration: " +
                                    hours.toString() +
                                    " hours " +
                                    minutes.toString() +
                                    " minutes")
                              ],
                            );
                          }
                          return Text("");
                        }),
                      ],
                    )
            ],
          ),
          trailing: _listForDisplay2[index].attendance == 0
              ? const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
        ),
      ],
    );
  }
}

class menubar {
  static const String all = "All";
  static const String not_arrived = "Not Arrived";
  static const String arrived = "Arrived";

  static const List<String> settings = <String>[all, not_arrived, arrived];
}
