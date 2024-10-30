import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/request/lecturer/logistics_feedback.dart';
import 'package:schoolworkspro_app/response/lecturer/respondlogistics_response.dart';
import 'package:schoolworkspro_app/services/lecturer/allinventory_service.dart';
import 'package:schoolworkspro_app/services/lecturer/alllogistics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/fonts.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';
import '../../my_learning/tab_button.dart';

class UpdatelogisticsInventory extends StatefulWidget {
  const UpdatelogisticsInventory({Key? key}) : super(key: key);

  @override
  _UpdatelogisticsInventoryState createState() =>
      _UpdatelogisticsInventoryState();
}

class _UpdatelogisticsInventoryState extends State<UpdatelogisticsInventory>
    with TickerProviderStateMixin {
  User? user;
  // int _selectedPage = 0;
  final TextEditingController feedbackcontroller = TextEditingController();
  late PageController _pageController;
  bool isloadingFeedback = false;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  late TabController _tabController;
  bool isloading = false;

  @override
  void initState() {

    _pageController = PageController();

    getData();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
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
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            'Update Request',
            style: TextStyle(color: white),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Builder(builder: (context) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TabBar(
                  indicatorColor: logoTheme,
                  indicatorWeight: 4.0,
                  // isScrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  unselectedLabelColor: white,
                  labelColor: Color(0xff004D96),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: p1),
                  indicator: BoxDecoration(
                    border: Border(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: white,
                  ),
                  tabs: [
                    Tab(
                      text: "Logistics",
                    ),
                    Tab(
                      text: "Inventory",
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider<AllLogisticsService>(
                create: (context) => AllLogisticsService(),
                child: Consumer<AllLogisticsService>(
                    builder: (context, provider, child) {
                  provider.getLogistics(context);
                  if (provider.data2?.allLogistics == null) {
                    provider.getLogistics(context);
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  return provider.data2!.allLogistics!.isEmpty
                      ? Column(children: <Widget>[
                          Image.asset("assets/images/no_content.PNG"),
                          const Text(
                            "No data available",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ])
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.data2?.allLogistics?.length,
                          itemBuilder: (context, index) {
                            var inventory =
                                provider.data2?.allLogistics?[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Name : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Expanded(
                                          child: Text(
                                              inventory['user']['firstname'] +
                                                  " " +
                                                  inventory['user']['lastname'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 17.0)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Name : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Expanded(
                                          child: Text(
                                              inventory['module']['moduleTitle']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 17.0)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Status : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Expanded(
                                          child: Text(
                                              inventory['status'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 17.0,
                                                  color: inventory['status'] ==
                                                          "Approved"
                                                      ? Colors.green
                                                      : inventory['status'] ==
                                                              "Declined"
                                                          ? Colors.red
                                                          : inventory['status'] ==
                                                                  "Pending"
                                                              ? const Color(
                                                                  0xffC8A800)
                                                              : Colors.yellow)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DataTable(
                                      horizontalMargin: 0,
                                      columns: const [
                                        DataColumn(
                                            label: Text(
                                              'Item name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            tooltip: 'Item name'),
                                        DataColumn(
                                            label: Text(
                                              'Quantity',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            tooltip: 'Quantity'),
                                      ],
                                      rows: inventory['inventoryRequested']
                                          .map<DataRow>(
                                              (data) => DataRow(cells: [
                                                    DataCell(Text(
                                                      data['item']['item_name'],
                                                    )),
                                                    DataCell(Text(
                                                      data['quantity'],
                                                    )),
                                                  ]))
                                          .toList(),
                                    ),
                                    const Text("Project Type : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                    inventory['project_type'].toLowerCase() ==
                                            "individual"
                                        ? Text(inventory['project_type'])
                                        : inventory['project_type'] == ""
                                            ? const SizedBox()
                                            : ExpansionTile(
                                                initiallyExpanded: false,
                                                title: Text(
                                                    inventory['project_type']),
                                                children:
                                                    inventory['student_list']
                                                        .map<Widget>(
                                                            (studentName) {
                                                  return ListTile(
                                                      title: Text(studentName));
                                                }).toList(),
                                              ),
                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              try {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                final res =
                                                    await AllLogisticsService()
                                                        .approveRequest(
                                                            inventory['_id'],"Approved");
                                                if (res.success == true) {
                                                  setState(() {
                                                    isloading = true;
                                                  });

                                                  provider.getLogistics(context);
                                                  snackThis(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    duration: 1,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                }
                                                else {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  snackThis(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    duration: 1,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.red,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                }
                                              } catch (e) {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                snackThis(
                                                  duration: 1,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                );
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff006400),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.check,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text('Accept',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width:5),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              try {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                final res =
                                                    await AllLogisticsService()
                                                        .approveRequest(
                                                            inventory['_id'], "Declined");
                                                if (res.success == true) {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  snackThis(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    duration: 1,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  snackThis(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    duration: 1,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.red,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                }
                                              } catch (e) {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                snackThis(
                                                  duration: 1,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                );
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE80000),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.close,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text('Reject',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width:5),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              Widget cancelButton = TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('CANCEL'));
                                              // set up the button
                                              Widget okButton = TextButton(
                                                child: const Text("OK"),
                                                onPressed: () async {
                                                  try {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    final res =
                                                        await AllLogisticsService()
                                                            .deleteRequest(
                                                                inventory[
                                                                    '_id']);
                                                    if (res.success == true) {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      provider.getLogistics(context);
                                                      Navigator.of(context)
                                                          .pop();
                                                      snackThis(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        context: context,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()),
                                                        color: Colors.green,
                                                      );
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                      snackThis(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        context: context,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()),
                                                        color: Colors.red,
                                                      );
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    }
                                                  } catch (e) {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    Navigator.of(context).pop();
                                                    snackThis(
                                                      duration: 1,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      context: context,
                                                      content:
                                                          Text(e.toString()),
                                                      color: Colors.red,
                                                    );
                                                    setState(() {
                                                      isloading = false;
                                                    });
                                                  }
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                content: Text(
                                                    "Are you sure, you want to delete this request ?"),
                                                actions: [
                                                  cancelButton,
                                                  okButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE80000),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.delete,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text('Delete',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Logistics Request Feedback"),
                                                content: SizedBox(
                                                  height: inventory['feedback']
                                                          .isEmpty
                                                      ? 200
                                                      : 350,
                                                  width: double.maxFinite,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            feedbackcontroller,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Write something...',
                                                          filled: true,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.green)),
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .always,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15.0,
                                                                    top: 15.0),
                                                            child: SizedBox(
                                                              height: 40,
                                                              width: 95,
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .white),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(18.0),
                                                                        ))),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15.0,
                                                                    top: 15.0),
                                                            child: SizedBox(
                                                              height: 40,
                                                              width: 95,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    setState(
                                                                        () {
                                                                      isloadingFeedback =
                                                                          true;
                                                                    });
                                                                    final request =
                                                                        LogisticFeedbackRequest(
                                                                            feedback:
                                                                                Feedback(
                                                                      postedBy: user
                                                                          ?.email
                                                                          .toString(),
                                                                      feedback:
                                                                          feedbackcontroller
                                                                              .text,
                                                                    ));
                                                                    RespondLogisticsResponse
                                                                        res =
                                                                        await AllLogisticsService().postFeedback(
                                                                            request,
                                                                            inventory['_id']);
                                                                    setState(
                                                                        () {
                                                                      isloadingFeedback =
                                                                          true;
                                                                    });
                                                                    if (res.success ==
                                                                        true) {
                                                                      setState(
                                                                          () {
                                                                        isloadingFeedback =
                                                                            true;
                                                                      });
                                                                      feedbackcontroller
                                                                          .clear();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg: res
                                                                            .message
                                                                            .toString(),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        isloadingFeedback =
                                                                            false;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        isloadingFeedback =
                                                                            true;
                                                                      });
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg: res
                                                                            .message
                                                                            .toString(),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        isloadingFeedback =
                                                                            false;
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      isloadingFeedback =
                                                                          true;
                                                                    });
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg: e
                                                                          .toString(),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      isloadingFeedback =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .blue),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(18.0),
                                                                        ))),
                                                                child:
                                                                    const Text(
                                                                  "Save",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              ListView.builder(
                                                                itemCount:
                                                                    inventory[
                                                                            'feedback']
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    ScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                        i) {
                                                                  var nameInital = inventory['feedback'][i]['firstname']
                                                                              [
                                                                              0]
                                                                          .toUpperCase() +
                                                                      "" +
                                                                      inventory['feedback'][i]['lastname']
                                                                              [
                                                                              0]
                                                                          .toUpperCase();

                                                                  var fullname = inventory['feedback']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'firstname'] +
                                                                      " " +
                                                                      inventory['feedback']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'lastname'];
                                                                  return ListTile(
                                                                    title: Text(
                                                                        inventory['feedback'][i]
                                                                            [
                                                                            'feedback']),
                                                                    subtitle: Text(
                                                                        fullname),
                                                                    leading:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      child:
                                                                          Text(
                                                                        nameInital,
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff004D96),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.message,
                                              color: white,
                                            ),
                                            SizedBox(width: 2),
                                            Text('Respond',
                                                style: TextStyle(
                                                    color: white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                })),
            ChangeNotifierProvider<AllInventoryService>(
                create: (context) => AllInventoryService(),
                child: Consumer<AllInventoryService>(
                    builder: (context, provider, child) {
                  provider.getinventory(context);
                  if (provider.data?.allInventory == null) {
                    provider.getinventory(context);
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  return provider.data!.allInventory!.isEmpty
                      ? Column(children: <Widget>[
                          Image.asset("assets/images/no_content.PNG"),
                          const Text(
                            "No data available",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ])
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.data?.allInventory?.length,
                          itemBuilder: (context, index) {
                            var datas = provider.data?.allInventory?[index];

                            return Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Name : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Text(
                                          datas['user']['firstname'] +
                                              " " +
                                              datas['user']['lastname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17.0),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Module : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Expanded(
                                          child: Text(
                                              datas["module"]["moduleTitle"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 17.0)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Status : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)),
                                        Text(
                                          datas["status"].toString(),
                                          style: TextStyle(
                                              color:
                                                  datas["status"] == "Approved"
                                                      ? Colors.green
                                                      : Color(0xff8B8000),
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // GFListTile(
                                    //   icon: Chip(
                                    //     labelPadding:
                                    //         const EdgeInsets.symmetric(
                                    //             horizontal: 5),
                                    //     backgroundColor: datas['status'] ==
                                    //             "Approved"
                                    //         ? Colors.green
                                    //         : datas['status'] == "Declined"
                                    //             ? Colors.red
                                    //             : Colors.yellow,
                                    //     label: Text(
                                    //       datas['status'],
                                    //       style: TextStyle(
                                    //           color: datas['status'] ==
                                    //                   "Approved"
                                    //               ? Colors.white
                                    //               : datas['status'] ==
                                    //                       "Declined"
                                    //                   ? Colors.white
                                    //                   : Colors.black,
                                    //           fontSize: 12),
                                    //     ),
                                    //   ),
                                    //   avatar: Text('${index + 1}'.toString()),
                                    //   title: Text(
                                    //       datas['module']['moduleTitle']),
                                    //   subTitle: Text(datas['user']
                                    //           ['firstname'] +
                                    //       " " +
                                    //       datas['user']['lastname']),
                                    // ),

                                    DataTable(
                                      horizontalMargin: 0,
                                      columns: const [
                                        DataColumn(
                                            label: Text(
                                              'Item name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            tooltip: 'Item name'),
                                      ],
                                      rows: datas['inventoryRequested']
                                          .map<DataRow>(
                                              (data) => DataRow(cells: [
                                                    DataCell(Text(
                                                      data,
                                                    )),
                                                  ]))
                                          .toList(),
                                    ),

                                    const Text("Project Type : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    datas['project_type'].toLowerCase() ==
                                            "individual"
                                        ? Text(datas['project_type'])
                                        : datas['project_type'] == ""
                                            ? const SizedBox(
                                                height: 1,
                                              )
                                            : ExpansionTile(
                                                initiallyExpanded: false,
                                                title:
                                                    Text(datas['project_type']),
                                                children: datas['student_list']
                                                    .map<Widget>((studentName) {
                                                  return ListTile(
                                                      title: Text(studentName));
                                                }).toList(),
                                              ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          onTap: () async {
                                            try {
                                              setState(() {
                                                isloading = true;
                                              });
                                              final res =
                                                  await AllInventoryService()
                                                      .approveRequest(
                                                          datas['_id']);
                                              if (res.success == true) {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                snackThis(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  context: context,
                                                  duration: 1,
                                                  content: Text(
                                                      res.message.toString()),
                                                  color: Colors.green,
                                                );
                                                setState(() {
                                                  isloading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                snackThis(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  context: context,
                                                  duration: 1,
                                                  content: Text(
                                                      res.message.toString()),
                                                  color: Colors.red,
                                                );
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }
                                            } catch (e) {
                                              setState(() {
                                                isloading = true;
                                              });
                                              snackThis(
                                                duration: 1,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                context: context,
                                                content: Text(e.toString()),
                                                color: Colors.red,
                                              );
                                              setState(() {
                                                isloading = false;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: const Color(0xff006400),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.check,
                                                  color: white,
                                                ),
                                                SizedBox(width: 2),
                                                Text('Accept',
                                                    style: TextStyle(
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        )),
                                        SizedBox(width:5),
                                        // IconButton(
                                        //     onPressed: () async {
                                        //       try {
                                        //         setState(() {
                                        //           isloading = true;
                                        //         });
                                        //         final res =
                                        //         await AllInventoryService()
                                        //             .approveRequest(
                                        //             datas['_id']);
                                        //         if (res.success == true) {
                                        //           setState(() {
                                        //             isloading = true;
                                        //           });
                                        //           snackThis(
                                        //             behavior: SnackBarBehavior
                                        //                 .floating,
                                        //             context: context,
                                        //             duration: 1,
                                        //             content: Text(res.message
                                        //                 .toString()),
                                        //             color: Colors.green,
                                        //           );
                                        //           setState(() {
                                        //             isloading = false;
                                        //           });
                                        //         } else {
                                        //           setState(() {
                                        //             isloading = true;
                                        //           });
                                        //           snackThis(
                                        //             behavior: SnackBarBehavior
                                        //                 .floating,
                                        //             context: context,
                                        //             duration: 1,
                                        //             content: Text(res.message
                                        //                 .toString()),
                                        //             color: Colors.red,
                                        //           );
                                        //           setState(() {
                                        //             isloading = false;
                                        //           });
                                        //         }
                                        //       } catch (e) {
                                        //         setState(() {
                                        //           isloading = true;
                                        //         });
                                        //         snackThis(
                                        //           duration: 1,
                                        //           behavior: SnackBarBehavior
                                        //               .floating,
                                        //           context: context,
                                        //           content: Text(e.toString()),
                                        //           color: Colors.red,
                                        //         );
                                        //         setState(() {
                                        //           isloading = false;
                                        //         });
                                        //       }
                                        //     },
                                        //     icon: const Icon(
                                        //       Icons.check_circle,
                                        //       color: Colors.green,
                                        //     )),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              try {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                final res =
                                                    await AllInventoryService()
                                                        .declineRequest(
                                                            datas['_id']);
                                                if (res.success == true) {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  snackThis(
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  snackThis(
                                                    duration: 1,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    context: context,
                                                    content: Text(
                                                        res.message.toString()),
                                                    color: Colors.red,
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                }
                                              } catch (e) {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                snackThis(
                                                  duration: 1,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  context: context,
                                                  content: Text(e.toString()),
                                                  color: Colors.red,
                                                );
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE80000),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.close,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text('Reject',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width:5),
                                        // InkWell(
                                        //   onTap: () async {
                                        //     try {
                                        //       setState(() {
                                        //         isloading = true;
                                        //       });
                                        //       final res =
                                        //       await AllInventoryService()
                                        //           .declineRequest(
                                        //           datas['_id']);
                                        //       if (res.success == true) {
                                        //         setState(() {
                                        //           isloading = true;
                                        //         });
                                        //         snackThis(
                                        //           duration: 1,
                                        //           behavior: SnackBarBehavior
                                        //               .floating,
                                        //           context: context,
                                        //           content: Text(
                                        //               res.message.toString()),
                                        //           color: Colors.green,
                                        //         );
                                        //         setState(() {
                                        //           isloading = false;
                                        //         });
                                        //       } else {
                                        //         setState(() {
                                        //           isloading = true;
                                        //         });
                                        //         snackThis(
                                        //           duration: 1,
                                        //           behavior: SnackBarBehavior
                                        //               .floating,
                                        //           context: context,
                                        //           content: Text(
                                        //               res.message.toString()),
                                        //           color: Colors.red,
                                        //         );
                                        //         setState(() {
                                        //           isloading = false;
                                        //         });
                                        //       }
                                        //     } catch (e) {
                                        //       setState(() {
                                        //         isloading = true;
                                        //       });
                                        //       snackThis(
                                        //         duration: 1,
                                        //         behavior:
                                        //         SnackBarBehavior.floating,
                                        //         context: context,
                                        //         content: Text(e.toString()),
                                        //         color: Colors.red,
                                        //       );
                                        //       setState(() {
                                        //         isloading = false;
                                        //       });
                                        //     }
                                        //   },
                                        //   child: Container(
                                        //       height: 20,
                                        //       width: 20,
                                        //       decoration: const BoxDecoration(
                                        //         color: Colors.red,
                                        //         borderRadius:
                                        //         BorderRadius.all(
                                        //           Radius.circular(40),
                                        //         ),
                                        //       ),
                                        //       child: const Icon(
                                        //         Icons.clear,
                                        //         size: 20,
                                        //         color: Colors.white,
                                        //       )),
                                        // ),

                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              Widget cancelButton = TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('CANCEL'));
                                              // set up the button
                                              Widget okButton = TextButton(
                                                child: const Text("OK"),
                                                onPressed: () async {
                                                  try {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    final res =
                                                        await AllInventoryService()
                                                            .deleteRequest(
                                                                datas['_id']);
                                                    if (res.success == true) {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                      snackThis(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        context: context,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()),
                                                        color: Colors.green,
                                                      );
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                      snackThis(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        context: context,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()),
                                                        color: Colors.red,
                                                      );
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    }
                                                  } catch (e) {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    Navigator.of(context).pop();
                                                    snackThis(
                                                      duration: 1,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      context: context,
                                                      content:
                                                          Text(e.toString()),
                                                      color: Colors.red,
                                                    );
                                                    setState(() {
                                                      isloading = false;
                                                    });
                                                  }
                                                },
                                              );

                                              // set up the AlertDialog
                                              AlertDialog alert = AlertDialog(
                                                content: Text(
                                                    "Are you sure, you want to delete this request ?"),
                                                actions: [
                                                  cancelButton,
                                                  okButton,
                                                ],
                                              );

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE80000),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.delete,
                                                    color: white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text('Delete',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // IconButton(
                                        //     onPressed: () async {
                                        //       Widget cancelButton = TextButton(
                                        //           onPressed: () {
                                        //             Navigator.of(context).pop();
                                        //           },
                                        //           child: const Text('CANCEL'));
                                        //       // set up the button
                                        //       Widget okButton = TextButton(
                                        //         child: const Text("OK"),
                                        //         onPressed: () async {
                                        //           try {
                                        //             setState(() {
                                        //               isloading = true;
                                        //             });
                                        //             final res =
                                        //                 await AllInventoryService()
                                        //                     .deleteRequest(
                                        //                         datas['_id']);
                                        //             if (res.success == true) {
                                        //               setState(() {
                                        //                 isloading = true;
                                        //               });
                                        //               Navigator.of(context)
                                        //                   .pop();
                                        //               snackThis(
                                        //                 behavior:
                                        //                     SnackBarBehavior
                                        //                         .floating,
                                        //                 context: context,
                                        //                 duration: 1,
                                        //                 content: Text(res
                                        //                     .message
                                        //                     .toString()),
                                        //                 color: Colors.green,
                                        //               );
                                        //               setState(() {
                                        //                 isloading = false;
                                        //               });
                                        //             } else {
                                        //               setState(() {
                                        //                 isloading = true;
                                        //               });
                                        //               Navigator.of(context)
                                        //                   .pop();
                                        //               snackThis(
                                        //                 behavior:
                                        //                     SnackBarBehavior
                                        //                         .floating,
                                        //                 context: context,
                                        //                 duration: 1,
                                        //                 content: Text(res
                                        //                     .message
                                        //                     .toString()),
                                        //                 color: Colors.red,
                                        //               );
                                        //               setState(() {
                                        //                 isloading = false;
                                        //               });
                                        //             }
                                        //           } catch (e) {
                                        //             setState(() {
                                        //               isloading = true;
                                        //             });
                                        //             Navigator.of(context).pop();
                                        //             snackThis(
                                        //               duration: 1,
                                        //               behavior: SnackBarBehavior
                                        //                   .floating,
                                        //               context: context,
                                        //               content:
                                        //                   Text(e.toString()),
                                        //               color: Colors.red,
                                        //             );
                                        //             setState(() {
                                        //               isloading = false;
                                        //             });
                                        //           }
                                        //         },
                                        //       );
                                        //
                                        //       // set up the AlertDialog
                                        //       AlertDialog alert = AlertDialog(
                                        //         content: Text(
                                        //             "Are you sure, you want to delete this request ?"),
                                        //         actions: [
                                        //           cancelButton,
                                        //           okButton,
                                        //         ],
                                        //       );
                                        //
                                        //       // show the dialog
                                        //       showDialog(
                                        //         context: context,
                                        //         builder:
                                        //             (BuildContext context) {
                                        //           return alert;
                                        //         },
                                        //       );
                                        //     },
                                        //     icon: const Icon(
                                        //       Icons.delete,
                                        //       color: Colors.red,
                                        //     )),

                                        // ElevatedButton(
                                        //     style: ButtonStyle(
                                        //         backgroundColor:
                                        //             MaterialStateProperty.all(
                                        //                 Colors.blue),
                                        //         shape: MaterialStateProperty.all<
                                        //                 RoundedRectangleBorder>(
                                        //             RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   18.0),
                                        //         ))),
                                        //     onPressed: () {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder:
                                        //             (BuildContext context) {
                                        //           return StatefulBuilder(
                                        //               builder:
                                        //                   (context, setState) {
                                        //             return AlertDialog(
                                        //               title: const Text(
                                        //                   "Logistics Request Feedback"),
                                        //               content: SizedBox(
                                        //                 height:
                                        //                     datas['feedback']
                                        //                             .isEmpty
                                        //                         ? 200
                                        //                         : 350,
                                        //                 width: double.maxFinite,
                                        //                 child: Column(
                                        //                   mainAxisAlignment:
                                        //                       MainAxisAlignment
                                        //                           .start,
                                        //                   crossAxisAlignment:
                                        //                       CrossAxisAlignment
                                        //                           .start,
                                        //                   children: [
                                        //                     TextFormField(
                                        //                       controller:
                                        //                           feedbackcontroller,
                                        //                       keyboardType:
                                        //                           TextInputType
                                        //                               .text,
                                        //                       decoration:
                                        //                           const InputDecoration(
                                        //                         hintText:
                                        //                             'Write something...',
                                        //                         filled: true,
                                        //                         enabledBorder: OutlineInputBorder(
                                        //                             borderSide:
                                        //                                 BorderSide(
                                        //                                     color:
                                        //                                         Colors.grey)),
                                        //                         focusedBorder: OutlineInputBorder(
                                        //                             borderSide:
                                        //                                 BorderSide(
                                        //                                     color:
                                        //                                         Colors.green)),
                                        //                         floatingLabelBehavior:
                                        //                             FloatingLabelBehavior
                                        //                                 .always,
                                        //                       ),
                                        //                     ),
                                        //                     Row(
                                        //                       mainAxisAlignment:
                                        //                           MainAxisAlignment
                                        //                               .center,
                                        //                       crossAxisAlignment:
                                        //                           CrossAxisAlignment
                                        //                               .center,
                                        //                       children: <
                                        //                           Widget>[
                                        //                         Padding(
                                        //                           padding: const EdgeInsets
                                        //                                   .only(
                                        //                               left:
                                        //                                   15.0,
                                        //                               top:
                                        //                                   15.0),
                                        //                           child:
                                        //                               SizedBox(
                                        //                             height: 40,
                                        //                             width: 95,
                                        //                             child:
                                        //                                 ElevatedButton(
                                        //                               style: ButtonStyle(
                                        //                                   backgroundColor: MaterialStateProperty.all(Colors.white),
                                        //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        //                                     borderRadius:
                                        //                                         BorderRadius.circular(18.0),
                                        //                                   ))),
                                        //                               onPressed:
                                        //                                   () {
                                        //                                 Navigator.pop(
                                        //                                     context);
                                        //                               },
                                        //                               child: const Text(
                                        //                                   "Cancel",
                                        //                                   style: TextStyle(
                                        //                                       fontSize: 14,
                                        //                                       color: Colors.black)),
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                         Padding(
                                        //                           padding: const EdgeInsets
                                        //                                   .only(
                                        //                               left:
                                        //                                   15.0,
                                        //                               top:
                                        //                                   15.0),
                                        //                           child:
                                        //                               SizedBox(
                                        //                             height: 40,
                                        //                             width: 95,
                                        //                             child:
                                        //                                 ElevatedButton(
                                        //                               onPressed:
                                        //                                   () async {
                                        //                                 try {
                                        //                                   setState(
                                        //                                       () {
                                        //                                     isloadingFeedback =
                                        //                                         true;
                                        //                                   });
                                        //                                   final request = LogisticFeedbackRequest(
                                        //                                       feedback: Feedback(
                                        //                                     postedBy:
                                        //                                         user?.email.toString(),
                                        //                                     feedback:
                                        //                                         feedbackcontroller.text,
                                        //                                   ));
                                        //                                   RespondLogisticsResponse
                                        //                                       res =
                                        //                                       await AllInventoryService().postFeedback(request, datas['_id']);
                                        //                                   setState(
                                        //                                       () {
                                        //                                     isloadingFeedback =
                                        //                                         true;
                                        //                                   });
                                        //                                   if (res.success ==
                                        //                                       true) {
                                        //                                     setState(() {
                                        //                                       isloadingFeedback = true;
                                        //                                     });
                                        //                                     feedbackcontroller.clear();
                                        //                                     Navigator.of(context).pop();
                                        //                                     Fluttertoast.showToast(
                                        //                                       msg: res.message.toString(),
                                        //                                     );
                                        //                                     setState(() {
                                        //                                       isloadingFeedback = false;
                                        //                                     });
                                        //                                   } else {
                                        //                                     setState(() {
                                        //                                       isloadingFeedback = true;
                                        //                                     });
                                        //                                     Fluttertoast.showToast(
                                        //                                       msg: res.message.toString(),
                                        //                                     );
                                        //                                     setState(() {
                                        //                                       isloadingFeedback = false;
                                        //                                     });
                                        //                                   }
                                        //                                 } catch (e) {
                                        //                                   setState(
                                        //                                       () {
                                        //                                     isloadingFeedback =
                                        //                                         true;
                                        //                                   });
                                        //                                   Fluttertoast
                                        //                                       .showToast(
                                        //                                     msg:
                                        //                                         e.toString(),
                                        //                                   );
                                        //                                   setState(
                                        //                                       () {
                                        //                                     isloadingFeedback =
                                        //                                         false;
                                        //                                   });
                                        //                                 }
                                        //                               },
                                        //                               style: ButtonStyle(
                                        //                                   backgroundColor: MaterialStateProperty.all(Colors.blue),
                                        //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        //                                     borderRadius:
                                        //                                         BorderRadius.circular(18.0),
                                        //                                   ))),
                                        //                               child:
                                        //                                   const Text(
                                        //                                 "Save",
                                        //                                 style: TextStyle(
                                        //                                     fontSize:
                                        //                                         14,
                                        //                                     color:
                                        //                                         Colors.white),
                                        //                               ),
                                        //                             ),
                                        //                           ),
                                        //                         )
                                        //                       ],
                                        //                     ),
                                        //                     SizedBox(
                                        //                       height: 10,
                                        //                     ),
                                        //                     Expanded(
                                        //                       child:
                                        //                           SingleChildScrollView(
                                        //                         child: Column(
                                        //                           children: [
                                        //                             ListView
                                        //                                 .builder(
                                        //                               itemCount:
                                        //                                   datas['feedback']
                                        //                                       .length,
                                        //                               shrinkWrap:
                                        //                                   true,
                                        //                               physics:
                                        //                                   ScrollPhysics(),
                                        //                               itemBuilder:
                                        //                                   (context,
                                        //                                       i) {
                                        //                                 var nameInital = datas['feedback'][i]['firstname'][0].toUpperCase() +
                                        //                                     "" +
                                        //                                     datas['feedback'][i]['lastname'][0].toUpperCase();
                                        //
                                        //                                 var fullname = datas['feedback'][i]['firstname'] +
                                        //                                     " " +
                                        //                                     datas['feedback'][i]['lastname'];
                                        //                                 return ListTile(
                                        //                                   title:
                                        //                                       Text(datas['feedback'][i]['feedback']),
                                        //                                   subtitle:
                                        //                                       Text(fullname),
                                        //                                   leading:
                                        //                                       CircleAvatar(
                                        //                                     backgroundColor:
                                        //                                         Colors.grey,
                                        //                                     child:
                                        //                                         Text(
                                        //                                       nameInital,
                                        //                                       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        //                                     ),
                                        //                                   ),
                                        //                                 );
                                        //                               },
                                        //                             ),
                                        //                           ],
                                        //                         ),
                                        //                       ),
                                        //                     )
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //             );
                                        //           });
                                        //         },
                                        //       );
                                        //     },
                                        //     child: const Text('Respond')),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return StatefulBuilder(
                                                builder:
                                                    (context, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Logistics Request Feedback"),
                                                    content: SizedBox(
                                                      height:
                                                      datas['feedback']
                                                          .isEmpty
                                                          ? 200
                                                          : 350,
                                                      width: double.maxFinite,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          TextFormField(
                                                            controller:
                                                            feedbackcontroller,
                                                            keyboardType:
                                                            TextInputType
                                                                .text,
                                                            decoration:
                                                            const InputDecoration(
                                                              hintText:
                                                              'Write something...',
                                                              filled: true,
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                      Colors.grey)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                      Colors.green)),
                                                              floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .always,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: <
                                                                Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    15.0,
                                                                    top:
                                                                    15.0),
                                                                child:
                                                                SizedBox(
                                                                  height: 40,
                                                                  width: 95,
                                                                  child:
                                                                  ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(18.0),
                                                                        ))),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    15.0,
                                                                    top:
                                                                    15.0),
                                                                child:
                                                                SizedBox(
                                                                  height: 40,
                                                                  width: 95,
                                                                  child:
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        setState(
                                                                                () {
                                                                              isloadingFeedback =
                                                                              true;
                                                                            });
                                                                        final request = LogisticFeedbackRequest(
                                                                            feedback: Feedback(
                                                                              postedBy:
                                                                              user?.email.toString(),
                                                                              feedback:
                                                                              feedbackcontroller.text,
                                                                            ));
                                                                        RespondLogisticsResponse
                                                                        res =
                                                                        await AllInventoryService().postFeedback(request, datas['_id']);
                                                                        setState(
                                                                                () {
                                                                              isloadingFeedback =
                                                                              true;
                                                                            });
                                                                        if (res.success ==
                                                                            true) {
                                                                          setState(() {
                                                                            isloadingFeedback = true;
                                                                          });
                                                                          feedbackcontroller.clear();
                                                                          Navigator.of(context).pop();
                                                                          Fluttertoast.showToast(
                                                                            msg: res.message.toString(),
                                                                          );
                                                                          setState(() {
                                                                            isloadingFeedback = false;
                                                                          });
                                                                        } else {
                                                                          setState(() {
                                                                            isloadingFeedback = true;
                                                                          });
                                                                          Fluttertoast.showToast(
                                                                            msg: res.message.toString(),
                                                                          );
                                                                          setState(() {
                                                                            isloadingFeedback = false;
                                                                          });
                                                                        }
                                                                      } catch (e) {
                                                                        setState(
                                                                                () {
                                                                              isloadingFeedback =
                                                                              true;
                                                                            });
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                          e.toString(),
                                                                        );
                                                                        setState(
                                                                                () {
                                                                              isloadingFeedback =
                                                                              false;
                                                                            });
                                                                      }
                                                                    },
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(18.0),
                                                                        ))),
                                                                    child:
                                                                    const Text(
                                                                      "Save",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          14,
                                                                          color:
                                                                          Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Expanded(
                                                            child:
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .builder(
                                                                    itemCount:
                                                                    datas['feedback']
                                                                        .length,
                                                                    shrinkWrap:
                                                                    true,
                                                                    physics:
                                                                    ScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                        i) {
                                                                      var nameInital = datas['feedback'][i]['firstname'][0].toUpperCase() +
                                                                          "" +
                                                                          datas['feedback'][i]['lastname'][0].toUpperCase();

                                                                      var fullname = datas['feedback'][i]['firstname'] +
                                                                          " " +
                                                                          datas['feedback'][i]['lastname'];
                                                                      return ListTile(
                                                                        title:
                                                                        Text(datas['feedback'][i]['feedback']),
                                                                        subtitle:
                                                                        Text(fullname),
                                                                        leading:
                                                                        CircleAvatar(
                                                                          backgroundColor:
                                                                          Colors.grey,
                                                                          child:
                                                                          Text(
                                                                            nameInital,
                                                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff004D96),
                                            borderRadius:
                                            BorderRadius.circular(4)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.message,
                                              color: white,
                                            ),
                                            SizedBox(width: 2),
                                            Text('Respond',
                                                style: TextStyle(
                                                    color: white,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                })),
          ],
        ),
      ),
    );
  }
}
