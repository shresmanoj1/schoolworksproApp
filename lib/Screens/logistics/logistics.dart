import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/logistics_request.dart';
import 'package:schoolworkspro_app/response/accessedmodule_response.dart';
import 'package:schoolworkspro_app/response/inventory_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/logisticsstudent_response.dart';
import 'package:schoolworkspro_app/services/accessedmodule_service.dart';
import 'package:schoolworkspro_app/services/accessedstudent_service.dart';
import 'package:schoolworkspro_app/services/addlogistics_service.dart';
import 'package:schoolworkspro_app/services/inventory_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';

class Logisticscreen extends StatefulWidget {
  const Logisticscreen({Key? key}) : super(key: key);

  @override
  _LogisticscreenState createState() => _LogisticscreenState();
}

class _LogisticscreenState extends State<Logisticscreen>
    with TickerProviderStateMixin {
  bool visibility = true;
  double height = 190;
  int position = 1;
  Future<Inventoryresponse>? _inventoryModel;
  Future<Accessedmoduleresponse>? _accessedModule;
  Future<LogisticsStudent>? _accessedStudent;
  AnimationController? _controller;

  static const List<IconData> icons = [Icons.remove_red_eye, Icons.help];
  String? _mySelection;
  bool individual = false;
  var userStudent = <bool>[];
  bool selectStudent = false;
  bool checkedValue = false;
  List<Module> modules = <Module>[];
  List<Student> student = <Student>[];
  Student? logisticsStudent;
  final ScrollController _scrollController = ScrollController();
  String? type;
  List projectType = ["Individual", "Group"];

  List<Inventory> _list = <Inventory>[];
  List<Inventory> _listForDisplay = <Inventory>[];
  TextEditingController? _searchController;
  User? user;

  bool incrementVisibilty = true;
  bool decrementVisibility = true;

  LogisticsRequest? data;
  String? moduleSlug;
  String? project_type;
  String status = "Pending";
  List<Inventory>? inventoryRequested;
  List? ind;
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

  @override
  void initState() {
    selectedStudent = [];
    inventoryRequested = [];
    ind = [];
    student = [];
    logisticsStudent = Student();
    getData();
    getuserData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          setState(() {
            position = 1;
          });
        } else {
          setState(() {
            position = 0;
          });
        }
      }
    });
  }

  getuserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    _accessedModule =
        Accessedmoduleservice().getAccessedModule(user?.batch.toString());
    _accessedStudent =
        AccessedStudentService().getAccessedStudent(user?.batch.toString());
  }

  getData() async {
    final data = await Inventoryservice().getInventory();
    final items =
        await Accessedmoduleservice().getAccessedModule(user?.batch.toString());
    final students = await AccessedStudentService()
        .getAccessedStudent(user?.batch.toString());

    for (int j = 0; j < students.students!.length; j++) {
      setState(() {
        student.add(students.students![j]);
      });
    }
    for (int index = 0; index < items.modules!.length; index++) {
      setState(() {
        modules.add(items.modules![index]);
      });
    }

    for (int i = 0; i < data.inventory!.length; i++) {
      setState(() {
        _list.add(data.inventory![i]);
        _listForDisplay = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          _searchBar(),
          _listForDisplay.length > 0
              ? ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return _listItem(index);
                  },
                  itemCount: _listForDisplay.length,
                )
              : Image.asset("assets/images/no_content.PNG"),
          SizedBox(
            height: 75,
          ),
        ],
      ),
    ));
  }

  _searchBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 1),
                  // vsync: this,
                  child: Container(
                    height: visibility ? null : height,
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
                          isExpanded: true,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: 'Select a Module',
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: modules.map((item) {
                            return DropdownMenuItem(
                              value: item.moduleSlug,
                              child: Text(
                                item.moduleTitle!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState(() {
                              _mySelection = newVal;
                              moduleSlug = newVal;
                            });
                          },
                          value: _mySelection,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Project type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          hint: const Text('Select project type'),
                          value: type,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            // border: InputBorder.none,
                            filled: true,
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: projectType.map((pt) {
                            return DropdownMenuItem(
                              value: pt,
                              child: Text(pt),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              type = newVal as String?;
                              project_type = newVal;
                            });
                            if (type == "Individual") {
                              setState(() {
                                selectedStudent.clear();
                                height = 200;
                                individual = false;
                              });
                            } else {
                              setState(() {
                                height = 150;
                                individual = true;
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        individual == false
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: individual,
                                      child: Column(
                                        children: const [
                                          Text(
                                            "select students",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                  Visibility(
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: individual,
                                    child: MultiSelectDialogField(
                                      items: student
                                          .map((e) => MultiSelectItem(
                                              e.firstname! + " " + e.lastname!,
                                              e.firstname! + " " + e.lastname!))
                                          .toList(),
                                      listType: MultiSelectListType.CHIP,
                                      initialValue: selectedStudent,
                                      autovalidateMode: AutovalidateMode.always,
                                      onConfirm: (List<String?> values) {
                                        setState(() {
                                          selectedStudent = values;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
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

                  final datass = LogisticsRequest(
                      moduleSlug: moduleSlug,
                      projectType: project_type,
                      status: status,
                      studentList: selectedStudent.toList(),
                      inventoryRequested: ind!.toList());

                  if (_mySelection == null) {
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.warning,
                      title: "Module slug can't be empty",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: const Color.fromRGBO(91, 55, 185, 1.0),
                          radius: BorderRadius.circular(10.0),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ).show();
                  } else if (type == null) {
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.warning,
                      title: "Project type can't be empty",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: const Color.fromRGBO(91, 55, 185, 1.0),
                          radius: BorderRadius.circular(10.0),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ).show();
                  } else if (selectedStudent.isEmpty && individual == true) {
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.warning,
                      title: "please select group members",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: const Color.fromRGBO(91, 55, 185, 1.0),
                          radius: BorderRadius.circular(10.0),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ).show();
                  } else if (ind!.isEmpty) {
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.warning,
                      title: "please select atleast one item",
                      buttons: [
                        DialogButton(
                          color: const Color.fromRGBO(91, 55, 185, 1.0),
                          radius: BorderRadius.circular(10.0),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    ).show();
                  } else {
                    final rez = await AddLogisticService().addLogistics(datass);
                    if (rez.success == true) {
                      Alert(
                        context: context,
                        style: alertStyle,
                        type: AlertType.success,
                        title: rez.message,
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Ok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: const Color.fromRGBO(91, 55, 185, 1.0),
                            radius: BorderRadius.circular(10.0),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ).show();
                    } else {
                      Alert(
                        context: context,
                        style: alertStyle,
                        type: AlertType.success,
                        title: rez.message,
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Ok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: const Color.fromRGBO(91, 55, 185, 1.0),
                            radius: BorderRadius.circular(10.0),
                            onPressed: () async {},
                          ),
                        ],
                      ).show();
                    }
                  }
                },
                child: const Text("Request Logistics",
                    style: TextStyle(fontSize: 14, color: white)),
              ),
            )
          ],
        ),
      ]),
    );
  }

  _listItem(index) {
    _listForDisplay[index].counter! <= 0
        ? decrementVisibility = false
        : decrementVisibility = true;

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              _listForDisplay[index].itemName ?? "",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                        fontSize: 16.0, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
