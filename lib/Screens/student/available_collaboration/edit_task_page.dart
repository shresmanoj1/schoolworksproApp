import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/student/available_collaboration/collaboration_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/collaboration_repo.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/response/create_task_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/authenticateduser_response.dart';
import '../../widgets/snack_bar.dart';

class EditTaskScreen extends StatefulWidget {
  final dynamic groupId;
  const EditTaskScreen({Key? key, required this.groupId})
      : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskTitleController;
  TextEditingController dateController = TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();
  final HtmlEditorController detailsController =
  HtmlEditorController();

  DateTime? dueDate;
  DateTime? startDate;
  bool isloading = false;

  List<dynamic> students = <dynamic>[];
  User? user;

  late CollaborationViewModel _provider;
  late CommonViewModel _provider2;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CollaborationViewModel>(context, listen: false);
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider.fetchTaskItem(widget.groupId["assignedToList"]["_id"]).then((_){
        try{
        _taskTitleController = TextEditingController(text: _provider.taskItem.task?.title.toString() ?? "");
        startDate = _provider.taskItem.task?.startDate;
        dueDate = _provider.taskItem.task?.endDate;
        students = _provider.taskItem.task?.assignedTo ?? [];
        }catch(e){

        }

      });
    });
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Consumer<CollaborationViewModel>(
      builder: (context, taskValue, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: logoTheme,
              elevation: 1,
              centerTitle: false,
              title: const Text(
                   "Update A Task" ,
                  style: TextStyle(
                    color: white,),
                  overflow: TextOverflow.ellipsis
              ),
            ),
            body: isLoading(taskValue.taskItemApiResponse) ?
                const Center(child: CupertinoActivityIndicator()) :
                isError(taskValue.taskItemApiResponse) ?
                    Container() :
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Title"),
                        5.sH,
                        TextFormField(
                          validator: (text1) {
                            if (text1 == null || text1.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          controller: _taskTitleController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: widget.groupId["isUpdate"]
                                ? widget.groupId["assignedToList"]["title"]
                                : '# Task 1',
                            filled: true,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                          ),
                        ),
                        10.sH,
                        const Text("Details"),
                        5.sH,
                        HtmlEditor(
                          controller: detailsController,
                          htmlEditorOptions: HtmlEditorOptions(
                            hint: "Your text here...",
                            initialText: taskValue.taskItem.task?.detail,
                          ),
                          htmlToolbarOptions: HtmlToolbarOptions(
                            initiallyExpanded: false,
                            toolbarPosition: ToolbarPosition.aboveEditor,
                            toolbarType: ToolbarType.nativeScrollable,
                            mediaLinkInsertInterceptor:
                                (String url, InsertFileType type) {
                              return true;
                            },
                            mediaUploadInterceptor: (PlatformFile file,
                                InsertFileType type) async {
                              return true;
                            },
                          ),
                        ),
                        10.sH,
                        const Text('Assigned to'),

                        5.sH,
                        MultiSelectDialogField(
                          items: widget.groupId["users"]
                              .map<MultiSelectItem<String>>((e) =>
                              MultiSelectItem(e["_id"].toString(),
                                  e["username"].toString()))
                              .toList(),
                          initialValue: widget.groupId["userId"],
                          listType: MultiSelectListType.CHIP,
                          autovalidateMode: AutovalidateMode.always,
                          onConfirm: (List<dynamic> values) {
                            setState(() {
                              students = (values.toSet()).toList();
                            });
                          },
                        ),

                        _buildDateWidget(title: "Start Date",
                          firstDate: DateTime(2000),
                          initialValue: startDate.toString(),
                          onChanged:  (val) {
                            setState(() {
                              startDate = DateTime.parse(val);
                            });
                          },
                        ),
                        _buildDateWidget(title: "End Date",
                          firstDate:  startDate,
                          initialValue: dueDate.toString(),
                          onChanged:  (val) {
                            setState(() {
                              dueDate = DateTime.parse(val);
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildButton(
                                  title: "Update",
                                  background: logoTheme,
                                  onPressed: onAddPressed,
                                  color: Colors.white
                              ),
                              15.sW,
                              _buildButton(
                                  title: "Cancel",
                                  background: Colors.amber,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: black
                              ),
                            ],
                          ),
                        ),
                        30.sH,
                      ],
                    )),
              ),
            ));
      }
    );
  }
  Widget _buildDateWidget({required String title,
    String? initialValue,
    required DateTime? firstDate, void Function(String)? onChanged}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sH,
        Text(title),
        5.sH,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'd MMM, yyyy',
            initialValue: initialValue,
            firstDate: firstDate,
            lastDate: DateTime(2100),
            icon: const Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            timePickerEntryModeInput: true,
            onChanged: onChanged,
            validator: (val) {
              return null;
            },
          ),
        ),
        5.sH,
      ],
    );
  }

  Widget _buildButton({required String title, void Function()? onPressed, required Color background , required Color color }){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          height: 40,
          // width: 80,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(
                    background),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(4.0),
                    ))),
            child: Text(
              title,
              style:
              TextStyle(fontSize: 14, color: color),
            ),
          ),
        ),
      ),
    );

  }

  void onAddPressed() async {
    try {
      if (_taskTitleController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please enter all fields');
      } else if (students.isEmpty){
        Fluttertoast.showToast(
            msg: "Please Assign Task");
      }
      else if (dueDate == null) {
        Fluttertoast.showToast(
            msg: "End Date can't be empty");
      }
      else {
        customLoadStart();
        var content =
        await detailsController.getText();

        String request = jsonEncode({
          "title": _taskTitleController.text,
          "startDate": startDate.toString(),
          "endDate": dueDate.toString(),
          "detail": content,
          "assignedTo": (students.toSet()).toList(),
        });

        CreateTaskResponse res =
        await CollaborationRepository()
            .createTaskGroup(
             widget.groupId["assignedToList"]["_id"] ,
            request, true);
        if (res.success == true) {
          Navigator.of(context).pop();

          if(context.mounted){
            successSnackThis(
                context: context,
                content: const Text("Task Updated successfully")
            );
          }
        }
        else {
          if(context.mounted){

            errorSnackThis(
                context: context,
                content: const Text("Task Updated failed")
            );
          }
        }
      }
    } on Exception catch (e) {
      errorSnackThis(
          context: context,
          content: const Text("There was an internal server error. Please try again later.")
      );
    } finally {
      customLoadStop();
    }
  }
}
