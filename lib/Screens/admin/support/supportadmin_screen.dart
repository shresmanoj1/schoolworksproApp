import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/individualrequestdetail.dart';
import 'package:schoolworkspro_app/Screens/admin/support/addsupport_screen.dart';
import 'package:schoolworkspro_app/Screens/admin/support/individualsupportticketscreen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/request/admin/assignticket_request.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/admin/assignsupportticket_response.dart';
import 'package:schoolworkspro_app/response/admin/getstaff_response.dart';
import 'package:schoolworkspro_app/services/admin/assignedsupportrequest.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/admin/getstaff_service.dart';
import 'package:schoolworkspro_app/services/admin/support_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';

class AdminSupportDetailScreen extends StatefulWidget {
  final title;

  AdminSupportDetailScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _AdminSupportDetailScreenState createState() =>
      _AdminSupportDetailScreenState();
}

class _AdminSupportDetailScreenState extends State<AdminSupportDetailScreen> {
  User? user;

  Future<GetStaffResponse>? staff_response;
  Icon cusIcon = const Icon(Icons.search);
  late Widget cusSearchBar;
  final TextEditingController _searchController = TextEditingController();
  String? department;
  String? staff;
  String? staff_username;
  List<dynamic> department_list = <dynamic>[];
  List<dynamic> staff_list = <dynamic>[];
  bool isloading = false;
  bool meubarloading = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getStaff();

