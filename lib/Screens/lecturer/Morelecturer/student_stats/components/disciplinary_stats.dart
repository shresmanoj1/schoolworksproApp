import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdisciplinaryforstats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';

import '../../../../../api/repositories/disciplinary_repo.dart';
import '../../../../../config/api_response_config.dart';
import '../../../../../helper/custom_loader.dart';
import '../../../../prinicpal/stats_common_view_model.dart';

class DisciplinaryStatsScreen extends StatefulWidget {
  final data;
  const DisciplinaryStatsScreen({Key? key, this.data})
      : super(key: key);

  @override
  _DisciplinaryStatsScreenState createState() =>
      _DisciplinaryStatsScreenState();
}

class _DisciplinaryStatsScreenState
    extends State<DisciplinaryStatsScreen> {
  Future<GetDisciplinaryForStatsResponse>? disciplinary_response;
  bool penalizeVisibility = false;
  final _formKey = GlobalKey<FormState>();
  bool isoading = false;
  final TextEditingController _remarksController =
      new TextEditingController();
  late StatsCommonViewModel _provider;
  final TextEditingController dateController =
      TextEditingController();

  DateTime? duedate;

  String? selected_act_level;
  String? selectedActId;
  String? selectedActName;
  List<String> selectMisconduct = <String>[];
  List<String> selectedActionsList = <String>[];

  String fileName = '';
  File? file;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider =
          Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider.fetchAllAct();
    });

    getData();
    super.initState();
  }

  getData() async {
    disciplinary_response = StudentStatsLecturerService()
        .getUsersDisciplinary(widget.data['username']);

    final data = await StudentStatsLecturerService()
        .getUsersDisciplinary(widget.data['username']);
    print(data.result);
  }

  @override
  Widget build(BuildContext context) {
    if (isoading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Disciplinary Act",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<GetDisciplinaryForStatsResponse>(
        future: disciplinary_response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(5.0),
                                  ))),
                              onPressed: () {
                                setState(() {
                                  if (penalizeVisibility == true) {
                                    setState(() {
                                      penalizeVisibility = false;
                                    });
                                  } else if (penalizeVisibility ==
                                      false) {
                                    setState(() {
                                      penalizeVisibility = true;
                                    });
                                  }
                                });
                              },
                              child: const Text('Penalize'))
                        ],
                      ),
                    ),
                    Consumer<StatsCommonViewModel>(
                        builder: (context, stats, child) {
                      return isLoading(
                              (stats.disciplinaryApiResponse))
                          ? const Center(
                              child: SpinKitDualRing(
                                  color: kPrimaryColor),
                            )
                          : Container(
                              width: double.infinity,
                              child: Visibility(
                                visible: penalizeVisibility,
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Act Type *",
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5,),
                                        DropdownButtonFormField(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            hintText: 'Select Act Type',
                                          ),
                                          icon: const Icon(Icons
                                              .arrow_drop_down_outlined),
                                          items: stats.act.map((pt) {
                                            return DropdownMenuItem(
                                              value: pt,
                                              child: Text(
                                                pt.level ?? "",
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) async {
                                            setState(() {
                                              selected_act_level =
                                              newVal as String?;
                                              print(
                                                  "IDDDDD:::::::: $selected_act_level");
                                              selectedActId = stats
                                                  .act
                                                  .firstWhere((element) =>
                                              element.level ==
                                                  selected_act_level)
                                                  .id;
                                              selectedActName =
                                                  selected_act_level
                                                      ?.split(" ")
                                                      .join(
                                                      "%20") ??
                                                      "";
                                              _provider
                                                  .fetchDisciplinaryHistoryLevelDetails(
                                                  selectedActName
                                                      .toString());
                                            });
                                          },
                                          value: selected_act_level,
                                        ),
                                        selected_act_level != null
                                            ? isLoading(stats
                                                    .disciplinaryHistoryLevelDetailsApiResponse)
                                                ? VerticalLoader()
                                                : isError(stats
                                                        .disciplinaryHistoryLevelDetailsApiResponse)
                                                    ? SizedBox()
                                                    : stats.levelDetails
                                                                    .result !=
                                                                null ||
                                                            stats
                                                                .levelDetails
                                                                .result!
                                                                .misconducts!
                                                                .isNotEmpty ||
                                                            stats
                                                                .levelDetails
                                                                .result!
                                                                .actions!
                                                                .isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height:
                                                                    10,
                                                              ),
                                                              const Text(
                                                                "Misconduct ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              MultiSelectDialogField(
                                                                items: stats
                                                                    .levelDetails
                                                                    .result!
                                                                    .misconducts!
                                                                    .map((e) => MultiSelectItem(e.toString(), e.toString()))
                                                                    .toList(),
                                                                listType:
                                                                    MultiSelectListType.CHIP,
                                                                initialValue:
                                                                    selectMisconduct,
                                                                autovalidateMode:
                                                                    AutovalidateMode.always,
                                                                onConfirm:
                                                                    (List<String> values) {
                                                                  setState(() {
                                                                    selectMisconduct = values;
                                                                  });
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height:
                                                                    10,
                                                              ),
                                                              const Text(
                                                                "Action ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              MultiSelectDialogField(
                                                                items: stats
                                                                    .levelDetails
                                                                    .result!
                                                                    .actions!
                                                                    .map((e) => MultiSelectItem(e.toString(), e.toString()))
                                                                    .toList(),
                                                                listType:
                                                                    MultiSelectListType.CHIP,
                                                                initialValue:
                                                                selectedActionsList,
                                                                autovalidateMode:
                                                                    AutovalidateMode.always,
                                                                onConfirm:
                                                                    (List<String> values) {
                                                                  setState(() {
                                                                    selectedActionsList = values;
                                                                  });
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height:
                                                                    10,
                                                              ),
                                                              const Text(
                                                                "Remarks *",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _remarksController,
                                                                maxLines:
                                                                    3,
                                                                keyboardType:
                                                                    TextInputType.multiline,
                                                                validator:
                                                                    (text) {
                                                                  if (text == null ||
                                                                      text.isEmpty) {
                                                                    return 'Request cant be empty';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Write Something...',
                                                                  filled:
                                                                      true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior.always,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height:
                                                                    10,
                                                              ),
                                                              const Text(
                                                                "Attach File (Optional)",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                                                                    if (result != null) {
                                                                      file = File(result.files.single.path!);
                                                                      print("LENGTHHH::::::::${file!.length().toString()}");
                                                                      print(result.files.first.name);
                                                                      setState(() {
                                                                        fileName = result.files.first.name;
                                                                      });
                                                                    } else {
                                                                      return;
                                                                    }
                                                                  },
                                                                  child: const ElevatedButton(
                                                                      onPressed: null,
                                                                      child: Text(
                                                                        "Choose File",
                                                                        style: TextStyle(color: Colors.black),
                                                                      ))),
                                                              Text(file ==
                                                                      null
                                                                  ? ""
                                                                  : file!.path.split('/').last),
                                                              const Text(
                                                                "Date *",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border:
                                                                      Border.all(color: Colors.grey, width: 1),
                                                                  borderRadius:
                                                                      BorderRadius.circular(5),
                                                                ),
                                                                child:
                                                                    DateTimePicker(
                                                                  type:
                                                                      DateTimePickerType.date,
                                                                  dateMask:
                                                                      'd MMM, yyyy',
                                                                  firstDate:
                                                                      DateTime(2000),
                                                                  lastDate:
                                                                      DateTime(2100),
                                                                  icon:
                                                                      Icon(Icons.event),
                                                                  dateLabelText:
                                                                      'Date',
                                                                  timeLabelText:
                                                                      "Hour",
                                                                  timePickerEntryModeInput:
                                                                      true,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(() {
                                                                      duedate = DateTime.parse(val);
                                                                      print("THIS IS DATEE:::::${duedate.toString()}");
                                                                    });
                                                                  },
                                                                  validator:
                                                                      (val) {
                                                                    print(val);
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(16.0),
                                                                            ))),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            penalizeVisibility = false;
                                                                          });
                                                                        },
                                                                        child: const Text('Cancel')),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.green),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(16.0),
                                                                            ))),
                                                                        onPressed: () async {
                                                                          if (selectedActId == null || duedate == null || widget.data['username'] == null || _remarksController.text.isEmpty) {
                                                                            Fluttertoast.showToast(msg: 'Please fill all required fields', backgroundColor: Colors.red, textColor: Colors.white);
                                                                          } else {
                                                                            if (_formKey.currentState!.validate()) {
                                                                              try {
                                                                                setState(() {
                                                                                  isoading = true;
                                                                                });
                                                                                print("ACT:::::");
                                                                                Commonresponse res = await DisciplinaryRepo().postDisciplinaryHistory(
                                                                                  PostDisciplinaryHistoryRequest(
                                                                                    level: selectedActId.toString(),
                                                                                    remarks: _remarksController.text,
                                                                                    date: duedate.toString(),
                                                                                    misconducts: selectMisconduct,
                                                                                    actions: selectedActionsList,
                                                                                    username: widget.data['username'],
                                                                                    file: file != null ?file : null,
                                                                                    filename: fileName.toString(),
                                                                                  ),
                                                                                );
                                                                                setState(() {
                                                                                  isoading = true;
                                                                                });
                                                                                if (res.success == true) {
                                                                                  setState(() {
                                                                                    _remarksController.clear();
                                                                                    isoading = false;
                                                                                  });
                                                                                  snackThis(duration: 2, behavior: SnackBarBehavior.floating, context: context, color: Colors.green, content: Text(res.message.toString()));
                                                                                } else {
                                                                                  setState(() {
                                                                                    isoading = false;
                                                                                  });
                                                                                  snackThis(duration: 2, behavior: SnackBarBehavior.floating, context: context, color: Colors.red, content: Text(res.message.toString()));
                                                                                }
                                                                              } catch (e) {
                                                                                setState(() {
                                                                                  isoading = false;
                                                                                });
                                                                                snackThis(duration: 2, behavior: SnackBarBehavior.floating, context: context, color: Colors.green, content: Text(e.toString()));
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                        child: const Text('Save')),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox()
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    }),
                    snapshot.data!.result!.isEmpty
                        ? Column(children: <Widget>[
                            Image.asset(
                                "assets/images/no_content.PNG"),
                            const Text(
                              "No offence committed",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ])
                        : SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount:
                                  snapshot.data?.result?.length,
                              itemBuilder: (context, index) {
                                var datas =
                                    snapshot.data?.result?[index];
                                DateTime committed =
                                    DateTime.parse(datas['date']);

                                committed = committed.add(
                                    const Duration(
                                        hours: 5, minutes: 45));

                                var formattedTime =
                                    DateFormat('yMMMMd')
                                        .format(committed);

                                return Column(
                                  children: [
                                    Card(
                                      child: GFListTile(
                                        title: Text(
                                          "Offence Type: " +
                                              datas['level']['level'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        icon: Text(
                                            formattedTime.toString()),
                                        description: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            const Text("Remarks:"),
                                            Text(datas['remarks'])
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return VerticalLoader();
          }
        },
      ),
    );
  }
}

class PostDisciplinaryHistoryRequest {
  String? level;
  String? remarks;
  String? date;
  List<String>? misconducts;
  List<String>? actions;
  String? username;
  File? file;
  String? filename;

  PostDisciplinaryHistoryRequest(
      {this.level,
      this.remarks,
      this.date,
      this.misconducts,
      this.actions,
      this.username,
      this.file,
      this.filename});

  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "remarks": remarks,
      "date": date,
      "misconducts": misconducts,
      "actions": actions,
      "username": username,
      "file": file,
      "filename": filename,
    };
  }
}
