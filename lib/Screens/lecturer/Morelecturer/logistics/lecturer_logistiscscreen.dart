import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/logistics/view_lecturerlogisticsreen.dart';
import 'package:schoolworkspro_app/request/lecturer/get_modulerequest.dart';
import 'package:schoolworkspro_app/response/inventory_response.dart';
import 'package:schoolworkspro_app/services/addlogistics_service.dart';
import 'package:schoolworkspro_app/services/inventory_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../request/logistics_request.dart';
import '../../../../response/accessedmodule_response.dart';
import '../../../../response/authenticateduser_response.dart';
import '../../../../services/lecturer/getmodule_service.dart';
import '../../../widgets/snack_bar.dart';

class LogisticsLecturerScreen extends StatefulWidget {
  const LogisticsLecturerScreen({Key? key}) : super(key: key);

  @override
  _LogisticsLecturerScreenState createState() =>
      _LogisticsLecturerScreenState();
}

class _LogisticsLecturerScreenState extends State<LogisticsLecturerScreen>
    with TickerProviderStateMixin {
  bool visibility = true;
  double height = 190;
  int position = 1;
  Future<Inventoryresponse>? _inventoryModel;
  Future<Accessedmoduleresponse>? _accessedModule;
  // Future<LogisticsStudent>? _accessedStudent;
  AnimationController? _controller;

  static const List<IconData> icons = [Icons.remove_red_eye, Icons.help];
  String? _mySelection;
  bool individual = false;
  var userStudent = <bool>[];
  bool selectStudent = false;
  bool checkedValue = false;
  List<dynamic> modules = <dynamic>[];
  // List<Student> student = <Student>[];
  // Student? logisticsStudent;
  final ScrollController _scrollController = ScrollController();
  String? type;
  String? selected_module;
  List projectType = ["Individual", "Group"];
  List? ind;

  List<Inventory> _list = <Inventory>[];
  List<Inventory> _listForDisplay = <Inventory>[];
  TextEditingController? _searchController;
  User? user;

  bool incrementVisibilty = true;
  bool decrementVisibility = true;

  // LogisticsRequest? data;
  String? moduleSlug;
  String? project_type;
  String status = "Approved";
  List<Inventory>? inventoryRequested;
  bool isloading = false;

  List<String?> selectedStudent = [];
  var alertStyle = AlertStyle(
    overlayColor: Colors.blue,
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text(
    'Request Logistics',
    style: TextStyle(color: white),
  );
  bool _showBackToTopButton = false;

  // TextEditingController _searchController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    selectedStudent = [];
    inventoryRequested = [];
    ind = [];
    // student = [];
    // logisticsStudent = Student();
    // getData();
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
    final data = Getmodulerequest(email: user!.email.toString());
    final res = await ModuleServiceLecturer().getmodules(data);
    for (int index = 0; index < res.lecturer!.modules!.length; index++) {
      setState(() {
        modules.add(res.lecturer?.modules?[index]);
      });
    }
    getData();
  }

  getData() async {
    final data = await Inventoryservice().getInventory();

    // print(student[0]);

    for (int i = 0; i < data.inventory!.length; i++) {
      setState(() {
        _list.add(data.inventory![i]);
        _listForDisplay = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color backgroundColor = Theme.of(context).cardColor;
    // Color foregroundColor = Theme.of(context).accentColor;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            'Logistics',
            style: TextStyle(color: white),
          ),
          // iconTheme: const IconThemeData(
          //   color: Colors.black, //change your color here
          // ),
          // backgroundColor: Colors.white,
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
                      text: "Add Logistics",
                    ),
                    Tab(
                      text: "View Logistics",
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _searchBar(),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Item Name", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold),),
                    ],),
                ),
                _listForDisplay.length > 0
                    ?  ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return
                      // _listItem(index - 1);
                      index == 0 ? Container() : _listItem(index - 1);
                  },
                  itemCount: _listForDisplay.length + 1,
                ) : Image.asset("assets/images/no_content.PNG"),
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
            //   : const Center(
            // child: CupertinoActivityIndicator(),
          // ),
          const ViewLogisticsLecturerScreen()
        ],)
      ),
    );
  }

  _searchBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Module",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                hint: const Text('Select a module'),
                value: type,
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                ),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                items: modules.map((pt) {
                  return DropdownMenuItem(
                    value: pt['moduleSlug'],
                    child: Text(pt['moduleTitle'],softWrap: true, overflow: TextOverflow.ellipsis,),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    // print(newVal);
                    selected_module = newVal as String?;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "search items...",
                        fillColor: white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _listForDisplay = _list.where((list) {
                            var itemName = list.itemName!.toLowerCase();
                            return itemName.contains(text);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 12.5, horizontal: 2)),
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xffCF407F)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () async {
                        for (int i = 0; i < _listForDisplay.length; i++) {
                          if (_listForDisplay[i].counter! > 0) {
                            setState(() {
                              ind!.add(InventoryRequested(
                                  item: Item(id: _listForDisplay[i].id.toString()),
                                  quantity: _listForDisplay[i].counter.toString()));
                            });
                          }
                        }

                        if (selected_module == null) {
                          snackThis(
                              context: context,
                              content: Text("Please select module"),
                              color: Colors.red,
                              duration: 1,
                              behavior: SnackBarBehavior.floating);
                        }
                        else if (ind!.isEmpty) {
                          snackThis(
                              context: context,
                              content: Text("Please select atleast one item"),
                              color: Colors.red,
                              duration: 1,
                              behavior: SnackBarBehavior.floating);
                        }
                        else {
                          // print('ok');
                          try {
                            final datass = LogisticsRequest(
                                moduleSlug: selected_module,
                                projectType: "",
                                status: status,
                                studentList: [],
                                inventoryRequested: ind!.toList());

                            // inspect(datass);

                            final rez = await AddLogisticService().addLogistics(datass);
                            if (rez.success == true) {
                              snackThis(
                                  context: context,
                                  content: Text(rez.message.toString()),
                                  color: Colors.green,
                                  duration: 1,
                                  behavior: SnackBarBehavior.floating);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => super.widget));
                            } else {
                              snackThis(
                                  context: context,
                                  content: Text(rez.message.toString()),
                                  color: Colors.red,
                                  duration: 1,
                                  behavior: SnackBarBehavior.floating);
                            }
                          } catch (e) {
                            snackThis(
                                context: context,
                                content: Text(e.toString()),
                                color: Colors.red,
                                duration: 1,
                                behavior: SnackBarBehavior.floating);
                          }
                        }
                      },
                      child: const Text("Request Logistics",
                          style: TextStyle(fontSize: 14, color: white)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       TextButton(
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => ViewLogisticsLecturerScreen()),
        //             );
        //           },
        //           child: Row(
        //             children: [
        //               Icon(Icons.visibility),
        //               SizedBox(
        //                 width: 7,
        //               ),
        //               Text('View logistics request'),
        //             ],
        //           ))
        //     ],
        //   ),
        // )
      ],
    );
  }

  _listItem(index) {
    _listForDisplay[index].counter! <= 0
        ? decrementVisibility = false
        : decrementVisibility = true;

    // _listForDisplay[index].counter>0
    return Column(
      children: [
        ListTile(
          title: Text(
            _listForDisplay[index].itemName!,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: Wrap(
            spacing: 12,
            children: [
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: incrementVisibilty,
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: black,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: white,
                      size: 22,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _listForDisplay[index].counter =
                          _listForDisplay[index].counter! + 1;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${_listForDisplay[index].counter}',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: decrementVisibility,
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: black,
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: white,
                      size: 22,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _listForDisplay[index].counter =
                          _listForDisplay[index].counter! - 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
