import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/inventory/view_lecturerinventoryscreen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/inventory_request.dart';
import 'package:schoolworkspro_app/response/accessedmodule_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/logisticsstudent_response.dart';
import 'package:schoolworkspro_app/services/addinventory_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/custom_loader.dart';
import '../../../../request/lecturer/get_modulerequest.dart';
import '../../../../services/lecturer/getmodule_service.dart';
import '../../../widgets/snack_bar.dart';

class LecturerRequestinventory extends StatefulWidget {
  const LecturerRequestinventory({Key? key}) : super(key: key);

  @override
  _LecturerRequestinventoryState createState() =>
      _LecturerRequestinventoryState();
}

class _LecturerRequestinventoryState extends State<LecturerRequestinventory>
    with TickerProviderStateMixin {
  Future<Accessedmoduleresponse>? _accessedModule;

  Future<LogisticsStudent>? _accessedStudent;
  List<dynamic> modules = <dynamic>[];
  List<Student> student = <Student>[];
  double height = 200;
  List<String> itemName = <String>[];
  String? project_type;
  bool isloading = false;
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
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request new Inventory',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        const ViewinventoryrequestLecturer())));
          },
          label: Row(
            children: const [
              Icon(Icons.visibility),
            ],
          )),

      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   curve: Curves.fastLinearToSlowEaseIn,
      //   closeManually: false,
      //   children: [
      //     SpeedDialChild(
      //         child: const Icon(Icons.remove_red_eye),
      //         label: "View Inventory request",
      //         // backgroundColor: Colors.transparent,
      //         onTap: () =>
      //             Navigator.pushNamed(context, '/viewinventoryrequest')),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintText: 'Select a Module',
                  ),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  items: modules.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item['moduleTitle'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: item['moduleSlug'],
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
                SizedBox(
                  height: 10,
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
                    hintText: 'Enter and add item you want to request',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                ElevatedButton(
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
                                color: const Color.fromRGBO(91, 55, 185, 1.0),
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
                            if (!cf.hasPrimaryFocus && cf.focusedChild != null) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String status = "Approved";
                              final datas = InventoryRequest(
                                  status: status,
                                  moduleSlug: moduleSlug,
                                  projectType: "",
                                  inventoryRequested: itemName,
                                  studentList: []);

                              if (_mySelection == null) {
                                snackThis(
                                    context: context,
                                    content: const Text("Please select module"),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                              } else if (itemName.isEmpty) {
                                snackThis(
                                    context: context,
                                    content: const Text(
                                        "Enter item name and click on add to request inventory"),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                              } else {
                                final req = await Addinventoryservice()
                                    .addInventoryRequest(datas);

                                setState(() {
                                  isloading = true;
                                });
                                if (req.success == true) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  snackThis(
                                      context: context,
                                      content: Text(req.message.toString()),
                                      color: Colors.green,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget));
                                  setState(() {
                                    isloading = false;
                                  });
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  snackThis(
                                      context: context,
                                      content: Text(req.message.toString()),
                                      color: Colors.red,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              }
                            } catch (e) {
                              snackThis(
                                  context: context,
                                  content: Text(e.toString()),
                                  color: Colors.red,
                                  duration: 1,
                                  behavior: SnackBarBehavior.floating);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          child: const Text(
                            "Request",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
