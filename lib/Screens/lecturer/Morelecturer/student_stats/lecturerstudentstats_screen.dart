import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/stats_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/miscellaneous/miscellaneous_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/student_stats/issue_ticketprincipal.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/getalluser_studentstats_response.dart';

import '../../../../api/repositories/exam_repo.dart';
import '../../../../config/api_response_config.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/text_style.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../response/common_response.dart';
import '../../../../services/lecturer/studentstats_service.dart';
import '../../../widgets/snack_bar.dart';
import '../../miscellaneous/MiscellaneousFormScreen.dart';

class LecturerStudentStats extends StatefulWidget {
  const LecturerStudentStats({
    Key? key,
  }) : super(key: key);

  @override
  _LecturerStudentStatsState createState() => _LecturerStudentStatsState();
}

class _LecturerStudentStatsState extends State<LecturerStudentStats> {
  Future<GetAllUserStudentStatsResponse>? student_response;
  late MiscellaneousViewModel miscellaneousViewModel;
  Icon cusIcon = const Icon(Icons.search);
  bool connected = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _listForDisplay = <dynamic>[];
  List<dynamic> _list = <dynamic>[];

  bool isloading = false;

  bool verticalLoader = false;

  String? selected_batch;

  Widget cusSearchBar = const Text(
    'Student Stats',
    style: TextStyle(color: white),
  );

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      miscellaneousViewModel =
          Provider.of<MiscellaneousViewModel>(context, listen: false);
      miscellaneousViewModel.fetchInstitution();
      Provider.of<StatsCommonViewModel>(context, listen: false).fetchAllBatch();
      getData();
    });
    super.initState();
  }

  getData() async {
    setState(() {
      verticalLoader = true;
    });
    await StudentStatsLecturerService().getAllStudentForLecturerStats('select');
    setState(() {
      verticalLoader = false;
    });
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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (cusIcon.icon == Icons.search) {
                    cusIcon = const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    );
                    cusSearchBar = TextField(
                      autofocus: true,
                      textInputAction: TextInputAction.go,
                      controller: _searchController,
                      style: const TextStyle(color: white),
                      decoration: const InputDecoration(
                          hintText: 'Search student name...',
                          hintStyle: TextStyle(color: white),
                          border: InputBorder.none),
                      onChanged: (text) {
                        setState(() {
                          _listForDisplay = _list.where((list) {
                            var itemName = list['firstname'].toLowerCase() +
                                " " +
                                list['lastname'].toLowerCase();
                            return itemName.contains(text);
                          }).toList();
                        });
                      },
                    );
                  } else {
                    cusIcon = const Icon(Icons.search);

                    _listForDisplay = _list;
                    _searchController.clear();
                    cusSearchBar = const Text(
                      'Student Stats',
                      style: TextStyle(color: white),
                    );
                  }
                });
              },
              icon: cusIcon)
        ],
        elevation: 0.0,
        centerTitle: false,
        title: cusSearchBar,
        // backgroundColor: Colors.white
      ),
      body: Consumer2<StatsCommonViewModel, MiscellaneousViewModel>(
          builder: (context, stats, misc, child) {
        return isLoading(misc.institutionApiResponse)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Batch",
                      style: p16,
                    ),
                    DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        hintText: 'Select Batch/Section',
                      ),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      items: stats.allbatches.map((pt) {
                        return DropdownMenuItem(
                          value: pt.batch,
                          child: Text(
                            pt.batch.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) async {
                        setState(() {
                          selected_batch = newVal as String?;
                          verticalLoader = true;
                        });

                        final data = await StudentStatsLecturerService()
                            .getAllStudentForLecturerStats(selected_batch ?? "");

                        _list.clear();
                        _listForDisplay.clear();

                        for (int i = 0; i < data.students!.length; i++) {
                          setState(() {
                            _list.add(data.students?[i]);
                            _listForDisplay = _list;
                            verticalLoader = false;
                          });
                        }
                        setState(() {
                          verticalLoader = false;
                        });
                      },
                      value: selected_batch,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    misc.availableInstitution['type'] == "School"
                        ? selected_batch == null
                            ? const SizedBox()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: logoTheme),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MiscellaneousFormScreen(
                                                batch: selected_batch,
                                                students: _list),
                                      ));
                                },
                                child: const Text("Miscellaneous data"))
                        : const SizedBox(),

                    const SizedBox(
                      height: 10,
                    ),

                    selected_batch == null
                        ? Center(
                            child: Text(
                            'Please select a batch',
                            style: p14.copyWith(color: red),
                            textAlign: TextAlign.center,
                          ))
                        : verticalLoader == true
                            ? const VerticalLoader()
                            : _listForDisplay.isEmpty
                                ? Center(
                                    child: Text(
                                    'Student not assigned \nin this batch/section',
                                    style: p14.copyWith(color: red),
                                    textAlign: TextAlign.center,
                                  ))
                                : getListView()

                    // selected_batch != null ?
                    // _listForDisplay.isEmpty ? const VerticalLoader() :
                    // getListView() : const Center(child: Text('Please select a batch')),
                  ]);
      }),
    );
  }

  _searchBar() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Module",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);
    return items;
  }

  Widget getListView() {
    var listItems = getListElements();
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: listItems.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listItems[index]['firstname'] +
                              " " +
                              listItems[index]['lastname']),
                          Text(listItems[index]['username'] ?? ""),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listItems[index]['course'] ?? ""),
                          Text(listItems[index]['batch'] ?? ""),
                        ],
                      ),
                      trailing: listItems[index]["disableLogin"] == true
                          ? IconButton(
                              onPressed: () {
                                showEnableLoginAlert(
                                    context, listItems[index]["_id"]);
                              },
                              icon: const Icon(
                                Icons.login_rounded,
                                color: Colors.red,
                              ))
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: IssueTicketPrincipal(
                                            datas: listItems[index]),
                                        type: PageTransitionType.leftToRight));
                              },
                              child: const Text("Issue Ticket")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatsDetailScreen(
                                          data: listItems[index]),
                                    ));
                              },
                              child: const Text("View stats")),
                        ],
                      ),
                    )

                    // Text("Percentage: "+datas.percentage.toString()),
                  ],
                ),
              ),
            ],
          );
        });
    return listview;
  }

  showEnableLoginAlert(BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Start Exam"),
            content: SizedBox(
              height: 340,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This feature is designed for online exams, and it restricts users from logging in from a new device.However, if a user accidentally logs out, you have the option to enable this feature. Enabling it will log the user out of all current sessions, allowing them to log back in again.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  isloading = true;
                                });
                                Commonresponse res = await ExamRepository()
                                    .enableUserLogin(userId);
                                if (res.success == true) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Navigator.pop(context);
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.green,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  setState(() {
                                    isloading = false;
                                  });
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.red,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  setState(() {
                                    isloading = false;
                                  });
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  isloading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isloading = true;
                                });
                                snackThis(
                                    context: context,
                                    content: Text("Failed"),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xfff33066)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            child: const Text(
                              "Enable Login",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
  }
}
