import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/collaboration_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/edit_task_page.dart';
import 'package:schoolworkspro_app/Screens/widgets/common_button_widget.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/helper/custom_loader.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/create_sub_group_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api/repositories/collaboration_repo.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../response/authenticateduser_response.dart';
import '../../../response/collaboration_group_response.dart' hide User;
import '../../../response/remove_editor_response.dart';
import '../../widgets/snack_bar.dart';
import 'package:html/dom.dart' as dom;

class CollaborationTabScreen extends StatefulWidget {
  final String moduleId;

  const CollaborationTabScreen({Key? key, required this.moduleId})
      : super(key: key);

  @override
  State<CollaborationTabScreen> createState() => _CollaborationTabScreenState();
}

class _CollaborationTabScreenState extends State<CollaborationTabScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabController2;
  String? color_selection;
  TextEditingController _titleController = TextEditingController();
  late CollaborationViewModel _provider;
  late CommonViewModel _provider2;
  bool isloading = false;
  User? user;
  String? userId;
  bool checkUser = false;
  bool checkBoxValue = false;
  List<String> students = <String>[];
  List<String> selectStudent = <String>[];
  String? selectedBatch;
  List<dynamic> finalList = [];
  List<dynamic> studentsUsername = [];

  @override
  void initState() {
    _tabController =
        TabController(length: myTabs2.length, vsync: this, initialIndex: 0);
    _tabController2 = TabController(length: 3, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CollaborationViewModel>(context, listen: false);
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      refreshPage(provider: _provider);
      finalList.clear();
      selectedBatch = null;
    });
    getUser();
    super.initState();
  }

  Future<void> refreshPage({required CollaborationViewModel provider}) async {
    // await _provider.fetchAllTask(widget.groupValue!.id.toString());
    await _provider.fetchAllTask(widget.moduleId);
    // await _provider2.fetchStudentformarking(user!.batch.toString());
    await _provider.fetchAssignmentBatch(widget.moduleId);
  }

  @override
  void dispose() {
    selectedBatch = null;
    _titleController.dispose();
    super.dispose();
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    String? _userId = sharedPreferences.getString('userId');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
      userId = _userId;
    });
  }

  final List<Tab> myTabs2 = <Tab>[
    const Tab(text: 'Backlog'),
    const Tab(text: 'To Do'),
    const Tab(text: 'In Progress'),
    const Tab(text: 'Done'),
  ];
  String? _storeKey;
  int _activeIndex = 0;
  List<String> listValues = [
    "GREEN",
    "BLUE",
    "RED",
    "YELLOW",
    "PURPLE",
    "GREY",
    "PINK",
  ];
  int? tabIndex;

  @override
  Widget build(BuildContext context) {
    _tabController2.addListener(() {
      if (_tabController2.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController2.index;
        });
      }
    });
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }

    return Consumer2<CollaborationViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: false,
              title: isLoading(value.allTaskApiResponse)
                  ? const SizedBox()
                  : Text(value.allTask.moduleGroup["groupName"].toString(),
                      style: const TextStyle(
                          color: white, fontWeight: FontWeight.w800)),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: white,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TabBar(
                      indicatorColor: logoTheme,
                      indicatorWeight: 4.0,
                      isScrollable: true,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      unselectedLabelColor: white,
                      labelColor: const Color(0xff004D96),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: p1),
                      indicator: const BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        color: white,
                      ),
                      controller: _tabController2,
                      tabs: const [
                        Tab(
                            child: Row(
                          children: [
                            Icon(
                              Icons.border_all_rounded,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Table",
                            ),
                          ],
                        )),
                        Tab(
                            child: Row(
                          children: [
                            Icon(
                              Icons.table_chart,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Board",
                            ),
                          ],
                        )),
                        Tab(
                            child: Row(
                          children: [
                            Icon(
                              Icons.people_alt_sharp,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("Members")
                          ],
                        )),
                      ],
                    ),
                  );
                }),
              ),
              backgroundColor: logoTheme),
          body: isLoading(value.allTaskApiResponse)
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => refreshPage(provider: value),
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController2,
                    children: <Widget>[
                      _buildTableCard(value),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                    value: checkBoxValue,
                                    onChanged: (value2) {
                                      setState(() {
                                        checkBoxValue = value2!;
                                      });
                                    }),
                                const Text("Show my tickets")
                              ],
                            ),
                          ),
                          TabBar(
                            isScrollable: true,
                            unselectedLabelColor: black,
                            labelColor: logoTheme,
                            indicatorColor: logoTheme,
                            padding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: EdgeInsets.zero,
                            indicatorWeight: 4,
                            tabs: myTabs2,
                            controller: _tabController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Builder(builder: (context) {
                              return TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildBoardTaskCard(value, "Backlog"),
                                  _buildBoardTaskCard(value, "Pending"),
                                  _buildBoardTaskCard(value, "Approved"),
                                  _buildBoardTaskCard(value, "Resolved"),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                      _buildGroupMember(value, common),
                    ],
                  )),
          floatingActionButton: _activeIndex == 1
              ? FloatingActionButton.extended(
                  backgroundColor: user?.type == "Lecturer" ||
                          value.allTask.moduleGroup["hasEdit"].contains(userId)
                      ? Colors.green
                      : Colors.grey,
                  onPressed: user?.type == "Lecturer" ||
                          value.allTask.moduleGroup["hasEdit"].contains(userId)
                      ? () {
                          Map<String, dynamic> mapValue = {
                            "keyId": _storeKey,
                            "users": value.allTask.moduleGroup["users"],
                            "assignedToList": "",
                            "isUpdate": false
                          };
                          Navigator.pushNamed(context, '/create/task',
                                  arguments: mapValue)
                              .then((_) {
                            refreshPage(provider: value);
                          });
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  label: const Text("Create Task"))
              : null,
        ),
      );
    });
  }

  Widget _buildTableCard(CollaborationViewModel value) {
    return RefreshIndicator(
      onRefresh: () => refreshPage(provider: value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CommonButton(
                    text: "Create Task Group",
                    fontSize: 14,
                    color: user?.type == "Lecturer" ||
                            value.allTask.moduleGroup["hasEdit"]
                                .contains(userId)
                        ? const Color(0xff38853B)
                        : Colors.grey,
                    textColor: white,
                    onTap: user?.type == "Lecturer" ||
                            value.allTask.moduleGroup["hasEdit"]
                                .contains(userId)
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      height: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Create A Task Group",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text("Title",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            validator: (text1) {
                                              if (text1 == null ||
                                                  text1.isEmpty) {
                                                return 'Please enter title';
                                              }
                                              return null;
                                            },
                                            controller: _titleController,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            decoration: const InputDecoration(
                                              hintText: '# Group 1',
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.green)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          DropdownButtonFormField(
                                            items: listValues.map((pt) {
                                              return DropdownMenuItem(
                                                value: pt,
                                                child: Text(pt),
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                color_selection =
                                                    newVal as String?;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.arrow_drop_down_outlined),
                                            decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor)),
                                              filled: true,
                                              hintText: 'Select Color',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                                        logoTheme),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ))),
                                                        onPressed: () async {
                                                          if (_titleController
                                                              .text.isEmpty) {
                                                            return errorSnackThis(
                                                              context: context,
                                                              content: const Text(
                                                                  "Title can't be empty"),
                                                            );
                                                          }
                                                          if (color_selection ==
                                                                  null ||
                                                              color_selection ==
                                                                  "") {
                                                            return errorSnackThis(
                                                              context: context,
                                                              content: const Text(
                                                                  "Select Color"),
                                                            );
                                                          }

                                                          final request =
                                                              jsonEncode({
                                                            "title":
                                                                _titleController
                                                                    .text,
                                                            "color":
                                                                color_selection,
                                                          });
                                                          customLoadStart();

                                                          _titleController
                                                              .clear();
                                                          color_selection = "";

                                                          try {
                                                            final CreateSubGroupResponse
                                                                res =
                                                                await CollaborationRepository().createSubGroup(
                                                                    value
                                                                        .allTask
                                                                        .moduleGroup[
                                                                            "_id"]
                                                                        .toString(),
                                                                    request);

                                                            if (res.success ==
                                                                true) {
                                                              refreshPage(
                                                                  provider:
                                                                      value);
                                                              _titleController
                                                                  .clear();
                                                              if (context
                                                                  .mounted) {
                                                                successSnackThis(
                                                                  context:
                                                                      context,
                                                                  content:
                                                                      const Text(
                                                                          "Group Created successfully"),
                                                                );
                                                              }
                                                            } else {
                                                              if (context
                                                                  .mounted) {
                                                                errorSnackThis(
                                                                  context:
                                                                      context,
                                                                  content:
                                                                      const Text(
                                                                          "Group Creation Failed"),
                                                                );
                                                              }
                                                            }
                                                          } on Exception catch (e) {
                                                            if (context
                                                                .mounted) {
                                                              errorSnackThis(
                                                                context:
                                                                    context,
                                                                content: Text(e
                                                                    .toString()),
                                                              );
                                                            }
                                                          } finally {
                                                            customLoadStop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                        child: const Text("Add",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: white)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .amber),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ))),
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          }
                        : null,
                  ),
                )),
            (value.allTask.tasks == null)
                ? Container()
                : Builder(builder: (context) {
                    List<Widget> outer = [];
                    value.allTask.tasks!.forEach((k, v) {
                      List<dynamic> values2 = v;
                      outer.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Theme(
                                  data: ThemeData().copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    tilePadding: EdgeInsets.zero,
                                    trailing: user?.type == "Lecturer" ||
                                            value.allTask.moduleGroup["hasEdit"]
                                                .contains(userId)
                                        ? PopupMenuButton<String>(
                                            onSelected: (text) async {
                                              setState(() {
                                                if (text == "Add") {
                                                  Map<String, dynamic>
                                                      mapValue = {
                                                    "keyId": k,
                                                    "users": value.allTask
                                                        .moduleGroup["users"],
                                                    "assignedToList": "",
                                                    "isUpdate": false
                                                  };
                                                  Navigator.pushNamed(context,
                                                          '/create/task',
                                                          arguments: mapValue)
                                                      .then((_) {
                                                    refreshPage(
                                                        provider: value);
                                                  });
                                                } else if (text == "Delete") {
                                                  showAlertDeleteDialog(
                                                      context, k, value);
                                                }
                                              });
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
                                              return ["Add", "Delete"]
                                                  .map((String choice) {
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(choice),
                                                );
                                              }).toList();
                                            },
                                            icon: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: Icon(
                                                Icons.more_vert,
                                                color: black,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_drop_down,
                                                color: black,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Builder(builder: (context) {
                                                for (var element2 in value
                                                        .allTask.moduleGroup[
                                                    "moduleSubGroup"]) {
                                                  if (element2["_id"] == k) {
                                                    return Expanded(
                                                        child: Text(
                                                      element2["title"],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black),
                                                    ));
                                                  }
                                                }
                                                return Container();
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: DataTable(
                                            border: TableBorder.all(
                                                width: 1,
                                                style: BorderStyle.solid),
                                            showBottomBorder: true,
                                            columns: const [
                                              DataColumn(
                                                  label: Text(
                                                    'Task',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                  tooltip: 'Task'),
                                              DataColumn(
                                                  label: Text(
                                                    'Asignee',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                  tooltip: 'Person'),
                                              DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                  tooltip: 'Status'),
                                              DataColumn(
                                                  label: Text(
                                                    'Date',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                  tooltip: 'Date'),
                                            ],
                                            rows: values2
                                                .map((data) => DataRow(cells: [
                                                      DataCell(Text(
                                                        data["title"],
                                                        style: const TextStyle(
                                                            fontSize: 13),
                                                      )),
                                                      DataCell(Builder(
                                                          builder: (context) {
                                                        int indexValue =
                                                            data["assignedTo"]
                                                                        .length <
                                                                    3
                                                                ? data["assignedTo"]
                                                                    .length
                                                                : 3;
                                                        List<dynamic>
                                                            personValue =
                                                            data["assignedTo"]
                                                                .sublist(0,
                                                                    indexValue);
                                                        List<Widget> person =
                                                            [];
                                                        if (personValue.length <
                                                            3) {
                                                          for (int i = 0;
                                                              i <
                                                                  personValue
                                                                      .length;
                                                              i++) {
                                                            person.add(
                                                                CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            300],
                                                                    radius: 14,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .person,
                                                                      color:
                                                                          white,
                                                                    )));
                                                          }
                                                        } else {
                                                          person.add(Row(
                                                            children: [
                                                              CircleAvatar(
                                                                  radius: 14,
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          300],
                                                                  child: const Icon(
                                                                      Icons
                                                                          .person,
                                                                      color:
                                                                          white)),
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Text(
                                                                    "+${(data["assignedTo"].length - 1).toString()}",
                                                                    style: const TextStyle(
                                                                        color:
                                                                            white),
                                                                  ))
                                                            ],
                                                          ));
                                                        }
                                                        return person.isNotEmpty
                                                            ? InkWell(
                                                                onTap: () {
                                                                  {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (ctx) =>
                                                                              Dialog(
                                                                        insetPadding:
                                                                            const EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 10,
                                                                              vertical: 10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.6,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Align(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: IconButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      icon: const Icon(Icons.close))),
                                                                              Text(
                                                                                data["title"].toString(),
                                                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                maxLines: 1,
                                                                              ),
                                                                              Text("Created By: ${data["createdBy"].toString()}"),
                                                                              Text("Created At: ${DateFormat.yMMMEd().format(DateTime.parse(data["createdAt"]))}"),
                                                                              const Text("Assigned To:"),
                                                                              ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  physics: const ScrollPhysics(),
                                                                                  itemCount: data["assignedTo"].length,
                                                                                  itemBuilder: (context, indexxx) {
                                                                                    return ListTile(
                                                                                      leading: CircleAvatar(
                                                                                        backgroundColor: Colors.grey[300],
                                                                                        radius: 14,
                                                                                        child: const Icon(
                                                                                          Icons.person,
                                                                                          color: white,
                                                                                        ),
                                                                                      ),
                                                                                      title: Text(data["assignedTo"][indexxx]["firstname"] + " " + data["assignedTo"][indexxx]["lastname"]),
                                                                                    );
                                                                                  }),
                                                                            ]),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children:
                                                                      person,
                                                                ),
                                                              )
                                                            : const Text("");
                                                      })),
                                                      DataCell(Builder(
                                                          builder: (context) {
                                                        try {
                                                          return data["status"] ==
                                                                  null
                                                              ? const Text('')
                                                              : Text(
                                                                  data["status"]
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: data["status"] == "Resolved"
                                                                          ? Color(0XFF004D96)
                                                                          : data["status"] == "Backlog"
                                                                              ? Color(0XFFC9A62A)
                                                                              : data["status"] == "Pending"
                                                                                  ? Color(0XFFE80000)
                                                                                  : Colors.green,
                                                                      fontSize: 13),
                                                                );
                                                        } on Exception catch (e) {
                                                          return const Text("");
                                                        }
                                                      })),
                                                      DataCell(Builder(
                                                          builder: (context) {
                                                        try {
                                                          return data["createdAt"] ==
                                                                  null
                                                              ? const Text("")
                                                              : Text(
                                                                  DateFormat
                                                                          .yMMMEd()
                                                                      .format(DateTime
                                                                          .parse(
                                                                              data["createdAt"])),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                );
                                                        } on Exception catch (e) {
                                                          return const Text("");
                                                        }
                                                      })),
                                                    ]))
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              values2.isEmpty
                                  ? const Text("No Item")
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [...outer],
                    );
                  })
          ],
        ),
      ),
    );
  }

  Widget _buildBoardTaskCard(CollaborationViewModel value, String status) {
    Set<dynamic> set1Number = {};
    return (value.allTask.tasks == null)
        ? Container()
        : Builder(builder: (context) {
            List<Widget> outer = [];

            value.allTask.tasks!.forEach((k, v) {
              List<dynamic> values2 = v;
              bool checkUserTicket = false;

              if (checkBoxValue == true) {
                values2.forEach((element) {
                  (element["assignedTo"].forEach((e) {
                    checkUserTicket = (e["username"] == user!.username);
                    if (checkUserTicket == true) {
                      set1Number.add(element);
                    }
                  }));
                });
              } else if (checkBoxValue == false) {
                values2.forEach((element) {
                  set1Number.add(element);
                });
              }
              _storeKey = k;
            });

            outer.add(
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: set1Number.length,
                itemBuilder: (ctx, int index) {
                  dynamic _listValue = (set1Number.toList())[index];
                  return _listValue["status"] == status
                      ? ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    left:
                                        BorderSide(color: grey_600, width: 0.5),
                                    right:
                                        BorderSide(color: grey_600, width: 0.5),
                                    top: BorderSide(
                                        color: grey_600, width: 0.5)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: black,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Text(
                                        _listValue["_id"],
                                        style: const TextStyle(
                                            color: white, fontSize: 12),
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      List<String> userId = [];
                                      try {
                                        userId.clear();
                                        for (var item
                                            in _listValue["assignedTo"]) {
                                          userId.add(item['_id'].toString());
                                        }
                                      } catch (e) {
                                        userId = [];
                                      }

                                      Map<String, dynamic> mapValue = {
                                        "keyId": _storeKey,
                                        "users":
                                            value.allTask.moduleGroup["users"],
                                        "assignedToList": _listValue,
                                        "userId": userId,
                                        "isUpdate": true
                                      };

                                      // Navigator.pushNamed(
                                      //         context, "/create/task",
                                      //         arguments: mapValue)
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTaskScreen(
                                                          groupId: mapValue)))
                                          .then((_) {
                                        refreshPage(provider: value);
                                      });
                                    },
                                    child: const Icon(Icons.edit_note_outlined),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: white,
                                  border: Border(
                                      left: BorderSide(
                                          color: grey_600, width: 0.5),
                                      right: BorderSide(
                                          color: grey_600, width: 0.5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _listValue["title"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: status == "Resolved"
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Html(
                                      shrinkWrap: true,
                                      data: _listValue["detail"],
                                      style: {
                                        "body": Style(
                                          fontSize: const FontSize(14.0),
                                        ),
                                      },
                                      customRender: {
                                        "table": (context, child) {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: (context.tree
                                                    as TableLayoutElement)
                                                .toWidget(context),
                                          );
                                        }
                                      },
                                      onLinkTap: (String? url,
                                          RenderContext context,
                                          Map<String, String> attributes,
                                          dom.Element? element) {
                                        Future<void> _launchInBrowser(
                                            Uri url) async {
                                          if (await launchUrl(
                                            url,
                                            mode:
                                                LaunchMode.externalApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        var linkUrl =
                                            url!.replaceAll(" ", "%20");
                                        _launchInBrowser(Uri.parse(linkUrl));
                                      },
                                      onImageTap: (String? url,
                                          RenderContext context,
                                          Map<String, String> attributes,
                                          dom.Element? element) {
                                        launch(url!);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.watch_later,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              DateFormat.yMMMEd().format(
                                                  DateTime.parse(_listValue[
                                                          "startDate"] ??
                                                      _listValue["createdAt"]
                                                          .toString())),
                                              style: const TextStyle(
                                                  color: black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Created by: ',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: _listValue["createdBy"],
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: grey_200,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                border: Border.all(color: grey_600, width: 0.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Assigned To:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Builder(builder: (context) {
                                    int indexValue =
                                        _listValue["assignedTo"].length < 3
                                            ? _listValue["assignedTo"].length
                                            : 3;
                                    List<dynamic> personValue =
                                        _listValue["assignedTo"]
                                            .sublist(0, indexValue);
                                    List<Widget> person = [];
                                    if (personValue.length < 3) {
                                      for (int i = 0;
                                          i < personValue.length;
                                          i++) {
                                        person.add(const CircleAvatar(
                                            radius: 14,
                                            child: Icon(Icons.person)));
                                      }
                                    } else {
                                      person.add(Row(
                                        children: [
                                          const CircleAvatar(
                                              radius: 14,
                                              child: Icon(Icons.person)),
                                          Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                  "+${(_listValue["assignedTo"].length - 1).toString()}"))
                                        ],
                                      ));
                                    }
                                    return person.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      const Text("Assigned To"),
                                                  content: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ScrollPhysics(),
                                                        itemCount: _listValue[
                                                                "assignedTo"]
                                                            .length,
                                                        itemBuilder:
                                                            (context, indexxx) {
                                                          return ListTile(
                                                            leading:
                                                                const CircleAvatar(
                                                              radius: 14,
                                                              child: Icon(
                                                                  Icons.person),
                                                            ),
                                                            title: Text(_listValue[
                                                                            "assignedTo"]
                                                                        [
                                                                        indexxx]
                                                                    [
                                                                    "firstname"] +
                                                                " " +
                                                                _listValue["assignedTo"]
                                                                        [
                                                                        indexxx]
                                                                    [
                                                                    "lastname"]),
                                                          );
                                                        }),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        child:
                                                            const Text("okay"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: person,
                                            ),
                                          )
                                        : const Text("");
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Container();
                },
              ),
            );
            return RefreshIndicator(
                onRefresh: () => refreshPage(provider: value),
                child: ListView(
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 100),
                  shrinkWrap: true,
                  children: [...outer],
                ));
          });
  }

  Widget _buildGroupMember(
      CollaborationViewModel value, CommonViewModel common) {
    return RefreshIndicator(
        onRefresh: () async {
          await refreshPage(provider: value);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: CommonButton(
                    text: "Add Members",
                    fontSize: 14,
                    color: user?.type == "Lecturer" ||
                            value.allTask.moduleGroup["hasEdit"]
                                .contains(userId)
                        ? Colors.green
                        : Colors.grey,
                    textColor: white,
                    onTap: value.allTask.moduleGroup["hasEdit"].contains(userId)
                        ? () {
                            showDialog(
                              context: context,
                              builder: (ctx) => const AlertDialog(
                                title: Text("No Access"),
                                content: SizedBox(
                                    // height: MediaQuery.of(context).size.height *
                                    //     0.4,
                                    // width: MediaQuery.of(context).size.height,
                                    child: Text(
                                        "You don't have access to add memebers")),
                              ),
                            );
                          }
                        : user?.type == "Lecturer"
                            ? () {
                                selectedBatch = null;
                                finalList.clear();
                                showTeacherDialog(context, value, common);
                              }
                            : null,
                  )),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: value.allTask.moduleGroup["users"].length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, int index) {
                    dynamic users = value.allTask.moduleGroup["users"][index];
                    return Card(
                      elevation: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        height: 50,
                        child: Row(
                          children: [
                            const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 16,
                                child: Icon(
                                  Icons.person,
                                  color: white,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                    "${users["firstname"] + " " + users["lastname"]}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                user?.type == "Lecturer" ||
                                        value.allTask.moduleGroup["hasEdit"]
                                            .contains(users["_id"])
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Editor",
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            const Spacer(),
                            user?.type == "Lecturer" ||
                                    value.allTask.moduleGroup["hasEdit"]
                                        .contains(userId)
                                ? Builder(builder: (context) {
                                    return users["username"] != user?.username
                                        ? Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    checkUser = value.allTask
                                                        .moduleGroup["hasEdit"]
                                                        .contains(users["_id"]);
                                                    showAlertDialog(
                                                        context,
                                                        users,
                                                        value,
                                                        checkUser);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .orangeAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: value
                                                              .allTask
                                                              .moduleGroup[
                                                                  "hasEdit"]
                                                              .contains(
                                                                  users["_id"])
                                                          ? const Icon(
                                                              Icons
                                                                  .person_off_rounded,
                                                              size: 18,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .lock_clock_outlined,
                                                              size: 18))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    showAlertDeleteMemberDialog(
                                                        context,
                                                        value.allTask
                                                            .moduleGroup["_id"],
                                                        users["_id"],
                                                        value);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: solidRed,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: const Icon(
                                                          Icons.delete,
                                                          color: white,
                                                          size: 18))),
                                            ],
                                          )
                                        : const SizedBox();
                                  })
                                : const SizedBox()
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context, dynamic users,
      CollaborationViewModel value, bool checkUsers) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () async {
        try {
          customLoadStart();
          String request = jsonEncode({
            "status": checkUsers ? "REMOVE" : "ADD",
            "user": users["_id"],
            "module": widget.moduleId.toString()
          });
          RemoveEditorResponse res =
              await CollaborationRepository().removeEditor(request);

          if (res.success == true) {
            refreshPage(provider: value);
            snackThis(
                context: context,
                content: Text(res.message.toString()),
                color: Colors.green,
                duration: 1,
                behavior: SnackBarBehavior.floating);
          } else {
            snackThis(
                context: context,
                content: Text(res.message.toString()),
                color: Colors.red,
                duration: 1,
                behavior: SnackBarBehavior.floating);
          }
        } on Exception catch (e) {
          snackThis(
              context: context,
              content: const Text("User Role Update Failed"),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        } finally {
          Navigator.pop(context);
          customLoadStop();
        }
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Update Permission?"),
      content: Text(checkUsers
          ? "This user will be revoked from editor role. Do you wish to continue?"
          : "This user will be granted editor role. Do you wish to continue?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDeleteDialog(
      BuildContext context, String id, CollaborationViewModel value2) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () async {
        try {
          customLoadStart();
          Commonresponse res =
              await CollaborationRepository().deleteGroup(id.toString());

          if (res.success == true) {
            refreshPage(provider: value2);
            customLoadStop();
            Navigator.of(context).pop();
            snackThis(
                context: context,
                content: const Text("Group Deleted successfully"),
                color: Colors.green,
                duration: 1,
                behavior: SnackBarBehavior.floating);
          } else {
            Navigator.of(context).pop();
            snackThis(
                context: context,
                content: const Text("Group Deleted failed"),
                color: Colors.red,
                duration: 1,
                behavior: SnackBarBehavior.floating);
            customLoadStop();
          }
        } catch (e) {
          Navigator.of(context).pop();
          snackThis(
              context: context,
              content: Text(e.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
          customLoadStop();
        }
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete group?"),
      content: const Text(
          "Are you sure you want to delete this group? This action cannot be undone!"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDeleteMemberDialog(BuildContext context, String id, String userId,
      CollaborationViewModel _provider) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () async {
        try {
          customLoadStart();
          Commonresponse res = await CollaborationRepository()
              .deleteMember(id.toString(), userId.toString());
          if (res.success == true) {
            refreshPage(provider: _provider);
            snackThis(
                context: context,
                content: const Text("Group Deleted successfully"),
                color: Colors.green,
                duration: 1,
                behavior: SnackBarBehavior.floating);
            Navigator.pop(context);
          } else {
            snackThis(
                context: context,
                content: const Text("Group Deleted failed"),
                color: Colors.red,
                duration: 1,
                behavior: SnackBarBehavior.floating);
            Navigator.pop(context);
          }
        } catch (e) {
          snackThis(
              context: context,
              content: Text(e.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
          Navigator.pop(context);
        } finally {
          customLoadStop();
        }
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Remove user from this group?"),
      content: const Text(
          "Are you sure you want to delete this user? All the tasks and progress will be lost for this user."),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showTeacherDialog(BuildContext context, CollaborationViewModel value,
      CommonViewModel common) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
          return AlertDialog(
              title: const Text("Add members"),
              scrollable: true,
              content: isLoading(value.assignmentBatchApiResponse)
                  ? const Center(child: CupertinoActivityIndicator())
                  : SizedBox(
                      height: 360,
                      child: isLoading(value.assignmentBatchApiResponse)
                          ? const Center(child: CupertinoActivityIndicator())
                          : value.allTask.moduleGroup["module"]
                                      ["currentBatch"] ==
                                  null
                              ? Container()
                              : SingleChildScrollView(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField<Object>(
                                      items: (value
                                                  .allTask.moduleGroup["module"]
                                              ["currentBatch"] as List<dynamic>)
                                          .map<DropdownMenuItem<Object>>(
                                              (pt) => DropdownMenuItem<Object>(
                                                    value: pt,
                                                    child: Text(pt.toString()),
                                                  ))
                                          .toList(),
                                      onChanged: (newVal) {
                                        setStates(() {
                                          selectedBatch = newVal.toString();
                                          finalList.clear();
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            common
                                                .fetchStudentformarking(
                                                    selectedBatch.toString())
                                                .then((_) {
                                              for (int k = 0;
                                                  k <
                                                      value
                                                          .allTask
                                                          .moduleGroup["users"]
                                                          .length;
                                                  k++) {
                                                setStates(() {
                                                  studentsUsername.add(_provider
                                                          .allTask
                                                          .moduleGroup["users"]
                                                      [k]["username"]);
                                                });
                                              }
                                              for (int i = 0;
                                                  i <
                                                      common.studentMarking
                                                          .length;
                                                  i++) {
                                                if (!studentsUsername.contains(
                                                    common.studentMarking[i]
                                                        ["username"])) {
                                                  setStates(() {
                                                    finalList.add(common
                                                        .studentMarking[i]);
                                                  });
                                                }
                                              }
                                            });
                                          });
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.arrow_drop_down_outlined),
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: kPrimaryColor)),
                                        filled: true,
                                        hintText: 'Select Batch/Section',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    selectedBatch == null
                                        ? const SizedBox()
                                        : isLoading(common
                                                .studentMarkingApiResponse)
                                            ? const Center(
                                                child:
                                                    CupertinoActivityIndicator())
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Assigned to"),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  MultiSelectDialogField(
                                                    items: finalList
                                                        .map((e) => MultiSelectItem(
                                                            e["_id"].toString(),
                                                            "${e["firstname"]} ${e["lastname"]}"))
                                                        .toList(),
                                                    listType:
                                                        MultiSelectListType
                                                            .CHIP,
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
                                                    onConfirm:
                                                        (List<String> values) {
                                                      setState(() {
                                                        selectStudent = values;

                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: SizedBox(
                                                height: 35,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(logoTheme),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ))),
                                                  onPressed: () async {
                                                    final request = jsonEncode({
                                                      "module": value.allTask
                                                          .moduleGroup["_id"],
                                                      "users": selectStudent,
                                                    });
                                                    try {
                                                      customLoadStart();
                                                      RemoveEditorResponse res =
                                                          await CollaborationRepository()
                                                              .addMember(
                                                                  request);
                                                      if (res.success == true) {
                                                        refreshPage(
                                                            provider: value);
                                                        Navigator.of(context)
                                                            .pop();
                                                        _titleController
                                                            .clear();
                                                        snackThis(
                                                            context: context,
                                                            content: const Text(
                                                                "User Added successfully"),
                                                            color: Colors.green,
                                                            duration: 1,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating);
                                                      } else {
                                                        snackThis(
                                                            context: context,
                                                            content: const Text(
                                                                "Something went wrong"),
                                                            color: Colors.red,
                                                            duration: 1,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating);
                                                      }
                                                    } catch (e) {
                                                      snackThis(
                                                          context: context,
                                                          content: const Text(
                                                              "Something went wrong"),
                                                          color: Colors.red,
                                                          duration: 1,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                    } finally {
                                                      customLoadStop();
                                                    }
                                                  },
                                                  child: const Text("Add",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: white)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: SizedBox(
                                                height: 35,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.amber),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ))),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                    ));
        });
      },
    );
  }
}