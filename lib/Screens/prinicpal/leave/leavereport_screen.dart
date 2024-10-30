import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/principal/leave_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

class LeaveReportScreen extends StatefulWidget {
  const LeaveReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaveReportScreen> createState() => _LeaveReportScreenState();
}

class _LeaveReportScreenState extends State<LeaveReportScreen> {
  PageController pagecontroller = PageController();
  final TextEditingController leave_typecontroller = TextEditingController();
  final TextEditingController days_controller = TextEditingController();
  int selectedIndex = 0;
  String title = 'Home';
  String? my_selection;
  List<String> type = ["Yearly", "Monthly"];

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  late PrinicpalCommonViewModel _provider;
  bool isSingleWidget = false;

  List<dynamic> filteredCardsList = [];
  List<dynamic> bottomNavigationBarList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider.fetchleaveType();
      _provider.fetchApprovedLeaves();

      fetchData();
    });
    super.initState();
  }

  Future<void> fetchData() async {
    _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
    filteredCardsList = bottomNavigationBarList
        .where((item) => _provider.hasPermission(item['identifier']))
        .toList();
    isSingleWidget = filteredCardsList.length == 1;
    print("TABBAR VIEW:::${filteredCardsList}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      bottomNavigationBarList = [
        {
          "name": "Leave Report",
          "identifier": ["view_staffs_leave_report"],
          "image": "assets/icons/file.png",
          "navigate": leaveReportWidget(value)
        },
        {
          "name": "Edit Leave Type",
          "identifier": ["manage_all_staff_leaves"],
          "image": "assets/icons/more.png",
          "navigate": editLeaveType(value, common)
        }
      ];

      return Scaffold(
        floatingActionButton: selectedIndex == 0
            ? const SizedBox()
            : FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Add new leave type"),
                          content: SizedBox(
                            height: 340,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Leave Type"),
                                TextFormField(
                                  controller: leave_typecontroller,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                const Text("No. of Days"),
                                TextFormField(
                                  controller: days_controller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                const Text("Type"),
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    hintText: 'Select type',
                                  ),
                                  icon: const Icon(
                                      Icons.arrow_drop_down_outlined),
                                  items: type.map((pt) {
                                    return DropdownMenuItem(
                                      value: pt,
                                      child: Text(
                                        pt,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      my_selection = newVal as String?;
                                      // print(_mySelection);
                                    });
                                  },
                                  value: my_selection,
                                ),
                                const SizedBox(
                                  height: 5,
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
                                            my_selection = null;
                                            leave_typecontroller.clear();
                                            days_controller.clear();
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
                                              common.setLoading(true);
                                              Map<String, dynamic> request = {
                                                "leaveType":
                                                    leave_typecontroller.text,
                                                "days": days_controller.text,
                                                "time": my_selection
                                              };
                                              final res =
                                                  await LeaveRepository()
                                                      .postleave(request);
                                              if (res.success == true) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        res.message.toString());
                                                Navigator.pop(context);
                                                my_selection == null;
                                                leave_typecontroller.clear();
                                                days_controller.clear();
                                                _provider.fetchleaveType();
                                              } else {
                                                common.setLoading(true);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        res.message.toString());
                                              }
                                              common.setLoading(false);
                                            } on Exception catch (e) {
                                              common.setLoading(true);
                                              Fluttertoast.showToast(
                                                  msg: e.toString());
                                              common.setLoading(false);
                                              // TODO
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
                                            "Submit",
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
                        );
                      });
                    },
                  );
                },
                label: const Text("Add leave type")),
        appBar: AppBar(
            elevation: 0.0,
            ),
        body: isSingleWidget == true
            ? Column(
                children: filteredCardsList
                    .map<Widget>((item) => item["navigate"] as Widget)
                    .toList(),
              )
            : PageView(
                controller: pagecontroller,
                // onPageChanged: _onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: filteredCardsList
                    .map<Widget>((item) => item["navigate"] as Widget)
                    .toList(),
              ),
        bottomNavigationBar: isSingleWidget
            ? null
            : BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: selectedIndex,
                onTap: _itemTapped,
                type: BottomNavigationBarType.fixed,
                items: List.generate(filteredCardsList.length, (index) {
                  return BottomNavigationBarItem(
                    icon: Image.asset(
                      filteredCardsList[index]["image"].toString(),
                      height: 20,
                      width: 20,
                      color:
                          selectedIndex == index ? kPrimaryColor : Colors.grey,
                    ),
                    label: filteredCardsList[index]["name"],
                  );
                })),
      );
    });
  }

  Widget bottomSheet(int index, String id, PrinicpalCommonViewModel value,
      CommonViewModel common) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 180.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit leave"),
            onTap: () async {
              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  my_selection = value.leavetype[index].time.toString();
                  days_controller.text = value.leavetype[index].days.toString();
                  leave_typecontroller.text =
                      value.leavetype[index].leaveType.toString();
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text("Edit leave type"),
                      content: SizedBox(
                        height: 340,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Leave Type"),
                            TextFormField(
                              controller: leave_typecontroller,
                              keyboardType: TextInputType.text,
                              // initialValue: value.leavetype[index].leaveType.toString(),
                              decoration: const InputDecoration(
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            const Text("No. of Days"),
                            TextFormField(
                              controller: days_controller,
                              // initialValue: value.leavetype[index].days.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            const Text("Type"),
                            DropdownButtonFormField(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                hintText: 'Select type',
                              ),
                              icon: const Icon(Icons.arrow_drop_down_outlined),
                              items: type.map((pt) {
                                return DropdownMenuItem(
                                  value: pt,
                                  child: Text(
                                    pt,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  my_selection = newVal as String?;
                                  // print(_mySelection);
                                });
                              },
                              value: my_selection,
                            ),
                            SizedBox(
                              height: 5,
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
                                        my_selection = null;
                                        leave_typecontroller.clear();
                                        days_controller.clear();
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
                                          common.setLoading(true);
                                          Map<String, dynamic> request = {
                                            "leaveType":
                                                leave_typecontroller.text,
                                            "days": days_controller.text,
                                            "time": my_selection
                                          };
                                          final res = await LeaveRepository()
                                              .updateleave(
                                                  request,
                                                  value.leavetype[index].id
                                                      .toString());
                                          if (res.success == true) {
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                            Navigator.pop(context);
                                            my_selection == null;
                                            leave_typecontroller.clear();
                                            days_controller.clear();
                                            _provider.fetchleaveType();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                          }
                                        } on Exception catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());

                                          // TODO
                                        }
                                        common.setLoading(false);
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
                                        "Submit",
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
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete leave"),
            onTap: () async {
              try {
                common.setLoading(true);
                final res = await LeaveRepository().deleteleave(id);
                if (res.success == true) {
                  Fluttertoast.showToast(msg: res.message.toString());
                  Navigator.pop(context);
                  value.fetchleaveType();
                } else {
                  Fluttertoast.showToast(msg: res.message.toString());
                }
                common.setLoading(false);
              } on Exception catch (e) {
                common.setLoading(true);
                Fluttertoast.showToast(msg: e.toString());
                common.setLoading(false);
                // TODO
              }
            },
          ),
        ],
      ),
    );
  }

  Widget leaveReportWidget(PrinicpalCommonViewModel value) {
    return Container(
      child: isLoadingOnly(value.approvedLeaveApiResponse)
          ? const Center(
              child: SpinKitDualRing(color: kPrimaryColor),
            )
          : value.approvedLeave.isEmpty
              ? Column(
                  children: [
                    Image.asset("assets/images/no_content.PNG"),
                    const Text(
                      "No-one has taken leave today",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    )
                  ],
                )
              : ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Leave Report",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: value.approvedLeave.length,
                        itemBuilder: (context, i) {
                          return Container(
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Builder(builder: (context) {
                                      var name = value
                                              .approvedLeave[i].user!.firstname
                                              .toString() +
                                          " " +
                                          value.approvedLeave[i].user!.lastname
                                              .toString();
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
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        text: 'Reason: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: value.approvedLeave[i].content
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Chip(
                                        backgroundColor: Colors.green,
                                        label: Text(
                                          value.approvedLeave[i].status
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          DateTime now = DateTime.parse(value
                                              .approvedLeave[i].startDate
                                              .toString());

                                          now = now.add(
                                              Duration(hours: 5, minutes: 45));

                                          var formattedTime =
                                              DateFormat('yyyy-MMM-dd')
                                                  .format(now);
                                          return Center(
                                              child: OutlinedButton(
                                                  onPressed: null,
                                                  child: Text("From: " +
                                                      formattedTime
                                                          .toString())));
                                        }),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          DateTime now = DateTime.parse(value
                                              .approvedLeave[i].endDate
                                              .toString());

                                          now = now.add(
                                              Duration(hours: 5, minutes: 45));

                                          var formattedTime =
                                              DateFormat('yyyy-MMM-dd')
                                                  .format(now);
                                          return Center(
                                              child: OutlinedButton(
                                                  onPressed: null,
                                                  child: Text("To: " +
                                                      formattedTime
                                                          .toString())));
                                        }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
    );
  }

  Widget editLeaveType(PrinicpalCommonViewModel value, CommonViewModel common) {
    return Container(
      child: isLoadingOnly(value.leavetypeApiResponse)
          ? const Center(
              child: SpinKitDualRing(
                color: kPrimaryColor,
              ),
            )
          : value.leavetype.isEmpty
              ? Column(
                  children: [
                    Image.asset("assets/images/no_content.PNG"),
                    const Text(
                      "You have not added any leave type",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    )
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    ...List.generate(
                        value.leavetype.length,
                        (index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheet(
                                          index,
                                          value.leavetype[index].id
                                              .toString(),
                                          value,
                                          common)),
                                    );
                                  },
                                  child: const Icon(Icons.more_vert)),
                              title: RichText(
                                text: TextSpan(
                                  text: 'Leave Type: ',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: value
                                          .leavetype[index].leaveType
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Days: ',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: value
                                              .leavetype[index].days
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight:
                                                  FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Time: ',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: value
                                              .leavetype[index].leaveType
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight:
                                                  FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
    );
  }
}
