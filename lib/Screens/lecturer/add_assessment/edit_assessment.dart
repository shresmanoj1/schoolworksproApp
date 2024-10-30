// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/helper/custom_loader.dart';
import 'package:schoolworkspro_app/request/lecturer/addassessment_request.dart';
import 'package:schoolworkspro_app/services/lecturer/addassessment_service.dart';

import '../../../api/repositories/lecturer/homework_repository.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../response/file_upload_response.dart';

class EditActivityScreen extends StatefulWidget {
  final data;
  final String moduleSlug;

  const EditActivityScreen({
    Key? key,
    this.data,
    required this.moduleSlug
  }) : super(key: key);

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final HtmlEditorController controller = HtmlEditorController();

  List<String> selected_batch = <String>[];
  bool visibility = false;
  // final TextEditingController datecontroller = new TextEditingController();
  DateTime? dueDate;
  bool isloading = false;
  DateTime startDate = DateTime.now();
  late CommonViewModel _provider4;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider4 = Provider.of<CommonViewModel>(context, listen: false);

      _provider4.setSlug(widget.moduleSlug);
      _provider4.fetchBatches();
    });

    try{
      selected_batch = List<String>.from(widget.data['batches'] as List<dynamic>);

      DateTime dd = DateTime.parse(widget.data['dueDate'].toString());
      DateTime startDateConvert = widget.data['startDate'] == null ? DateTime.now() : DateTime.parse(widget.data['startDate'].toString());
      setState(() {
        dueDate = dd.toLocal();
        startDate = startDateConvert.toLocal();
      });
    }catch(e){
      print(e);
      setState(() {
        dueDate = DateTime.now();
        startDate = DateTime.now();
      });
    }
    super.initState();
  }

  Future uploadFile(PlatformFile file) async {
    if (file != null) {

      FileUploadResponse res = await HomeworkRepository().addHomeWorkFile(file.path.toString(), file.name);

      try{
        setState(() {
          isloading = true;
        });
        if (res.success == true) {
          controller.insertLink(file.name, res.link.toString(), true);
          setState(() {
            isloading = false;
          });
        }
        else{
          setState(() {
            isloading = false;
          });
        }
      }on Exception catch (e) {
        setState(() {
          isloading = true;
        });
        print("EXCEPTION:::${e.toString()}");
        Navigator.of(context).pop();
        setState(() {
          isloading = false;
        });
      }
    }
    else {
      // no file pick

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Edit Task",
          style: TextStyle(color: white),
        ),
      ),
      body: Consumer2<CommonViewModel, LecturerCommonViewModel>(
          builder: (context, data, lecturer, child) {
        return isLoading(data.atchesApiResponse) ? const Center(child: CupertinoActivityIndicator()) :
        ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            const Text(
              "Start Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy hh:mm a',
              initialValue: startDate.toString(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              timePickerEntryModeInput: true,
              onChanged: (val) {
                setState(() {
                  startDate = DateTime.parse(val);
                });
              },
              validator: (val) {
                print(val);
                return null;
              },
            ),
            10.sH,
            const Text(
              "Due Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy hh:mm a',
              initialValue: DateTime.parse(widget.data['dueDate']).add(const Duration(hours: 5, minutes: 45)).toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              timePickerEntryModeInput: true,
              onChanged: (val) {
                setState(() {
                  dueDate = DateTime.parse(val);
                  print("THIS IS DATEE:::::${dueDate.toString()}");
                });
              },
              validator: (val) {
                print(val);
                return null;
              },
            ),
            10.sH,
            const Text(
              "Select Batches/Sections",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            10.sH,
            MultiSelectDialogField(
              // validator: ,
              items: data.batchArr.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              initialValue: selected_batch,
              autovalidateMode: AutovalidateMode.always,
              onConfirm: (List<String> values) {
                setState(() {
                  selected_batch = values;
                });
              },
            ),
            10.sH,
            const Text(
              "Content",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            10.sH,
            HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                // filePath: ,
                //open link
                shouldEnsureVisible: true,

                hint: "Your text here...",
                initialText: widget.data['contents'],
              ),

              htmlToolbarOptions: HtmlToolbarOptions(
                defaultToolbarButtons: [
                  const StyleButtons(),
                  const FontSettingButtons(),
                  const ListButtons(),
                  const ParagraphButtons(),
                  const InsertButtons(otherFile: true, video: false, audio: false),
                  const OtherButtons(
                    copy: false,
                    paste: false,
                  ),
                ],
                onOtherFileUpload: (file) async {
                  var response = await uploadFile(file);
                  return response;
                },
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeExpandable,

                mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                  return true;
                },
                mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                  return true;
                },
              ),
              otherOptions: OtherOptions(height: 500, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4.0)),),
            ),

            10.sH,
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: logoTheme),
                onPressed: () async {
                  try {
                    print("DUE DAT 222E::${dueDate}");
                    if (dueDate == null) {
                      errorSnackThis(
                          context: context,
                          content: const Text("Please select Due Date")
                      );
                      return;
                    }

                    String formattedDueDate = DateFormat('yyyy-MM-dd').format(dueDate ?? DateTime.now());
                    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

                    DateTime dueFormat = DateTime.parse(formattedDueDate);
                    DateTime startFormat = DateTime.parse(formattedStartDate);

                    if (dueFormat.isBefore(startFormat)) {
                      errorSnackThis(
                          context: context,
                          content: const Text("Due Date must be greater than Start Data")
                      );
                      return;
                    }

                    customLoadStart();
                    var content = await controller.getText();

                    final request = AddAssessmentRequest(
                        batches: selected_batch,
                        contents: content,
                        dueDate: dueDate?.toUtc(),
                        startDate: startDate.toUtc(),
                        forResitOnly: false,
                    );
                    final res = await Addactivityservice()
                        .updateAssessment(request, widget.data['_id']);
                    if (res.success == true) {
                      Navigator.of(context).pop();
                      lecturer.fetchinsideactivity(widget.data["lessonSlug"]);
                      snackThis(
                          context: context,
                          color: Colors.green,
                          duration: 2,
                          content: Text(res.message.toString()));
                    }
                    else {
                      snackThis(
                          context: context,
                          color: Colors.red,
                          duration: 2,
                          content: Text(res.message.toString()));
                    }
                  } on Exception catch (e) {
                    snackThis(
                        context: context,
                        color: Colors.red,
                        duration: 2,
                        content: Text(e.toString()));
                  } finally {
                    customLoadStop();
                  }
                },
                child: const Text("Update")),
            const SizedBox(
              height: 100,
            ),
          ],
        );
      }),
    );
  }
}
