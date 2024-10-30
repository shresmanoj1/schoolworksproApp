// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
import '../../../constants/colors.dart';
import '../../../response/file_upload_response.dart';

class AddActivityScreen extends StatefulWidget {
  final moduleSlug;
  final lessonSlug;
  const AddActivityScreen({Key? key, this.moduleSlug, this.lessonSlug})
      : super(key: key);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final HtmlEditorController controller = HtmlEditorController();

  List<String> selected_batch = <String>[];
  bool visibility = false;
  final TextEditingController datecontroller = new TextEditingController();
  late CommonViewModel _provider;
  DateTime? dueDate;
  bool isloading = false;
  DateTime startDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);

      _provider.setSlug(widget.moduleSlug);
      _provider.fetchlessonbatch(widget.moduleSlug, widget.lessonSlug);
    });
    super.initState();
  }

  Future uploadFile(PlatformFile file) async {
    setState(() {
      isloading = true;
    });
    if (file != null) {

      print(file.name);
      print(file.size);
      print(file.extension);
      print(file.path);


      FileUploadResponse res = await HomeworkRepository().addHomeWorkFile(file.path.toString(), file.name);
      setState(() {
        isloading = true;
      });
      try{
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
      setState(() {
        isloading = false;
      });
      // no file pick

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
        centerTitle: false,
        elevation: 0.0,
        title: const Text(
          "Add Task",
          style: TextStyle(color: white),
        ),
      ),
      body: Consumer2<CommonViewModel, LecturerCommonViewModel>(
          builder: (context, data, lecturer, child) {
        return ListView(
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
              initialValue: DateTime.now().toString(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              timePickerEntryModeInput: true,
              onChanged: (val) {
                setState(() {
                  startDate = DateTime.parse(val);
                  print("THIS IS DATEE:::::${startDate.toString()}");
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
              // initialValue: du.toString(),
              firstDate: DateTime.now(),
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
              items: data.lessonbatchArr.map((e) => MultiSelectItem(e, e)).toList(),
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
              htmlEditorOptions: const HtmlEditorOptions(
                // filePath: ,
                //open link
                  shouldEnsureVisible: true,

                  hint: "Your text here...",
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
                  print(file);
                  var response = await uploadFile(file);
                  print(response);
                  return response;
                },
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeExpandable,

                mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                  print(url);
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

                    if(selected_batch.isEmpty){
                      errorSnackThis(
                          context: context,
                          content: const Text("Please select Batch/Section")
                      );
                      return;
                    }

                    var content = await controller.getText();

                    if(content.isEmpty){
                      errorSnackThis(
                          context: context,
                          content: const Text("Please enter Content")
                      );
                      return;
                    }
                    customLoadStart();

                    final request = AddAssessmentRequest(
                        batches: selected_batch,
                        startDate: startDate.toUtc(),
                        contents: content,
                        dueDate: dueDate?.toUtc(),
                        lessonSlug: widget.lessonSlug,
                        forResitOnly: false,
                        needMultipleSubmissionEditor: false);
                    final res =
                        await Addactivityservice().postAssessment(request);
                    if (res.success == true) {
                      Navigator.of(context).pop();
                      lecturer.fetchinsideactivity(widget.lessonSlug);
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
                  }finally{
                    customLoadStop();
                  }
                },
                child: const Text("Add")),
            100.sH,
          ],
        );
      }),
    );
  }
}
