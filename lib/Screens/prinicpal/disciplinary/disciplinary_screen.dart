import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/disciplinary/edit_act.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/repositories/disciplinary_repo.dart';
import 'package:schoolworkspro_app/api/repositories/principal/leave_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/disciplinary_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/disciplinary_response.dart';

class DisciplinaryActScreen extends StatefulWidget {
  const DisciplinaryActScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DisciplinaryActScreen> createState() => _DisciplinaryActScreenState();
}

class _DisciplinaryActScreenState extends State<DisciplinaryActScreen> {
  PageController pagecontroller = PageController();
  bool isloading = false;
  FocusNode? myFocusNode;
  final TextEditingController leave_typecontroller =
      new TextEditingController();
  final TextEditingController level = new TextEditingController();
  final TextEditingController count = new TextEditingController();
  final TextEditingController miscounduct = new TextEditingController();
  final TextEditingController action = new TextEditingController();
  int selectedIndex = 0;
  String title = 'Home';
  String? my_selection;
  List<String> type = ["Yearly", "Monthly"];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = "View Disciplinary Act";
          }
          break;
        case 1:
          {
            title = "Add Disciplinary Act";
          }
          break;
      }
    });
  }

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  late StatsCommonViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    //gives you the message on which user taps and it openned the app from terminated state
    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider.fetchAllAct();
      FocusScope.of(context).requestFocus(myFocusNode);
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (selectedIndex == 0) {
          // Navigator.of(context).pushReplacementNamed(DisciplinaryActScreen.routeName);
          Navigator.of(context).popUntil((route) => route.isFirst);
          return Future.value(false);
        } else {
          _itemTapped(0);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Consumer2<StatsCommonViewModel, CommonViewModel>(
          builder: (context, value, common, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              elevation: 0.0,
              title: const Text(
                "Disciplinary Act",
              ),
             ),
          body: PageView(
            controller: pagecontroller,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                child: isLoading(value.disciplinaryApiResponse)
                    ? const Center(
                        child: CupertinoActivityIndicator()
                      )
                    : value.act.isEmpty
                        ? Column(
                            children: [
                              Image.asset("assets/images/no_content.PNG"),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: value.act.length,
                            itemBuilder: (context, i) {
                              return Container(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) => bottomSheet(
                                            common,
                                            value,
                                            value.act[i],
                                            context)));
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                            title: RichText(
                                              text: TextSpan(
                                                text: 'Level: ',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value.act[i].level
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Misconduct: ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: value
                                                            .act[i].misconduct
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Action: ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: value
                                                            .act[i].action
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Count: ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: value.act[i].count
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
              ),
              Container(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Level",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        focusNode: myFocusNode,
                        controller: level,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Level 1',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Offence Count",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: count,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 1',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Act of misconduct",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: miscounduct,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'End each miscounduct with a ";',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Action",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: action,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'End each miscounduct with a ";',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: SizedBox(
                              height: 40,
                              width: 95,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  // Navigator.pop(context);
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: SizedBox(
                              height: 40,
                              width: 95,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (level.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Field can't be empty");
                                  } else if (count.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Field can't be empty");
                                  } else if (miscounduct.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Field can't be empty");
                                  } else if (action.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Field can't be empty");
                                  } else {
                                    try {
                                      final request = DisciplinaryRequest(
                                        action: action.text,
                                        count: count.text,
                                        level: level.text,
                                        misconduct: miscounduct.text,
                                      );
                                      Commonresponse res =
                                          await DisciplinaryRepo()
                                              .postact(request);
                                      common.setLoading(true);
                                      if (res.success == true) {
                                        _itemTapped(0);
                                        snackThis(
                                            context: context,
                                            content:
                                                Text(res.message.toString()),
                                            color: Colors.green,
                                            duration: 1,
                                            behavior:
                                                SnackBarBehavior.floating);

                                        value.fetchAllAct();

                                        level.clear();
                                        count.clear();
                                        action.clear();
                                        miscounduct.clear();
                                        common.setLoading(false);
                                      } else {
                                        common.setLoading(true);
                                        snackThis(
                                            context: context,
                                            content:
                                                Text(res.message.toString()),
                                            color: Colors.red,
                                            duration: 1,
                                            behavior:
                                                SnackBarBehavior.floating);
                                        common.setLoading(false);
                                      }
                                      common.setLoading(false);
                                    } catch (e) {
                                      snackThis(
                                          context: context,
                                          content: Text("Failed to add"),
                                          color: Colors.red,
                                          duration: 1,
                                          behavior: SnackBarBehavior.floating);
                                      common.setLoading(false);
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: _itemTapped,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/file.png',
                  height: 20,
                  width: 20,
                  color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
                ),
                // icon: SvgPicture.asset(
                //   categories,
                //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
                // ),
                // ignore: deprecated_member_use
                label: "View Disciplinary Act",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/more.png',
                  height: 20,
                  width: 20,
                  color: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
                ),
                // icon: SvgPicture.asset(
                //   categories,
                //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
                // ),
                // ignore: deprecated_member_use
                label: 'Add Disciplinary Act',
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget bottomSheet(CommonViewModel common, StatsCommonViewModel stats,
      Result data, BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Edit/Delete",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (context) => EditActScreen(data: data,),));
            },
            leading: const Icon(Icons.edit),
            title: const Text("Edit"),
          ),
          ListTile(
            onTap: () async {
              common.setLoading(true);
              final res =
                  await DisciplinaryRepo().deleteact(data.id.toString());
              if (res.success == true) {
                Navigator.of(context).pop();
                snackThis(
                    context: context,
                    color: Colors.green,
                    content: Text(res.message.toString()),
                    duration: 2);
                stats.fetchAllAct();
              } else {
                snackThis(
                    context: context,
                    color: Colors.red,
                    content: Text(res.message.toString()),
                    duration: 2);
              }
              common.setLoading(false);
            },
            leading: Icon(Icons.delete),
            title: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
