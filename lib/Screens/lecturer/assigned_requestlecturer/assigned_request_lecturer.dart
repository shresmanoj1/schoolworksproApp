import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/individualrequestdetail.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/request/admin/assignticket_request.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/response/admin/assignticket_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerrequest_response.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/admin/getstaff_service.dart';
import 'package:schoolworkspro_app/services/admin/ticket_service.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';
import '../../prinicpal/principal_common_view_model.dart';

class AssignedRequestLecturer extends StatefulWidget {
  final bool isAdmin;
  const AssignedRequestLecturer({Key? key, required this.isAdmin})
      : super(key: key);

  @override
  _AssignedRequestLecturerState createState() =>
      _AssignedRequestLecturerState();
}

class _AssignedRequestLecturerState extends State<AssignedRequestLecturer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketViewModel>(
        create: (_) => TicketViewModel(),
        child: AssignedRequestBody(
          isAdmin: widget.isAdmin,
        ));
  }
}

class AssignedRequestBody extends StatefulWidget {
  final bool isAdmin;
  AssignedRequestBody({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _AssignedRequestBodyState createState() => _AssignedRequestBodyState();
}

class _AssignedRequestBodyState extends State<AssignedRequestBody> {
  User? user;
  final DateRangePickerController _controller = DateRangePickerController();

  String? department;
  String? dRollSelected;
  List<String> dRollStaffList = [];
  String? staff;
  String? staff_username;
  List<dynamic> department_list = <dynamic>[];
  List<dynamic> _listForDisplay2 = <dynamic>[];
  List<dynamic> staff_list = <dynamic>[];
  bool assignloading = false;
  bool menubarloading = false;
  late TicketViewModel _provider;
  late PrinicpalCommonViewModel _provider2;

  @override
  void initState() {
    getData();
    getStaff();
    super.initState();
  }

  getStaff() async {
    final dropdown = await StaffService().getStaff();
    for (int i = 0; i < dropdown.users!.length; i++) {
      setState(() {
        // print("DROLL::::${dropdown.users![i]['_id']}");
        department_list.add(dropdown.users![i]);
      });
    }
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<TicketViewModel>(context, listen: false);
      _provider2 =
          Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider2.fetchDRolls();
      _provider.fetchassignedrequest(user!.username.toString()).then((value) {
        int output = _provider.backlog +
            _provider.pending +
            _provider.approved +
            _provider.resolved;
        sharedPreferences.setInt('insideassigned', output);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (menubarloading == true) {
      customLoadStart();
    } else if (menubarloading == false) {
      customLoadStop();
    } else if (assignloading == true) {
      customLoadStart();
    } else if (assignloading == false) {
      customLoadStop();
    }

    return Consumer2<TicketViewModel, PrinicpalCommonViewModel>(
        builder: (context, value, snapshot, child) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(widget.isAdmin == true ? 90 : 50.0),
            child: AppBar(
                title: widget.isAdmin == true
                    ? const Text(
                        "Assigned Request",
                        style: TextStyle(color: black),
                      )
                    : null,
                automaticallyImplyLeading:
                    widget.isAdmin == true ? true : false,
                iconTheme: const IconThemeData(
                  color: Colors.black, //change your color here
                ),
                elevation: 0.0,
                bottom: TabBar(
                  indicatorColor: kPrimaryColor,
                  labelColor: Colors.black,
                  tabs: [
                    Builder(builder: (context) {
                      return isLoading(value.assignedRequestApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text: "Backlog \n ${value.backlog.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.assignedRequestApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text: "Todo \n${value.pending.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.assignedRequestApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text: "Progress \n ${value.approved.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.assignedRequestApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text: "Done \n ${value.resolved.toString()}",
                            );
                    }),
                  ],
                ),
                // title: const Text("Assigned Request",
                //     style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white),
          ),
          body: isLoading(value.assignedRequestApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : TabBarView(
                  children: [
                    myRequest(value, "Backlog", snapshot),
                    myRequest(value, "Pending", snapshot),
                    myRequest(value, "Approved", snapshot),
                    myRequest(value, "Resolved", snapshot),
                  ],
                ),
        ),
      );
    });
  }

  Widget bottomSheet(
      BuildContext context, dynamic ticket, TicketViewModel _model) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Change status",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Backlog");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);
                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Status changed successfully');
                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Error while changing status');

                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: const Text("Backlog"),
            trailing: ticket['status'] == "Backlog"
                ? const Icon(Icons.check)
                : const SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Pending");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);
                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Status changed successfully');
                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  Fluttertoast.showToast(msg: "Error while changing status");
                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: const Text("To-Do"),
            trailing: ticket['status'] == "Pending"
                ? const Icon(Icons.check)
                : const SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Approved");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });

                  Navigator.pop(context);
                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Status changed successfully');

                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Error while changing status');

                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: const Text("In Progress"),
            trailing: ticket['status'] == "Approved"
                ? const Icon(Icons.check)
                : const SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Resolved");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);

                  _model.fetchassignedrequest(user!.username.toString());
                  Fluttertoast.showToast(msg: 'Status changed successfully');

                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  Fluttertoast.showToast(msg: 'Error while changing status');
                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                // _model.fetchassignedrequest(user!.username.toString());
                Fluttertoast.showToast(msg: e.toString());

                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: const Text("Done"),
            trailing: ticket['status'] == "Resolved"
                ? const Icon(Icons.check)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget myRequest(TicketViewModel value, String requestType,
      PrinicpalCommonViewModel snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: value.assignedRequest.length,
        itemBuilder: (context, index) {
          var ticket = value.assignedRequest[index];

          DateTime now = DateTime.parse(ticket['createdAt'].toString());

          now = now.add(const Duration(hours: 5, minutes: 45));

          var formattedTime = DateFormat('yMMMMd').format(now);

          return ticket['status'] == requestType
              ? Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: ticket['status'] == "Pending"
                                ? const Color(0xffDCAC04)
                                : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : ticket["status"] == "Backlog"
                                        ? const Color(0xffE80000)
                                        : logoTheme),
                        top: BorderSide(
                            color: ticket['status'] == "Pending"
                                ? const Color(0xffDCAC04)
                                : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : ticket["status"] == "Backlog"
                                        ? const Color(0xffE80000)
                                        : logoTheme),
                        right: BorderSide(
                            color: ticket['status'] == "Pending"
                                ? const Color(0xffDCAC04)
                                : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : ticket["status"] == "Backlog"
                                        ? const Color(0xffE80000)
                                        : logoTheme),
                        left: BorderSide(
                            color: ticket['status'] == "Pending"
                                ? const Color(0xffDCAC04)
                                : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : ticket["status"] == "Backlog"
                                        ? const Color(0xffE80000)
                                        : logoTheme,
                            width: 8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ticket['topic'].toString(),
                                  style: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: ticket['status'] == "Pending"
                                          ? const Color(0xffDCAC04)
                                          : ticket['status'] == "Resolved"
                                              ? Colors.green
                                              : ticket["status"] == "Backlog"
                                                  ? Color(0xffE80000)
                                                  : kPrimaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(ticket['status'].toString(),
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: black,
                                ),
                                child: Text(ticket['ticketId'].toString(),
                                    style: const TextStyle(
                                        color: white, fontSize: 12)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.event,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.timelapse,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        DateFormat.jm().format(DateTime.parse(
                                            ticket['createdAt'].toString())),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.thermostat,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        ticket['severity'].toString(),
                                        style: TextStyle(
                                            color: solidRed, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ticket['request'].toString(),
                            style: const TextStyle(
                              color: black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Requested By:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(ticket['postedBy']['firstname'] +
                                    " " +
                                    ticket['postedBy']['lastname']),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                            color: Colors.grey, height: 0, thickness: 0.5),
                        Container(
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Assigned To:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(ticket['assignedTo']['firstname'] +
                                          " " +
                                          ticket['assignedTo']['lastname']),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: const Text('Change Status'),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet(
                                              context, ticket, value)),
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Assign Ticket'),
                                      onPressed: () {
                                        staff_list.clear();
                                        staff = null;
                                        dRollSelected = null;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Select Department"),
                                                content: SizedBox(
                                                  height: dRollSelected == null
                                                      ? 130
                                                      : 180,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(
                                                          builder: (context) {
                                                        final jsonList =
                                                            department_list
                                                                .map((e) => e)
                                                                .toList();
                                                        //
                                                        final uniqueJsonList =
                                                            jsonList
                                                                .toSet()
                                                                .toList();

                                                        //
                                                        final result =
                                                            uniqueJsonList
                                                                .map((e) => e)
                                                                .toList();

                                                        return isLoading(snapshot
                                                                .dRollApiResponse)
                                                            ? const SizedBox()
                                                            : DropdownButtonFormField(
                                                                value:
                                                                    dRollSelected,
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: black)),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: black)),
                                                                  errorBorder: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.redAccent)),
                                                                  filled: true,
                                                                ),
                                                                hint: const Text(
                                                                    "Select Role"),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .arrow_drop_down_outlined),
                                                                items: snapshot
                                                                    .dRolls
                                                                    .where(
                                                                        (pt) {
                                                                  final roleName =
                                                                      pt["name"]
                                                                          .toString();
                                                                  return roleName !=
                                                                      "STUDENT";
                                                                }).map((pt) {
                                                                  return DropdownMenuItem(
                                                                    value: pt[
                                                                            "_id"]
                                                                        .toString(),
                                                                    child: Text(
                                                                      pt["name"]
                                                                          .toString(),
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (newVal) {
                                                                  if (newVal !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      staff_list
                                                                          .clear();
                                                                      staff =
                                                                          null;
                                                                      dRollSelected =
                                                                          newVal
                                                                              .toString();

                                                                      staff_list =
                                                                          result
                                                                              .where((list) {
                                                                        var itemName =
                                                                            list["drole"];
                                                                        return itemName ==
                                                                            dRollSelected;
                                                                      }).toList();
                                                                    });
                                                                  }
                                                                },
                                                              );
                                                      }),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      dRollSelected == null
                                                          ? const SizedBox()
                                                          : staff_list.isEmpty ? const Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 5),
                                                            child: Center(child: Text("No Staff")),
                                                          ) : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  DropdownButton(
                                                                      value:
                                                                          staff,
                                                                      items: staff_list
                                                                          .map(
                                                                              (pt) {
                                                                        return DropdownMenuItem(
                                                                            value: pt[
                                                                                'username'],
                                                                            child: Text(pt['firstname'] +
                                                                                " " +
                                                                                pt['lastname']));
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (newVal) {
                                                                        if (newVal !=
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            staff =
                                                                                newVal.toString();
                                                                          });
                                                                        }
                                                                      },
                                                                      hint: const Text(
                                                                          "Select staffs"))),

                                                      staff == null ? const SizedBox() :
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  setState(() {
                                                                    assignloading =
                                                                        true;
                                                                  });
                                                                  final data = AssignSupportTicketRequest(
                                                                      assignedDate:
                                                                          DateTime
                                                                              .now(),
                                                                      assignedTo:
                                                                          staff
                                                                              .toString());
                                                                  AssignTicketResponse
                                                                      res =
                                                                      await AdminTicketService().assignTicket(
                                                                          data,
                                                                          ticket[
                                                                              '_id']);
                                                                  if (res.success ==
                                                                      true) {
                                                                    setState(
                                                                        () {
                                                                      assignloading =
                                                                          true;
                                                                    });
                                                                    getData();
                                                                    staff_list.clear();
                                                                    staff = null;
                                                                    dRollSelected = null;
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Ticket assigned to ${staff.toString()}");
                                                                    setState(
                                                                        () {
                                                                      assignloading =
                                                                          false;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      assignloading =
                                                                          true;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Failed assigning ticket to ${staff.toString()}");
                                                                    setState(
                                                                        () {
                                                                      assignloading =
                                                                          false;
                                                                    });
                                                                  }
                                                                } on Exception catch (e) {
                                                                  setState(() {
                                                                    assignloading =
                                                                        true;
                                                                  });
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "${e.toString()}");
                                                                  setState(() {
                                                                    assignloading =
                                                                        false;
                                                                  });

                                                                  // TODO
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'Confirm')),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 9, vertical: 5)),
                                      backgroundColor:
                                          MaterialStateProperty.all(logoTheme),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                IndividualRequestDetail(
                                                    id: ticket['_id']),
                                          ));
                                    },
                                    child: Row(
                                      children: const [
                                        Center(
                                            child: Text(
                                          "Details",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox();
        });
  }
}
