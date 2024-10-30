import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/homework_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:schoolworkspro_app/request/lecturer/homework_request.dart';
import '../../../../../api/repositories/lecturer/homework_repository.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/custom_loader.dart';
import '../../../../../response/file_upload_response.dart';

class EditHomeWorkScreen extends StatefulWidget {
  final taskData;
  final moduleSlug;
  final moduleTitle;
  const EditHomeWorkScreen(
      {Key? key, this.moduleSlug, required this.taskData, required this.moduleTitle})
      : super(key: key);
  @override
  _EditHomeWorkScreenState createState() =>
      _EditHomeWorkScreenState();
}

class _EditHomeWorkScreenState extends State<EditHomeWorkScreen> {
  late CommonViewModel _provider;
  late HomeworkViewModel _provider2;
  List<String> selected_batch = <String>[];
  String? type_selection;
  HtmlEditorController controller = HtmlEditorController();
  final TextEditingController datecontroller =
      TextEditingController();
  final TextEditingController titleController =
      TextEditingController();
  bool visibility = false;
  DateTime? duedate;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState WidgetsBinding.instance
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider =
          Provider.of<CommonViewModel>(context, listen: false);
      _provider.setSlug(widget.moduleSlug);
      _provider.fetchBatches();

      _provider2 =
          Provider.of<HomeworkViewModel>(context, listen: false);
      // _provider2.fetchHomework("", "");
    });
    datecontroller.text = widget.taskData.dueDate.toString();
    titleController.text = widget.taskData.taskname.toString();
    selected_batch = widget.taskData.batch;
    super.initState();
  }

  Future uploadFile(PlatformFile file) async {
    if (file != null) {

        // PlatformFile file = result.files.first;
        print(file.name);
        print(file.size);
        print(file.extension);
        print(file.path);

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
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Digital Diary",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<CommonViewModel>(
          builder: (context, common, child) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Task Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Provide a title for this lesson',
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Due Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              initialValue: widget.taskData.dueDate.toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              timePickerEntryModeInput: true,
              onChanged: (val) {
                setState(() {
                  duedate = DateTime.parse(val);
                });
              },
              validator: (val) {
                print(val);
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Select Batch/Section",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MultiSelectDialogField(
                // validator: ,
                items: common.batchArr
                    .map((e) =>
                        MultiSelectItem(e.toString(), e.toString()))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                initialValue: widget.taskData.batch,
                autovalidateMode: AutovalidateMode.always,
                onConfirm: (List<String> values) {
                  setState(() {
                    selected_batch = values;
                    print(selected_batch);
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Modules/Subjects",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController()
                  ..text = widget.moduleTitle,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Module',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Content",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                // filePath: ,
                //open link
                shouldEnsureVisible: true,

              hint: "Your text here...",
              initialText: widget.taskData.content),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel")),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green),
                    onPressed: () async {
                      var content = await controller.getText();

                      try {
                        final request = AddHomeworkRequest(
                            dueDate:
                                duedate ?? widget.taskData.dueDate,
                            taskname: titleController.text,
                            batch: selected_batch,
                            content: content,
                            moduleSlug: widget.moduleSlug);
                        inspect(request);
                        final res = await HomeworkRepository()
                            .editHomework(
                                request, widget.taskData.id);
                        if (res.success == true) {
                          Fluttertoast.showToast(
                              msg: res.message.toString());
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(
                              msg: res.message.toString());
                        }
                        common.setLoading(false);
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    child: const Text("Update")),
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        );
      }),
    );
  }
}
