import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/principal/routine_repo.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../helper/custom_loader.dart';
import '../../widgets/snack_bar.dart';
import '../principal_common_view_model.dart';
import '../../../../response/login_response.dart';
import 'package:intl/intl.dart';

class UpdateRoutineScreen extends StatefulWidget {
  final element;
  final String? routineId;
  const UpdateRoutineScreen(
      {Key? key,
      required this.element,
      required this.routineId})
      : super(key: key);
  @override
  State<UpdateRoutineScreen> createState() => _UpdateRoutineScreenState();
}

class _UpdateRoutineScreenState extends State<UpdateRoutineScreen> {
  late PrinicpalCommonViewModel _provider2;
  late StatsCommonViewModel _provider3;
  User? user;
  TextEditingController? classRoomController;
  TextEditingController? classLinkController;
  final _formKey = GlobalKey<FormState>();
  bool published = false;
  String? selectedClassType;
  String? selectedModuleSlug;
  String? selectedBatch;
  String? selectedLecturer;
  DateTime? effectiveDate;
  String? selectedReplaceModuleSlug;
  String? selectedReplaceLecturer;
  // bool isloading = false;
  bool deleteLoading = false;
  bool cancelLoading = false;
  bool replaceLoading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider2 =
          Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider3 = Provider.of<StatsCommonViewModel>(context, listen: false);
    });
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    if (widget.element != null) {
      try {
        print("DATE EFFECTIVE::${widget.element["effectiveDate"]}");
        published = widget.element["published"] ?? false;
        selectedClassType = widget.element["classType"];
        selectedLecturer = widget.element["lecturer"]["email"];
        selectedReplaceLecturer = widget.element["lecturer"]["email"];
        classRoomController =
            TextEditingController(text: widget.element["classRoom"].toString());
        classLinkController =
            TextEditingController(text: widget.element["classLink"].toString());
        _provider2.fetchallteacher();
        _provider3.fetchAllBatch().then((_) {
          try {
            for (var i = 0; i < _provider3.allbatches.length; i++) {

              if (widget.element["batch"] != null) {
                if (widget.element["batch"] == _provider3.allbatches[i].batch) {
                  selectedBatch = widget.element["batch"];
                  break;
                }
              } else if (widget.element["batch"] != null) {
                if (widget.element["batch"] == _provider3.allbatches[i].batch) {
                  selectedBatch = widget.element["batch"];
                  break;
                }
              } else {}
            }
            Map<String, dynamic> request = {
              "batch": widget.element["batch"],
              "institution": user?.institution.toString()
            };
            _provider2.fetchAccessedModules(request).then((_) {
              try {

                for (var i = 0;
                    i < _provider2.accessModules.modules!.length;
                    i++) {
                  if (_provider2.accessModules.modules![i].moduleSlug == widget.element["moduleSlug"]) {
                    selectedModuleSlug = widget.element["moduleSlug"];
                    selectedReplaceModuleSlug = widget.element["moduleSlug"];
                    break;
                  }
                }
              } catch (e) {
              }
            });

            Map<String, dynamic> datass = {
              "batch": selectedBatch,
              "end": widget.element['end'],
              "lecturer": selectedLecturer,
              "start": widget.element['start'],
            };
            _provider3.fetchAvailableLecturerRoutine(datass);
          } catch (e) {}
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, StatsCommonViewModel>(
        builder: (context, snapshot, stats, child) {
      return Scaffold(
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0.0,
              actions: [
                !widget.element['published']
                    ? const SizedBox()
                    : isLoading(stats.availableLecturerRoutineApiResponse)
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              replaceRoutineDialog(
                                  context,
                                  widget.element["title"].toString(),
                                  widget.routineId.toString(),
                                  stats,
                                  snapshot);
                            },
                            icon: const Icon(
                              Icons.compare_arrows_outlined,
                              size: 28,
                            ),
                          )
              ],
              title: const Text("Update Routine",
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white),
          body: isLoading(snapshot.accessModulesApiResponse) ||
                  isLoading(snapshot.allteacherApiResponse) ||
                  isLoading(stats.allbatchtaffApiResponse) ||
                  isLoading(stats.availableLecturerRoutineApiResponse)
              ? const VerticalLoader()
              : SafeArea(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              !widget.element['published']
                                  ? SizedBox()
                                  : widget.element['isCancelled'] == null ||
                                          !widget.element['isCancelled']
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 15.0),
                                          child: SizedBox(
                                            height: 38,
                                            width: 135,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color(0XFFdc3545)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ))),
                                              onPressed: cancelLoading == true
                                                  ? () {}
                                                  : () {
                                                      showCancelRoutineAlertDialog(
                                                          context,
                                                          widget.routineId
                                                              .toString());
                                                    },
                                              child: cancelLoading == true
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : const Text("Cancel Routine",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white)),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 15.0),
                                          child: SizedBox(
                                            height: 40,
                                            width: 154,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color(0XFFdc3545)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ))),
                                              onPressed: () {
                                                showReinstateRoutineAlertDialog(
                                                    context,
                                                    widget.routineId
                                                        .toString());
                                              },
                                              child: const Text(
                                                  "Reinstate Routine",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                          const Text(
                            'Class Type:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              border: OutlineInputBorder(),
                              filled: true,
                              hintText: 'Select class type',
                            ),
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            items: [
                              "Lab",
                              "Theory",
                              "Lecture",
                              "Workshop",
                              "Tutorial",
                              "Extra"
                            ].map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) async {
                              setState(() {
                                selectedClassType = newVal as String;
                              });
                            },
                            value: selectedClassType,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Module/Subject:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  hintText: 'Select Module/Subject',
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                items:
                                    snapshot.accessModules.modules?.map((item) {
                                  return DropdownMenuItem(
                                    value: item.moduleSlug.toString(),
                                    child: Text(
                                      item.moduleTitle.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) async {
                                  setState(() {
                                    selectedModuleSlug = newVal as String;
                                  });
                                },
                                value: selectedModuleSlug,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Section Batch:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  hintText: 'Select Section/Batch',
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                items: stats.allbatches.map((item) {
                                  return DropdownMenuItem(
                                    value: item.batch.toString(),
                                    child: Text(
                                      item.batch.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) async {
                                  setState(() {
                                    selectedBatch = newVal as String;
                                    Map<String, dynamic> request = {
                                      "batch": selectedBatch,
                                      "institution":
                                          user?.institution.toString()
                                    };
                                    _provider2
                                        .fetchAccessedModules(request)
                                        .then((_) {
                                      try {
                                        for (var i = 0;
                                            i <
                                                _provider2.accessModules
                                                    .modules!.length;
                                            i++) {
                                          if (_provider2.accessModules
                                                  .modules![i].moduleSlug ==
                                              widget.element["moduleSlug"]) {
                                            selectedModuleSlug =
                                                widget.element["moduleSlug"];
                                            selectedReplaceModuleSlug =
                                                widget.element["moduleSlug"];
                                            break;
                                          }
                                        }
                                      } catch (e) {
                                        print("${e.toString()}");
                                      }
                                    });
                                  });
                                },
                                value: selectedBatch,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Classroom',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: classRoomController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Class Link',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: classLinkController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lecturer/Teacher',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black38)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  hintText: 'Select Lecturer/Teacher',
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                items: snapshot.allteacher.map((item) {
                                  return DropdownMenuItem(
                                    value: item.email.toString(),
                                    child: Text(
                                      "${item.firstname} ${item.lastname}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) async {
                                  setState(() {
                                    selectedLecturer = newVal as String;
                                  });
                                },
                                value: selectedLecturer,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Effective Date',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'd MMM, yyyy',
                                initialValue:
                                    widget.element["effectiveDate"] == null
                                        ? effectiveDate.toString()
                                        : DateTime.parse(
                                                widget.element["effectiveDate"])
                                            .add(const Duration(
                                                hours: 5, minutes: 45))
                                            .toString(),
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38)),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    hintText: "dd/mm/yy"),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: const Icon(Icons.event),
                                dateLabelText: 'Date',
                                timeLabelText: "Hour",
                                timePickerEntryModeInput: true,
                                onChanged: (val) {
                                  setState(() {
                                    effectiveDate = DateTime.parse(val);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              CupertinoSwitch(
                                activeColor: CupertinoColors.activeBlue,
                                trackColor: CupertinoColors.inactiveGray,
                                thumbColor: CupertinoColors.white,
                                value: published,
                                onChanged: (value) {
                                  setState(() {
                                    published = value;
                                  });
                                },
                              ),
                              const Text(
                                "Published",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 76,
                                  child: ElevatedButton(
                                    onPressed: deleteLoading == true
                                        ? () {}
                                        : () async {
                                            showDeleteRoutineAlertDialog(
                                                context,
                                                widget.routineId.toString());
                                          },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ))),
                                    child: deleteLoading == true
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : const Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 15.0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 78,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 15.0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 82,
                                      child: ElevatedButton(
                                        onPressed: () {
                                                updateRoutine(widget.routineId
                                                    .toString());
                                              },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blueAccent),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                        child:const Text(
                                                "Update",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                        ],
                      )),
                )));
    });
  }

  void updateRoutine(String id) async {
    try {
      if (_formKey.currentState!.validate()) {

        if(selectedModuleSlug == null) {
          errorSnackThis(
              context: context,
              content: const Text("Please select Module/Subject")
          );
          return;
        } else if (selectedBatch == null) {
          errorSnackThis(
              context: context,
              content: const Text("Please select Batch")
          );
          return;
        }
        // else if (selectedBatch == null) {
        //   errorSnackThis(
        //       context: context,
        //       content: const Text("Please select Lecturer/Teacher")
        //   );
        //   return;
        // }

        Map<String, dynamic> request = {
          "batch": selectedBatch,
          "block": "",
          "classLink": classLinkController?.text,
          "classRoom": classRoomController?.text,
          "classType": selectedClassType,
          "effectiveDate":
              effectiveDate == null ? effectiveDate : effectiveDate.toString(),
          "lecturer": selectedLecturer,
          "moduleSlug": selectedModuleSlug,
          "published": published,
          "title": widget.element["title"]
        };

        print(request);
        customLoadStart();
        Commonresponse res =
            await RoutineRepository().updateRoutineP(request, id);
        if (res.success == true) {
          Navigator.pop(context);
          successSnackThis(
              context: context,
              content: Text(res.message.toString())
          );
        }
        else {
          errorSnackThis(
              context: context,
              content: Text(res.message.toString())
          );
        }
      }
    } on Exception catch (e){

      snackThis(
          context: context,
          content: Text(e.toString()),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
    finally {
      customLoadStop();
    }
  }

  replaceRoutineDialog(BuildContext context, String module, String id,
      StatsCommonViewModel stats, PrinicpalCommonViewModel snapshot) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Replace Routine",
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.compare_arrows_outlined),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        stats.availableLecturerRoutine.topPriority != null &&
                                stats.availableLecturerRoutine.topPriority!
                                    .isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Available Lecturer/Teacher",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                      height: 135,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: stats
                                              .availableLecturerRoutine
                                              .topPriority!
                                              .length,
                                          itemBuilder: (context, index) {
                                            print(stats
                                                .availableLecturerRoutine
                                                .topPriority![index]
                                                .lecturer!
                                                .firstname);
                                            return Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        "${stats.availableLecturerRoutine.topPriority![index].lecturer!.firstname} ${stats.availableLecturerRoutine.topPriority![index].lecturer!.lastname}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green,
                                                        ))),
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text:
                                                          '  (${DateFormat('hh:mm a').format(stats.availableLecturerRoutine.topPriority![index].start!.toLocal())} ',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green,
                                                      ),
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                          text: "-",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "${DateFormat('hh:mm a').format(stats.availableLecturerRoutine.topPriority![index].end!.toLocal())})",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: !replaceLoading
                                                              ? () {
                                                                  replaceRoutine(
                                                                      id,
                                                                      module
                                                                          .toString(),
                                                                      stats
                                                                          .availableLecturerRoutine
                                                                          .topPriority![
                                                                              index]
                                                                          .lecturer!
                                                                          .email
                                                                          .toString());
                                                                }
                                                              : () {},
                                                          child: Container(
                                                            height: 24,
                                                            width: 60,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: Colors
                                                                    .blueAccent),
                                                            child: const Center(
                                                                child: Text(
                                                              "select",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }))
                                ],
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Current Subject/Module",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          module.toString(),
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Replace With",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38)),
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Select Module/Subject',
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: snapshot.accessModules.modules?.map((item) {
                            return DropdownMenuItem(
                              value: item.moduleSlug.toString(),
                              child: Text(
                                item.moduleTitle.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) async {
                            setState(() {
                              selectedReplaceModuleSlug = newVal as String;
                            });
                          },
                          value: selectedReplaceModuleSlug,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Teacher/Lecturer",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38)),
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Select Lecturer/Teacher',
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: snapshot.allteacher.map((item) {
                            return DropdownMenuItem(
                              value: item.email.toString(),
                              child: Text(
                                "${item.firstname} ${item.lastname}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) async {
                            setState(() {
                              selectedReplaceLecturer = newVal as String;
                            });
                          },
                          value: selectedReplaceLecturer,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 15.0),
                              child: SizedBox(
                                height: 40,
                                width: 88,
                                child: ElevatedButton(
                                  onPressed: !replaceLoading
                                      ? () {
                                          replaceRoutine(
                                              id,
                                              module.toString(),
                                              selectedReplaceLecturer
                                                  .toString());
                                        }
                                      : () {},
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blueAccent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ))),
                                  child: !replaceLoading
                                      ? const Text(
                                          "Replace",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        )
                                      : const Center(
                                          child: SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: CircularProgressIndicator(),
                                        )),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 15.0),
                              child: SizedBox(
                                height: 40,
                                width: 78,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ))),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  showDeleteRoutineAlertDialog(BuildContext context, dynamic id) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes, Delete this routine"),
      onPressed: () async {
        Navigator.pop(context);
        deleteRoutine(widget.routineId.toString());
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Routine"),
      content: const Text(
          "Are you sure you want to delete this routine? This action cannot be undone!"),
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

  showCancelRoutineAlertDialog(BuildContext context, dynamic id) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes, cancel this routine"),
      onPressed: () async {
        Navigator.pop(context);
        cancelRoutine(widget.routineId.toString(), true);
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Cancel Routine"),
      content: const Text(
          "The very next occurrence of this routine will be cancelled. If you want to cancel all the occurrences of this routine, please unpublish the routine. Are you sure you want to cancel this routine? This action cannot be undone. All the students and lecturer associated with this routine will be notified."),
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

  showReinstateRoutineAlertDialog(BuildContext context, dynamic id) {
    Widget okButton = ElevatedButton(
      child: const Text("Yes, Restore!"),
      onPressed: () async {
        Navigator.pop(context);
        cancelRoutine(widget.routineId.toString(), false);
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Restore Routine"),
      content: const Text(
          "Are you sure you want to restore this routine? This action cannot be undone. All the students and lecturer associated with this routine will be notified."),
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

  void replaceRoutine(String id, String title, String lecturer) async {
    setState(() {
      replaceLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        Map<String, dynamic> request = {
          "title": title,
          "lecturer": lecturer,
          "moduleSlug": selectedModuleSlug,
        };
        setState(() {
          replaceLoading = true;
        });
        Commonresponse res =
            await RoutineRepository().replaceRoutineP(request, id);
        if (res.success == true) {
          setState(() {
            replaceLoading = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
          snackThis(
              context: context,
              content: Text(res.message.toString()),
              color: Colors.green,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        } else {
          setState(() {
            replaceLoading = false;
          });
          snackThis(
              context: context,
              content: Text(res.message.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        }
      }
    } catch (e) {
      setState(() {
        replaceLoading = false;
      });
      snackThis(
          context: context,
          content: Text(e.toString()),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }

  void deleteRoutine(String id) async {
    setState(() {
      deleteLoading = true;
    });
    try {
      setState(() {
        deleteLoading = true;
      });
      Commonresponse res = await RoutineRepository().deleteRoutineP(id);
      if (res.success == true) {
        setState(() {
          deleteLoading = false;
        });
        Navigator.pop(context);
        snackThis(
            context: context,
            content: Text(res.message.toString()),
            color: Colors.green,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      } else {
        setState(() {
          deleteLoading = false;
        });
        snackThis(
            context: context,
            content: Text(res.message.toString()),
            color: Colors.red,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      }
    } catch (e) {
      setState(() {
        deleteLoading = false;
      });
      snackThis(
          context: context,
          content: Text(e.toString()),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }

  void cancelRoutine(String id, bool cancelState) async {
    setState(() {
      cancelLoading = true;
    });
    try {
      Map<String, dynamic> request = {
        "isCancel": cancelState,
      };
      setState(() {
        cancelLoading = true;
      });
      Commonresponse res = await RoutineRepository().cancelRoutine(request, id);
      if (res.success == true) {
        setState(() {
          cancelLoading = false;
        });
        Navigator.pop(context);
        snackThis(
            context: context,
            content: Text(res.message.toString()),
            color: Colors.green,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      } else {
        setState(() {
          cancelLoading = false;
        });
        snackThis(
            context: context,
            content: Text(res.message.toString()),
            color: Colors.red,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      }
    } catch (e) {
      setState(() {
        cancelLoading = false;
      });
      snackThis(
          context: context,
          content: Text(e.toString()),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }
}
