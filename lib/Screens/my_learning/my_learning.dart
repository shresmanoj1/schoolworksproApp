import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learningdetail.dart';
import 'package:schoolworkspro_app/common_view_model.dart';

import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/response/new_learning_response.dart';
import 'package:schoolworkspro_app/routes/route_generator.dart';

import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../constants/text_style.dart';
import '../../response/mylearning_response.dart';
import 'components/module_single_card.dart';
import 'components/my_learning_header.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({Key? key}) : super(key: key);

  @override
  _MyLearningState createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning>
    with AutomaticKeepAliveClientMixin {
  bool connected = true;
  late LearningViewModel _learningViewModel;
  late CommonViewModel _common;
  List<ModuleLearning> _listForDisplay = <ModuleLearning>[];
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      _listForDisplay.clear();
      _listForDisplay = _learningViewModel.myLearning;
    });
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> handleRefreshData(LearningViewModel data) async {
    _listForDisplay.clear();
    data.fetchLearningFilters();
    await data.fetchMyLearning("");
    await data.fetchMyNewLearning("");
    _listForDisplay = _learningViewModel.myLearning;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: connected == false
            ? const NoInternetWidget()
            : Consumer2<LearningViewModel, CommonViewModel>(
                builder: (context, value, common, child) {
                return RefreshIndicator(
                  onRefresh: () => handleRefreshData(value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: CupertinoTextField(
                                    controller: _editingController,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: grey_400)),
                                    placeholder: "Search by title",
                                    onChanged: (text) {
                                      setState(() {
                                        _listForDisplay =
                                            value.myLearning.where((list) {
                                          var itemName = list.moduleTitle
                                              .toString()
                                              .toLowerCase();
                                          return itemName
                                              .toString()
                                              .toLowerCase()
                                              .contains(text);
                                        }).toList();
                                      });
                                    },
                                    suffix: const Icon(
                                      Icons.search,
                                      color: grey_600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return DraggableScrollableSheet(
                                              initialChildSize: 0.4,
                                              minChildSize: 0.3,
                                              maxChildSize: 0.7,
                                              builder: (BuildContext context,
                                                  ScrollController
                                                      scrollController) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                      color: white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Container(
                                                            height: 5,
                                                            width: 50,
                                                            color: grey_400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {});

                                                                value
                                                                    .fetchMyLearning(
                                                                        "")
                                                                    .then((_) {
                                                                  _listForDisplay =
                                                                      value
                                                                          .myLearning;
                                                                });
                                                              },
                                                              child: Text(
                                                                "Reset Filter",
                                                                style: p15
                                                                    .copyWith(
                                                                        color:
                                                                            red),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  controller:
                                                                      scrollController,
                                                                  itemCount: value
                                                                      .filters
                                                                      .length,
                                                                  physics:
                                                                      const ScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Column(
                                                                      children: [
                                                                        ListTile(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            setState(() {
                                                                              _yearController.text = value.filters[index].toString();
                                                                            });
                                                                            // value.fetchMyLearning()
                                                                            value.fetchMyLearning(value.filters[index]).then((valuess) {
                                                                              _listForDisplay = value.myLearning;
                                                                            });
                                                                          },
                                                                          title:
                                                                              Text(
                                                                            value.filters[index].toString(),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  })),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                        },
                                      );
                                    },
                                    child: CupertinoTextField(
                                      controller: _yearController,
                                      enabled: false,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(color: grey_400)),
                                      placeholder: "Sort By",
                                      suffix: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: grey_600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Expanded(
                            child: _listForDisplay.isEmpty
                                ? showLoading()
                                : getListView(value, common))

                      ],
                    ),
                  ),
                );
              }));
  }

  List<ModuleLearning> getListElements() {
    var items = List<ModuleLearning>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);

    return items;
  }

  Widget getListView(LearningViewModel value, CommonViewModel common) {
    var listItems = getListElements();
    var listview = ListView(
      children: [
        ...List.generate(listItems.length, (index) {
          var module = listItems[index];
          var extension = listItems[index].imageUrl?.split(".").last;

          ModuleNew moduleObj = ModuleNew();
          if (value.myNewLearning.isNotEmpty) {
            var newModuleIndex = value.myNewLearning.indexWhere((element) =>
                element.moduleSlug.toString() == module.moduleSlug.toString());

            if (newModuleIndex >= 0) {
              moduleObj = value.myNewLearning[newModuleIndex];
            }
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: SingleModuleCard(
                extension: extension.toString(),
                module: module,
                moduleObj: moduleObj,
                onTap: () {
                  if (shouldShowDuesAlert(common)) {
                    showDuesAlertDialog(context, module.moduleTitle ?? "module");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningDetail(
                              moduleslug: module.moduleSlug,
                              moduleTitle: module.moduleTitle,
                            moduleId: module.id.toString(),
                          ),
                        ));
                  }
                }),
          );
        })
      ],
    );
    return listview;
  }

  Widget showLoading() {
    bool showNoData = false;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showNoData = true;
      });
    });

    return showNoData
        ? const Center(
            child: Text("No data"),
          )
        : const MultipleVerticalLoader();
  }

  bool shouldShowDuesAlert(CommonViewModel common) {
    if (common.authenticatedUserDetail.institution == "softwarica" ||
        common.authenticatedUserDetail.institution == "sunway") {
      return common.authenticatedUserDetail.dues ?? false;
    }
    return false;
  }

  showDuesAlertDialog(BuildContext context, String title) {
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(logoTheme),
      ),
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Dues Amount Alert"),
      content: Text(
          "You have dues amount in pending. Please clear the dues amount to view ${title ?? "module"}."),
      actions: [
        // cancelButton,
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
}
