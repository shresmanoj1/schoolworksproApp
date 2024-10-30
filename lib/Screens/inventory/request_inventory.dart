import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutter_tags/flutter_tags.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/request/inventory_request.dart';
import 'package:schoolworkspro_app/response/accessedmodule_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/logisticsstudent_response.dart';
import 'package:schoolworkspro_app/services/accessedmodule_service.dart';
import 'package:schoolworkspro_app/services/accessedstudent_service.dart';
import 'package:schoolworkspro_app/services/addinventory_service.dart';
import 'package:schoolworkspro_app/services/inventory_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requestinventory extends StatefulWidget {
  const Requestinventory({Key? key}) : super(key: key);

  @override
  _RequestinventoryState createState() => _RequestinventoryState();
}

class _RequestinventoryState extends State<Requestinventory>
    with TickerProviderStateMixin {
  Future<Accessedmoduleresponse>? _accessedModule;

  Future<LogisticsStudent>? _accessedStudent;
  List<Module> modules = <Module>[];
  List<Student> student = <Student>[];
  double height = 200;
  List<String> itemName = <String>[];
  String? project_type;
  User? user;
  bool visibility = true;
  String? _mySelection;
  String? type;
  String? moduleSlug;
  bool individual = false;
  List<String?>? selectedStudent;
  List projectType = ["individual", "group"];
  // final GlobalKey<TagsState> _globalKey = GlobalKey<TagsState>();
  TextEditingController _itemController = new TextEditingController();
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
    // TODO: implement initState
    student = [];
    itemName = [];
    selectedStudent = [];
    getData();
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

    _accessedModule = Accessedmoduleservice().getAccessedModule(user!.batch!);
    _accessedStudent =
        AccessedStudentService().getAccessedStudent(user!.batch!);
  }

  getData() async {
    final data = await Inventoryservice().getInventory();
    final items = await Accessedmoduleservice().getAccessedModule(user!.batch!);
    final students =
        await AccessedStudentService().getAccessedStudent(user!.batch!);

    for (int j = 0; j < students.students!.length; j++) {
      setState(() {
        student.add(students.students![j]);
      });
    }
    // print(student[0]);
    for (int index = 0; index < items.modules!.length; index++) {
      setState(() {
        modules.add(items.modules![index]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
              child: AnimatedSize(
                duration: const Duration(seconds: 1),
                // ignore: deprecated_member_use
                // vsync: this,
                child: Container(
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
                        // isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          // border: InputBorder.none,
                          hintText: 'Select a Module',
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: modules.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item.moduleTitle!,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: item.moduleSlug,
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _mySelection = newVal as String?;
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
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          // border: InputBorder.none,
                          // filled: true,
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
                            // print(newVal);
                            type = newVal as String?;
                            project_type = newVal;
                          });
                          if (type == "individual") {
                            setState(() {
                              selectedStudent!.clear();
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
                          :
                      Column(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: individual,
                          child: MultiSelectDialogField(
                            // validator: ,
                            items: student
                                .map((e) => MultiSelectItem(
                                e.firstname! + " " + e.lastname!,
                                e.firstname! + " " + e.lastname!))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            initialValue: selectedStudent!,
                            autovalidateMode: AutovalidateMode.always,
                            onConfirm: (values) {
                              setState(() {
                                selectedStudent = values.cast<String>();
                              });
                            },
                          ),
                        ),
                      ],),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(onPressed: () async {
                          String status = "Pending";
                          final datas = InventoryRequest(
                              status: status,
                              moduleSlug: moduleSlug,
                              projectType: project_type,
                              inventoryRequested: itemName,
                              studentList: selectedStudent);

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
                          } else if (selectedStudent!.isEmpty && individual == true) {
                            Alert(
                              context: context,
                              style: alertStyle,
                              type: AlertType.warning,
                              title: "please select group members",
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
                          } else if (itemName.isEmpty) {
                            Alert(
                              context: context,
                              style: alertStyle,
                              type: AlertType.warning,
                              title: "please add atleast one item",
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
                            final req = await Addinventoryservice()
                                .addInventoryRequest(datas);

                            if (req.success == true) {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.success,
                                title: req.message,
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //         super.widget));
                                    },
                                  ),
                                ],
                              ).show();
                            } else {
                              Alert(
                                context: context,
                                style: alertStyle,
                                type: AlertType.warning,
                                title: req.message,
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    color: const Color.fromRGBO(91, 55, 185, 1.0),
                                    radius: BorderRadius.circular(10.0),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            }
                          }
                          // print(Item(title: itemName.toString()));
                        },
                            style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xffCF407F)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),

                            child: const Text("Request Inventory")),
                      ),


                      const Text(
                        "Item name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: _itemController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Enter and add item you want to request',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                            backgroundColor:
                            MaterialStateProperty.all(logoTheme),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                        onPressed: () async {
                          _itemController.text.isEmpty
                              ? Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType.warning,
                                  title: "Item name can't be empty",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "Ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      color: const Color.fromRGBO(
                                          91, 55, 185, 1.0),
                                      radius: BorderRadius.circular(10.0),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ).show()
                              :
                              // Fluttertoast.showToast(msg: 'hey');
                              setState(() {
                                  itemName.add(_itemController.text);
                                  _itemController.clear();
                                  FocusScopeNode cf = FocusScope.of(context);
                                  if (!cf.hasPrimaryFocus &&
                                      cf.focusedChild != null) {
                                    cf.focusedChild!.unfocus();
                                    cf.unfocus();
                                  }
                                  // _itemController.
                                });
                        },
                        child: const Text("Add"),
                      ),
                      for (int i = 0; i < itemName.length; i++)
                        Chip(
                            backgroundColor: kPrimaryColor,
                            deleteButtonTooltipMessage: "click to remove",
                            onDeleted: () {
                              setState(() {
                                itemName.remove(itemName[i]);
                              });
                            },
                            deleteIconColor: Colors.red,
                            deleteIcon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            label: Text(
                              itemName[i],
                              style: const TextStyle(color: Colors.white),
                            )),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
