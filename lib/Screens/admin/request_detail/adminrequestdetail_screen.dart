import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/individualrequestdetail.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/request/admin/assignticket_request.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/admin/assignticket_response.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/admin/getstaff_service.dart';
import 'package:schoolworkspro_app/services/admin/ticket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';

class AdminRequestDetailScreen extends StatefulWidget {
  final title;

  AdminRequestDetailScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _AdminRequestDetailScreenState createState() =>
      _AdminRequestDetailScreenState();
}

class _AdminRequestDetailScreenState extends State<AdminRequestDetailScreen> {
  User? user;
  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];
  Icon cusIcon = const Icon(Icons.search);
  late Widget cusSearchBar;
  final TextEditingController _searchController = TextEditingController();
  bool menubarloading = false;
  String? department;
  String? staff;
  String? staff_username;
  List<dynamic> department_list = <dynamic>[];
  List<dynamic> staff_list = <dynamic>[];
  bool assignloading = false;

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
    if (menubarloading == true) {
      customLoadStart();
    } else if (menubarloading == false) {
      customLoadStop();
    } else if (assignloading == true) {
      customLoadStart();
    } else if (assignloading == false) {
      customLoadStop();
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          title:
              Text(widget.title, style: const TextStyle(color: Colors.black)),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         setState(() {
          //           if (this.cusIcon.icon == Icons.search) {
          //             this.cusIcon = Icon(
          //               Icons.cancel,
          //               color: Colors.grey,
          //             );
          //             this.cusSearchBar = TextField(
          //               autofocus: true,
          //               textInputAction: TextInputAction.go,
          //               controller: _searchController,
          //               decoration: const InputDecoration(
          //                   hintText: 'Search by topic',
          //                   border: InputBorder.none),
          //               onChanged: (text) {
          //                 setState(() {
          //                   _listForDisplay = _list.where((list) {
          //                     var itemName = list.name!.toLowerCase();
          //                     return itemName.contains(text);
          //                   }).toList();
          //                 });
          //               },
          //             );
          //           } else {
          //             this.cusIcon = Icon(Icons.search);
          //
          //             this.cusSearchBar = Text(
          //               widget.title,
          //               style: TextStyle(color: Colors.black),
          //             );
          //           }
          //         });
          //       },
          //       icon: cusIcon)
          // ],
          backgroundColor: Colors.white,
        ),
        body: ChangeNotifierProvider<AssignedRequestService>(
            create: (context) => AssignedRequestService(),
            child: Consumer<AssignedRequestService>(
                builder: (context, provider, child) {
              provider.getassignedrequest(context, user?.username.toString());
              if (provider.data?.requests == null) {
                provider.getassignedrequest(context, user?.username.toString());
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
                                    if (widget.title == "Request") {
                                      try {
                                        return Text(
                                          provider.data!.backlog!.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text("0");
                                        // TODO
                                      }
                                    } else {
                                      try {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                      ['subject'] ==
                                                  widget.title &&
                                              provider.data!.requests![i]
                                                      ['status'] ==
                                                  "Backlog") count++;

                                        return Text(
                                          count.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text("0");
                                        // TODO
                                      }
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
                                    if (widget.title == "Request") {
                                      try {
                                        return Text(
                                          provider.data!.pending.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        // TODO
                                        return Text("0");
                                      }
                                    } else {
                                      try {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                      ['subject'] ==
                                                  widget.title &&
                                              provider.data!.requests![i]
                                                      ['status'] ==
                                                  "Pending") count++;

                                        return Text(
                                          count.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text("0");
                                        // TODO
                                      }
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
                                    if (widget.title == "Request") {
                                      try {
                                        return Text(
                                          provider.data!.approved.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text('0');
                                        // TODO
                                      }
                                    } else {
                                      try {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                      ['subject'] ==
                                                  widget.title &&
                                              provider.data!.requests![i]
                                                      ['status'] ==
                                                  "Approved") count++;

                                        return Text(
                                          count.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text("0");
                                        // TODO
                                      }
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
                                const Text(
                                  'Resolved',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    if (widget.title == "Request") {
                                      try {
                                        return Text(
                                          provider.data!.resolved.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        // TODO
                                        return const Text("0");
                                      }
                                    } else {
                                      try {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                      ['subject'] ==
                                                  widget.title &&
                                              provider.data!.requests![i]
                                                      ['status'] ==
                                                  "Resolved") count++;

                                        return Text(
                                          count.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } on Exception catch (e) {
                                        return Text("0");
                                        // TODO
                                      }
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

                      return ticket['subject'] == widget.title ||
                              widget.title == "Request"
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IndividualRequestDetail(
                                              id: ticket['_id']),
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
                                              margin: const EdgeInsets.only(
                                                  left: 15),
                                              decoration: BoxDecoration(
                                                  color: ticket['status'] ==
                                                          "Resolved"
                                                      ? Colors.green
                                                      : ticket['status'] ==
                                                              "Pending"
                                                          ? Colors.orange
                                                          : ticket['status'] ==
                                                                  "Approved"
                                                              ? Colors.green
                                                              : Colors.orange,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              30.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                    ticket['status'] ==
                                                            "Resolved"
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
                                            title: Text(
                                                ticket['topic'].toString()),
                                            trailing: PopupMenuButton<String>(
                                              onSelected: (value) async {
                                                if (value == menubar5.backlog) {
                                                  try {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    final data =
                                                        AdminChangeTicketStatusRequest(
                                                            status: "Backlog");

                                                    AdminChangeTicketStatusResponse
                                                        response =
                                                        await AssignedRequestService()
                                                            .updateStatus(data,
                                                                ticket['_id']);

                                                    if (response.success ==
                                                        true) {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Status changed successfully"),
                                                          color: Colors.green,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: const Text(
                                                              "Error while changing status"),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    }
                                                  } on Exception catch (e) {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        content:
                                                            Text(e.toString()),
                                                        color: Colors.red,
                                                        duration: 1,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating);
                                                    setState(() {
                                                      menubarloading = false;
                                                    });
                                                    // TODO
                                                  }

                                                  // Navigator.of(context).pushNamed(Paymentinfo.routeName);
                                                } else if (value ==
                                                    menubar5.to_do) {
                                                  try {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    final data =
                                                        AdminChangeTicketStatusRequest(
                                                            status: "Pending");

                                                    AdminChangeTicketStatusResponse
                                                        response =
                                                        await AssignedRequestService()
                                                            .updateStatus(data,
                                                                ticket['_id']);

                                                    if (response.success ==
                                                        true) {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Status changed successfully"),
                                                          color: Colors.green,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Error while changing status"),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    }
                                                  } on Exception catch (e) {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        content:
                                                            Text(e.toString()),
                                                        color: Colors.red,
                                                        duration: 1,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating);
                                                    setState(() {
                                                      menubarloading = false;
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
                                                      menubarloading = true;
                                                    });
                                                    final data =
                                                        AdminChangeTicketStatusRequest(
                                                            status: "Approved");

                                                    AdminChangeTicketStatusResponse
                                                        response =
                                                        await AssignedRequestService()
                                                            .updateStatus(data,
                                                                ticket['_id']);

                                                    if (response.success ==
                                                        true) {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Status changed successfully"),
                                                          color: Colors.green,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Error while changing status"),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    }
                                                  } on Exception catch (e) {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        content:
                                                            Text(e.toString()),
                                                        color: Colors.red,
                                                        duration: 1,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating);
                                                    setState(() {
                                                      menubarloading = false;
                                                    });
                                                    // TODO
                                                  }
                                                  // Navigator.of(context).pushNamed(PaymentSettlement.routeName);
                                                } else if (value ==
                                                    menubar5.done) {
                                                  try {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    final data =
                                                        AdminChangeTicketStatusRequest(
                                                            status: "Resolved");

                                                    AdminChangeTicketStatusResponse
                                                        response =
                                                        await AssignedRequestService()
                                                            .updateStatus(data,
                                                                ticket['_id']);

                                                    if (response.success ==
                                                        true) {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Status changed successfully"),
                                                          color: Colors.green,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        menubarloading = true;
                                                      });
                                                      snackThis(
                                                          context: context,
                                                          content: Text(
                                                              "Error while changing status"),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                      setState(() {
                                                        menubarloading = false;
                                                      });
                                                    }
                                                  } on Exception catch (e) {
                                                    setState(() {
                                                      menubarloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        content:
                                                            Text(e.toString()),
                                                        color: Colors.red,
                                                        duration: 1,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating);
                                                    setState(() {
                                                      menubarloading = false;
                                                    });
                                                    // TODO
                                                  }
                                                  // Navigator.of(context).pushNamed(PaymentSettlement.routeName);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return menubar5.settings
                                                    .map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(choice),
                                                  );
                                                }).toList();
                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0),
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
                                                      child: Text(
                                                          ticket['ticketId']
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
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                ticket['request'].toString(),
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                          'Requested By:'),
                                                      Text(provider.data?.requests?[
                                                                      index]
                                                                  ['postedBy']
                                                              ['firstname'] +
                                                          " " +
                                                          provider.data?.requests?[
                                                                      index]
                                                                  ['postedBy']
                                                              ['lastname']),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Assigned To:'),
                                                      Text(provider.data?.requests?[
                                                                      index]
                                                                  ['assignedTo']
                                                              ['firstname'] +
                                                          " " +
                                                          provider.data?.requests?[
                                                                      index]
                                                                  ['assignedTo']
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
                                                  provider.data?.requests?[
                                                                  index]
                                                              ['status'] ==
                                                          "Resolved"
                                                      ? SizedBox()
                                                      : TextButton(
                                                          child: const Text(
                                                              'Assign Ticket'),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            setState) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Select Department"),
                                                                    content:
                                                                        SizedBox(
                                                                      height: department ==
                                                                              null
                                                                          ? 130
                                                                          : 180,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Builder(builder: (context) {
                                                                              final jsonList = department_list.map((e) => e).toList();

                                                                              final uniqueJsonList = jsonList.toSet().toList();

                                                                              final result = uniqueJsonList.map((e) => e).toList();

                                                                              return DropdownButton(
                                                                                  value: department,
                                                                                  items: result.map((pt) {
                                                                                    return DropdownMenuItem(
                                                                                      value: pt,
                                                                                      child: Text(pt),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (newVal) async {
                                                                                    setState(() {
                                                                                      department = newVal.toString();
                                                                                      staff_list.clear();
                                                                                    });

                                                                                    final result = await StaffService().getStaff();
                                                                                    for (int i = 0; i < result.users!.length; i++) {
                                                                                      if (result.users![i]['type'] == department) {
                                                                                        setState(() {
                                                                                          staff = null;

                                                                                          staff_list.add(result.users![i]);
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  hint: Text("Select department"));

                                                                              // return DropdownButtonFormField(
                                                                              //   value: department,
                                                                              //   items: result
                                                                              //       .map(
                                                                              //           (pt) {
                                                                              //     return DropdownMenuItem(
                                                                              //       value: pt,
                                                                              //       child: Text(
                                                                              //           pt),
                                                                              //     );
                                                                              //   }).toList(),
                                                                              //   onChanged:
                                                                              //       (newVal) async {
                                                                              //     setState(
                                                                              //         () {
                                                                              //       // print(newVal);
                                                                              //           department == null;
                                                                              //           staff ==
                                                                              //               null;
                                                                              //           staff_list
                                                                              //               .clear();
                                                                              //       department =
                                                                              //           newVal
                                                                              //               as String?;
                                                                              //
                                                                              //
                                                                              //
                                                                              //
                                                                              //       // project_type = newVal;
                                                                              //     });
                                                                              //
                                                                              //     final result =
                                                                              //         await StaffService()
                                                                              //             .getStaff();
                                                                              //     for (int i =
                                                                              //             0;
                                                                              //         i < result.users!.length;
                                                                              //         i++) {
                                                                              //       if (result.users![i]
                                                                              //               [
                                                                              //               'type'] ==
                                                                              //           department) {
                                                                              //         setState(
                                                                              //             () {
                                                                              //           staff_list
                                                                              //               .add(result.users![i]);
                                                                              //         });
                                                                              //       }
                                                                              //     }
                                                                              //   },
                                                                              //   icon: const Icon(
                                                                              //       Icons
                                                                              //           .arrow_drop_down_outlined),
                                                                              //   decoration:
                                                                              //       const InputDecoration(
                                                                              //     border:
                                                                              //         InputBorder
                                                                              //             .none,
                                                                              //     filled:
                                                                              //         true,
                                                                              //     hintText:
                                                                              //         'Select subject',
                                                                              //   ),
                                                                              // );
                                                                            }),
                                                                          ),
                                                                          department == null
                                                                              ? const SizedBox()
                                                                              : Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: DropdownButton(
                                                                                      value: staff,
                                                                                      items: staff_list.map((pt) {
                                                                                        return DropdownMenuItem(value: pt['username'], child: Text(pt['firstname'] + " " + pt['lastname']));
                                                                                      }).toList(),
                                                                                      onChanged: (newVal) {
                                                                                        setState(() {
                                                                                          staff = newVal.toString();
                                                                                        });
                                                                                      },
                                                                                      hint: Text("Select staffs"))
                                                                                  //     DropdownButtonFormField(
                                                                                  //   value:
                                                                                  //       staff,
                                                                                  //   items: staff_list
                                                                                  //       .map(
                                                                                  //           (pt) {
                                                                                  //     return DropdownMenuItem(
                                                                                  //         value: pt[
                                                                                  //             'firstname'],
                                                                                  //         child: Text(pt['firstname'] +
                                                                                  //             " " +
                                                                                  //             pt['lastname']));
                                                                                  //   }).toList(),
                                                                                  //   onChanged:
                                                                                  //       (newVal) {
                                                                                  //     setState(
                                                                                  //         () {
                                                                                  //       // print(newVal);
                                                                                  //       staff =
                                                                                  //           newVal as String?;
                                                                                  //
                                                                                  //       // project_type = newVal;
                                                                                  //     });
                                                                                  //   },
                                                                                  //   icon: const Icon(
                                                                                  //       Icons
                                                                                  //           .arrow_drop_down_outlined),
                                                                                  //   decoration:
                                                                                  //       const InputDecoration(
                                                                                  //     border:
                                                                                  //         InputBorder.none,
                                                                                  //     filled:
                                                                                  //         true,
                                                                                  //     hintText:
                                                                                  //         'Select staff',
                                                                                  //   ),
                                                                                  // )
                                                                                  ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  )),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              TextButton(
                                                                                  onPressed: () async {
                                                                                    try {
                                                                                      setState(() {
                                                                                        assignloading = true;
                                                                                      });
                                                                                      final data = AssignSupportTicketRequest(assignedDate: DateTime.now(), assignedTo: staff.toString());
                                                                                      AssignTicketResponse res = await AdminTicketService().assignTicket(data, provider.data?.requests?[index]['_id']);
                                                                                      if (res.success == true) {
                                                                                        setState(() {
                                                                                          assignloading = true;
                                                                                        });
                                                                                        Navigator.of(context).pop();
                                                                                        Fluttertoast.showToast(msg: "Ticket assigned to ${staff.toString()}");
                                                                                        setState(() {
                                                                                          assignloading = false;
                                                                                        });
                                                                                      } else {
                                                                                        setState(() {
                                                                                          assignloading = true;
                                                                                        });
                                                                                        Fluttertoast.showToast(msg: "Failed assigning ticket to ${staff.toString()}");
                                                                                        setState(() {
                                                                                          assignloading = false;
                                                                                        });
                                                                                      }
                                                                                    } on Exception catch (e) {
                                                                                      setState(() {
                                                                                        assignloading = true;
                                                                                      });
                                                                                      Fluttertoast.showToast(msg: "${e.toString()}");
                                                                                      setState(() {
                                                                                        assignloading = false;
                                                                                      });

                                                                                      // TODO
                                                                                    }
                                                                                  },
                                                                                  child: const Text('Confirm')),
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
                            )
                          : SizedBox();
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
