import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/student_stats/add_logs_screen.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import '../../../api/repositories/user_repository.dart';
import '../../../components/custom_input_decoration_widget.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/principal/student_logs_screen.dart';
import '../../widgets/snack_bar.dart';
import '../principal_common_view_model.dart';

class StudentLogScreen extends StatefulWidget {
  final String username;
  const StudentLogScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<StudentLogScreen> createState() => _StudentLogScreenState();
}

class _StudentLogScreenState extends State<StudentLogScreen> {

  late PrinicpalCommonViewModel _provider;

  Future<void> refresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider.fetchStudentLogs(widget.username);
    });
  }

  final _remarksController = TextEditingController();
  final eventController = TextEditingController();
  String? currentStatus;
  String? outDateTime;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(
      builder: (context, commonVM, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            title: const Text(
              "Logs",
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddLogsScreen(username: widget.username,)));
                },
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (isLoading(commonVM.studentLogsApiResponse))
                  const Center(child: CupertinoActivityIndicator())
                else if (commonVM.studentLogs.record == null || commonVM.studentLogs.record!.isEmpty)
                  Image.asset('assets/images/no_content.PNG')
                else ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: commonVM.studentLogs.record?.length,
                  itemBuilder: (context, index) {
                    final event = commonVM.studentLogs.record?[index];
                    String formattedDate = DateFormat('yyyy/MM/dd, EEEE').format(event?.date?.toLocal() ?? DateTime.now());
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        trailing: (event?.recordType == "Gate Pass") ?
                          IconButton(onPressed: (){
                            showStudentLogAlertDialog(context, event!, commonVM);
                              setState(() {
                                eventController.text = event.event.toString();
                                currentStatus = event.recordStatus.toString();
                                _remarksController.text = event.remarks.toString();

                              });
                          }
                          ,icon: const Icon(Icons.edit)) :
                        const SizedBox(),
                        title: Text(event?.event ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Remarks: ${event?.remarks ?? ''}'),
                            Text('Date: ${formattedDate ?? ''}'),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }

  showStudentLogAlertDialog(BuildContext context, Record event, PrinicpalCommonViewModel commonVM) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                child: StatefulBuilder(builder: (context, StateSetter setState) {
                  return SizedBox(
                    height: 530,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                    child: const Icon(Icons.close))),
                            const Text(
                              "Event",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            5.sH,
                            TextFormField(
                              // initialValue: event.event,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Event cannot be empty';
                                }
                                return null;
                              },
                              controller: eventController,
                              keyboardType: TextInputType.text,
                              decoration: customDecoration(),
                            ),
                            10.sH,
                             Column(
                              children: [
                                10.sH,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Current Status",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          5.sH,
                                          DropdownButtonFormField(
                                            validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type';
                                                }
                                                return null;
                                            },
                                            value: currentStatus,
                                            isExpanded: true,
                                            decoration: customDecoration(),
                                            icon: const Icon(
                                                Icons.arrow_drop_down_outlined),
                                            items:
                                            ["Out", "In"].map((pt) {
                                              return DropdownMenuItem(
                                                value: pt,
                                                child: Text(
                                                  pt.toString(),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                currentStatus = newVal as String;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    8.sW, // Add space between the widgets
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentStatus == "In" ? "In Date" : "Out Date",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          5.sH,
                                          DateTimePicker(
                                            type: DateTimePickerType.time,
                                            decoration: const InputDecoration(
                                              suffixIcon: Icon(Icons.timer, color: Colors.grey,),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.redAccent)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.grey)),
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              hintText: "--:-- --",
                                            ),
                                            timeLabelText: "Hour",
                                            timePickerEntryModeInput: true,
                                            onChanged: (val) {
                                              setState(() {
                                                if (val.isNotEmpty) {
                                                  outDateTime = val;
                                                }
                                              });
                                            },
                                            onSaved: (val){
                                              if (val != null && val.isNotEmpty) {
                                                outDateTime = val;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            10.sH,
                            const Text(
                              "Remarks",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            5.sH,
                            TextFormField(
                              controller: _remarksController,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Remarks cant be empty';
                                }
                                return null;
                              },
                              decoration: customDecoration(),
                            ),
                            10.sH,
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: logoTheme,
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      customLoadStart();

                                      String requestData = jsonEncode({
                                        "event": eventController.text,
                                        "remarks": _remarksController.text,
                                        "recordStatus":currentStatus,
                                        if(outDateTime != null && outDateTime != "")
                                          "statusHistory":
                                            {
                                              "value": currentStatus,
                                              "statusTime": outDateTime
                                            }
                                      });

                                      print(requestData);

                                      final res = await UserRepository()
                                          .updateStudentLogs(event.id.toString(), requestData);

                                      if (res.success == true) {
                                        commonVM.fetchStudentLogs(widget.username);
                                        Navigator.of(context).pop();
                                        successSnackThis(
                                            context: context,
                                            content: Text(res.message.toString()));
                                      }
                                      else {
                                        errorSnackThis(
                                            context: context,
                                            content: Text(res.message.toString()));
                                      }
                                    } on Exception catch (e) {
                                      errorSnackThis(
                                          context: context, content: Text(e.toString()));
                                    } finally {
                                      customLoadStop();
                                    }
                                  }
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(fontSize: 17),
                                )),
                            100.sH,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
          );
        });
  }

}