    cusSearchBar = Text(
      widget.title,
      style: const TextStyle(color: Colors.black),
    );
    super.initState();
  }

  getStaff() async {
    final dropdown = await StaffService().getStaff();
    for (int i = 0; i < dropdown.users!.length; i++) {
      setState(() {
        department_list.add(dropdown.users![i]['type']);
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
  }

  @override
  Widget build(BuildContext context) {
    if (meubarloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          title:
              Text(widget.title, style: const TextStyle(color: Colors.black)),
          actions: [
            user?.type.toString() == "Management"
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSupportScreen(),
                              ));
                        },
                        icon: const Icon(Icons.add)),
                  )
          ],
          backgroundColor: Colors.white,
        ),
        body: ChangeNotifierProvider<AssignedSupportService>(
            create: (context) => AssignedSupportService(),
            child: Consumer<AssignedSupportService>(
                builder: (context, provider, child) {
              provider.getAssignedSupport(context, user?.username.toString());
              if (provider.data?.requests == null) {
                provider.getAssignedSupport(context, user?.username.toString());
                return const Center(
                    child: SpinKitDualRing(
                  color: kPrimaryColor,
                ));
              }

              return ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          color: Colors.pinkAccent,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Backlog',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    try {
                                      return Text(
                                        provider.data!.backlog.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } on Exception catch (e) {
                                      return Text("0");
                                      // TODO
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          color: Colors.pink,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pending',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    try {
                                      return Text(
                                        provider.data!.pending.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } on Exception catch (e) {
                                      return Text("0");
                                      // TODO
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          color: Colors.purpleAccent,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'In Progress',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    try {
                                      return Text(
                                        provider.data!.approved.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } on Exception catch (e) {
                                      return Text("0");
                                      // TODO
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          color: Colors.blue,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resolved',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    try {
                                      return Text(
                                        provider.data!.resolved.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } on Exception catch (e) {
                                      return Text("0");
                                      // TODO
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.data!.requests?.length,
                    itemBuilder: (context, index) {
                      var ticket = provider.data!.requests?[index];
                      DateTime now =
                          DateTime.parse(ticket['createdAt'].toString());

                      now = now.add(const Duration(hours: 5, minutes: 45));

                      var formattedTime = DateFormat('yMMMMd').format(now);

                      // var ticketResponseLength = ticket.ticketResponse.length;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IndividualSupportRequestScreen(
                                        id: provider.data?.requests?[index]
                                            ['_id']),
                              ));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 300,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                            color: ticket['status'] ==
                                                    "Resolved"
                                                ? Colors.green
                                                : ticket['status'] == "Pending"
                                                    ? Colors.orange
                                                    : ticket['status'] ==
                                                            "Approved"
                                                        ? Colors.green
                                                        : Colors.orange,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                              ticket['status'] == "Resolved"
                                                  ? "Done"
                                                  : ticket['status'] ==
                                                          "Pending"
                                                      ? "To do"
                                                      : ticket['status'] ==
                                                              "Approved"
                                                          ? "In Progress"
                                                          : "Backlog",
                                              style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(ticket['topic'].toString()),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (value) async {
                                          if (value == menubar5.backlog) {
                                            try {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              final data =
                                                  AdminChangeTicketStatusRequest(
                                                      status: "Backlog");

                                              AdminChangeTicketStatusResponse
                                                  response =
                                                  await AssignedSupportService()
                                                      .updateStatus(
                                                          data, ticket['_id']);

                                              if (response.success == true) {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: const Text(
                                                        "Status changed successfully"),
                                                    color: Colors.green,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: const Text(
                                                        "Error while changing status"),
                                                    color: Colors.red,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              }
                                            } on Exception catch (e) {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              snackThis(
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                  duration: 1,
                                                  behavior: SnackBarBehavior
                                                      .floating);
                                              setState(() {
                                                meubarloading = false;
                                              });
                                              // TODO
                                            }

                                            // Navigator.of(context).pushNamed(Paymentinfo.routeName);
                                          } else if (value == menubar5.to_do) {
                                            try {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              final data =
                                                  AdminChangeTicketStatusRequest(
                                                      status: "Pending");

                                              AdminChangeTicketStatusResponse
                                                  response =
                                                  await AssignedSupportService()
                                                      .updateStatus(
                                                          data, ticket['_id']);

                                              if (response.success == true) {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Status changed successfully"),
                                                    color: Colors.green,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Error while changing status"),
                                                    color: Colors.red,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              }
                                            } on Exception catch (e) {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              snackThis(
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                  duration: 1,
                                                  behavior: SnackBarBehavior
                                                      .floating);
                                              setState(() {
                                                meubarloading = false;
                                              });
                                              // TODO
                                            }
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context) => Paymenttransactioninfo()),
                                            // );
                                          } else if (value ==
                                              menubar5.in_progress) {
                                            try {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              final data =
                                                  AdminChangeTicketStatusRequest(
                                                      status: "Approved");

                                              AdminChangeTicketStatusResponse
                                                  response =
                                                  await AssignedSupportService()
                                                      .updateStatus(
                                                          data, ticket['_id']);

                                              if (response.success == true) {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Status changed successfully"),
                                                    color: Colors.green,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Error while changing status"),
                                                    color: Colors.red,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              }
                                            } on Exception catch (e) {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              snackThis(
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                  duration: 1,
                                                  behavior: SnackBarBehavior
                                                      .floating);
                                              setState(() {
                                                meubarloading = false;
                                              });
                                              // TODO
                                            }
                                            // Navigator.of(context).pushNamed(PaymentSettlement.routeName);
                                          } else if (value == menubar5.done) {
                                            try {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              final data =
                                                  AdminChangeTicketStatusRequest(
                                                      status: "Resolved");

                                              AdminChangeTicketStatusResponse
                                                  response =
                                                  await AssignedSupportService()
                                                      .updateStatus(
                                                          data, ticket['_id']);

                                              if (response.success == true) {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Status changed successfully"),
                                                    color: Colors.green,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  meubarloading = true;
                                                });
                                                snackThis(
                                                    context: context,
                                                    content: Text(
                                                        "Error while changing status"),
                                                    color: Colors.red,
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating);
                                                setState(() {
                                                  meubarloading = false;
                                                });
                                              }
                                            } on Exception catch (e) {
                                              setState(() {
                                                meubarloading = true;
                                              });
                                              snackThis(
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                  duration: 1,
                                                  behavior: SnackBarBehavior
                                                      .floating);
                                              setState(() {
                                                meubarloading = false;
                                              });
                                              // TODO
                                            }
                                            // Navigator.of(context).pushNamed(PaymentSettlement.routeName);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return menubar5.settings
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.map,
                                                size: 15,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                              Flexible(
                                                child: Text(ticket['ticketId']
                                                    .toString()),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.timer,
                                                size: 15,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                              Text(formattedTime),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.thermostat,
                                                size: 15,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                              Text(ticket['severity']
                                                  .toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          ticket['request'].toString(),
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Requested By:'),
                                                Text(provider.data?.requests?[
                                                            index]['postedBy']
                                                        ['firstname'] +
                                                    " " +
                                                    provider.data?.requests?[
                                                            index]['postedBy']
                                                        ['lastname']),
                                              ],
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text('Assigned To:'),
                                                Text(provider.data?.requests?[
                                                            index]['assignedTo']
                                                        ['firstname'] +
                                                    " " +
                                                    provider.data?.requests?[
                                                            index]['assignedTo']
                                                        ['lastname']),
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            provider.data?.requests?[index]
                                                        ['status'] ==
                                                    "Resolved"
                                                ? SizedBox()
                                                : TextButton(
                                                    child: const Text(
                                                        'Assign Ticket'),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Select Department"),
                                                              content: SizedBox(
                                                                height:
                                                                    department ==
                                                                            null
                                                                        ? 130
                                                                        : 180,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Builder(
                                                                          builder:
                                                                              (context) {
                                                                        isloading =
                                                                            true;

                                                                        final jsonList = department_list
                                                                            .map((e) =>
                                                                                e)
                                                                            .toList();

                                                                        final uniqueJsonList = jsonList
                                                                            .toSet()
                                                                            .toList();

                                                                        final result = uniqueJsonList
                                                                            .map((e) =>
                                                                                e)
                                                                            .toList();

                                                                        isloading =
                                                                            false;

                                                                        return DropdownButton(
                                                                            value:
                                                                                department,
                                                                            items: result.map(
                                                                                (pt) {
                                                                              return DropdownMenuItem(
                                                                                value: pt,
                                                                                child: Text(pt),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged:
                                                                                (newVal) async {
                                                                              setState(() {
                                                                                setState(() {
                                                                                  isloading = true;
                                                                                });
                                                                                department = newVal.toString();
                                                                                staff_list.clear();
                                                                                setState(() {
                                                                                  isloading = false;
                                                                                });
                                                                              });

                                                                              final result = await StaffService().getStaff();
                                                                              for (int i = 0; i < result.users!.length; i++) {
                                                                                if (result.users![i]['type'] == department) {
                                                                                  setState(() {
                                                                                    isloading = true;
                                                                                    staff = null;

                                                                                    staff_list.add(result.users![i]);
                                                                                    isloading = false;
                                                                                  });
                                                                                }
                                                                              }
                                                                            },
                                                                            hint:
                                                                                Text("Select department"));

                                                                      }),
                                                                    ),
                                                                    department ==
                                                                            null
                                                                        ? const SizedBox()
                                                                        : Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child: DropdownButton(
                                                                                value: staff,
                                                                                items: staff_list.map((pt) {
                                                                                  return DropdownMenuItem(value: pt['username'], child: Text(pt['firstname'] + " " + pt['lastname']));
                                                                                }).toList(),
                                                                                onChanged: (newVal) {
                                                                                  setState(() {
                                                                                    isloading = true;
                                                                                    staff = newVal.toString();
                                                                                    isloading = false;
                                                                                  });
                                                                                },
                                                                                hint: Text("Select staffs"))

                                                                            ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.black),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              try {
                                                                                setState(() {
                                                                                  isloading = true;
                                                                                });
                                                                                final data = AssignSupportTicketRequest(assignedDate: DateTime.now(), assignedTo: staff.toString());
                                                                                AssignSupportTicketResponse res = await Supportservice().assignTicket(data, provider.data?.requests?[index]['_id']);
                                                                                if (res.success == true) {
                                                                                  setState(() {
                                                                                    isloading = true;
                                                                                  });
                                                                                  Navigator.of(context).pop();
                                                                                  Fluttertoast.showToast(msg: "Ticket assigned to ${staff.toString()}");
                                                                                  setState(() {
                                                                                    isloading = false;
                                                                                  });
                                                                                } else {
                                                                                  setState(() {
                                                                                    isloading = true;
                                                                                  });
                                                                                  Fluttertoast.showToast(msg: "Failed assigning ticket to ${staff.toString()}");
                                                                                  setState(() {
                                                                                    isloading = false;
                                                                                  });
                                                                                }
                                                                              } on Exception catch (e) {
                                                                                setState(() {
                                                                                  isloading = true;
                                                                                });
                                                                                Fluttertoast.showToast(msg: "${e.toString()}");
                                                                                setState(() {
                                                                                  isloading = false;
                                                                                });

                                                                                // TODO
                                                                              }
                                                                            },
                                                                            child:
                                                                                const Text('Confirm')),
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
                                                  )
                                          ],
                                        )
                                      ],
                                    )

                                    // ButtonBar(
                                    //   children: [
                                    //     ElevatedButton(
                                    //       onPressed: () {
                                    //         // Navigator.push(
                                    //         //   context,
                                    //         //   MaterialPageRoute(
                                    //         //       builder: (context) =>
                                    //         //           LecturerRequestDetailScreen(
                                    //         //             id: ticket.id.toString(),
                                    //         //           )),
                                    //         // );
                                    //       },
                                    //       child: const Text("Details >"),
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 300,
                                width: 5,
                                color: ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : Colors.orange,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            })));
  }
}

class menubar5 {
  static const String backlog = "Backlog";
  static const String to_do = "To Do";
  static const String in_progress = "In Progress";
  static const String done = "Done";

  static const List<String> settings = <String>[
    backlog,
    to_do,
    in_progress,
    done,
  ];
}
