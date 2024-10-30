import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_stats/stats_screen.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

import '../../../constants/colors.dart';

class Staffstats extends StatefulWidget {
  const Staffstats({Key? key}) : super(key: key);

  @override
  _StaffstatsState createState() => _StaffstatsState();
}

class _StaffstatsState extends State<Staffstats> {
  late PrinicpalCommonViewModel _provider;
  bool visibility = false;
  List<dynamic> _listForDisplay = [];

  TextEditingController searchController = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _provider =
            Provider.of<PrinicpalCommonViewModel>(context, listen: false);
         _provider.fetchstaffs().then((value){
           setState(() {
             _listForDisplay = _provider.staffs;
           });
         });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text(
              "Staff Stats",
            ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: Icon(
                  visibility ? Icons.close : Icons.search,

                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              Visibility(
                visible: visibility,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextField(
                    controller: searchController,
                    focusNode: _searchFocusNode,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: white,
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              searchController.clear();
                              _listForDisplay = value.staffs;
                              _searchFocusNode.unfocus();
                            });
                          },
                          child: const Icon(Icons.close)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      alignLabelWithHint: true,
                      // border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: grey_400,
                      )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: grey_400)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: grey_400)),
                      hintText: "Search staff by name",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _listForDisplay = value.staffs.where((list) {
                          var itemName =
                              '${list["firstname"].toString().toLowerCase()} ${list["lastname"].toString().toLowerCase()}';
                          return itemName.toString().toLowerCase().contains(text);
                        }).toList();
                      });
                    },
                  ),
                ),
              ),
              // Text(searchController.text != null || searchController.text != ''
              //     ? "Searched Staffs: ${_listForDisplay.length}"
              //     : "Total Staffs: ${value.staffs.length}"),
              const SizedBox(
                height: 10,
              ),
              isLoading(value.staffApiResponse)
                  ? const Center(
                      child: CupertinoActivityIndicator()
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listForDisplay.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var dataFiltered = _listForDisplay[index];
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) =>
                                  bottomSheet(dataFiltered, common, value)),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Builder(builder: (context) {
                                      var name = dataFiltered['firstname'] +
                                          " " +
                                          dataFiltered['lastname'];
                                      return RichText(
                                        text: TextSpan(
                                          text: 'Name: ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: name.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'Email: ',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: dataFiltered['email']
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
                                        RichText(
                                          text: TextSpan(
                                            text: 'Username: ',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: dataFiltered['username']
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
                                        dataFiltered['designation'] == null ||
                                                dataFiltered['designation'] ==
                                                    ""
                                            ? Container()
                                            : Chip(
                                                backgroundColor:
                                                    Color(0xff17a2b8),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                labelPadding:
                                                    const EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                label: Text(
                                                  dataFiltered['designation']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ))
                                      ],
                                    ),
                                    trailing: dataFiltered['designation'] ==
                                            null
                                        ? Chip(
                                            label: Text(
                                              dataFiltered['type'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.black38,
                                          )
                                        : SizedBox(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
            ],
          ));
    });
  }

  Widget bottomSheet(
      dynamic data, CommonViewModel common, PrinicpalCommonViewModel model) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 190.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          model.hasPermission(["edit_staff_detail"]) == false
              ? const SizedBox()
              : ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text("View stats"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        PageTransition(
                            child: StatsScreenPrincipal(data: data),
                            type: PageTransitionType.leftToRight));
                  },
                ),
          model.hasPermission(["reset_user_password"]) == false
              ? const SizedBox()
              : ListTile(
                  leading: Icon(Icons.replay),
                  title: Text("Reset password"),
                  onTap: () async {
                    try {
                      common.setLoading(true);
                      Map<String, dynamic> datas = {
                        "_id": data['_id'],
                        "password": "password"
                      };

                      final res = await StatsRepository().resetPassword(datas);
                      if (res.success == true) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: res.message.toString());
                      } else {
                        Fluttertoast.showToast(msg: res.message.toString());
                      }
                      common.setLoading(false);
                    } on Exception catch (e) {
                      // TODO
                      common.setLoading(true);
                      Fluttertoast.showToast(msg: e.toString());
                      common.setLoading(false);
                    }
                  },
                ),
        ],
      ),
    );
  }
}
