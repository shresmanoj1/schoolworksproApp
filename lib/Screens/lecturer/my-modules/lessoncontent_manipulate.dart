import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/NumberIncDec.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/request/lecturer/addlesson_request.dart';
import 'package:schoolworkspro_app/response/lecturer/addlesson_response.dart';
import 'package:schoolworkspro_app/services/lecturer/addlesson_service.dart';

import '../../../api/repositories/lecturer/homework_repository.dart';
import '../../../response/file_upload_response.dart';

class LessonContentManipulate extends StatefulWidget {
  final title;
  final module;
  final week;
  final type;
  final content;
  final lesson_slug;
  String moduleTitle;

  bool? update;

  LessonContentManipulate(
      {Key? key,
      this.title,
      this.update,
      this.module,
      this.week,
      this.type,
      this.content,
      required this.moduleTitle,
      this.lesson_slug})
      : super(key: key);

  @override
  _LessonContentManipulateState createState() =>
      _LessonContentManipulateState();
}

class _LessonContentManipulateState extends State<LessonContentManipulate> {
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController modulecontroller = new TextEditingController();
  final TextEditingController weekcontrolelr = new TextEditingController();
  final TextEditingController typecontroller = new TextEditingController();
  HtmlEditorController controller = new HtmlEditorController();
  List type = ["public", "private"];

  String type_selection = "public";
  bool isloading = false;
  bool postIsLoading = false;
  bool updateIsLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    modulecontroller.text = widget.module;
    weekcontrolelr.text = widget.week.toString();
    titleController.text = widget.title ?? "";

    super.initState();
  }

  Future uploadFile(PlatformFile file) async {
    if (file != null) {

      FileUploadResponse res = await HomeworkRepository()
          .addHomeWorkFile(file.path.toString(), file.name);

      try {
        setState(() {
          isloading = true;
        });
        if (res.success == true) {
          controller.insertLink(file.name, res.link.toString(), true);
          setState(() {
            isloading = false;
          });
        } else {
          setState(() {
            isloading = false;
          });
        }
      } on Exception catch (e) {
        setState(() {
          isloading = true;
        });
        print("EXCEPTION:::${e.toString()}");
        Navigator.of(context).pop();
        setState(() {
          isloading = false;
        });
      }
    } else {
      // no file pick
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add/Update Lesson",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Consumer<LecturerCommonViewModel>(builder: (context, value, child) {
        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Title",
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
                "Modules/Subjects",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: widget.moduleTitle,
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Week",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        NumberIncDec(
                          controller: weekcontrolelr,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Type (private type won't be publish. (draft))",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: type_selection,
                            items: type.map((ss) {
                              return DropdownMenuItem(
                                value: ss,
                                child: Text(ss),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                type_selection = value as String;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              hintText: 'Select type',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Content",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlEditor(
                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                    shouldEnsureVisible: true,
                    hint: "Your text here...",
                    initialText: widget.content),
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    const StyleButtons(),
                    const FontSettingButtons(),
                    const ListButtons(),
                    const ParagraphButtons(),
                    const InsertButtons(
                        otherFile: true, video: false, audio: false),
                    const OtherButtons(
                      copy: false,
                      paste: false,
                    ),
                  ],
                  onOtherFileUpload: (file) async {
                    print(file);
                    await uploadFile(file);
                    // print(response);
                    // return response;
                  },
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  toolbarType: ToolbarType.nativeExpandable,
                  mediaLinkInsertInterceptor:
                      (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    return true;
                  },
                ),
                otherOptions: OtherOptions(
                  height: 300,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                  child: SizedBox(
                    height: 40,
                    width: 95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel",
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    ),
                  ),
                ),
                widget.update == true
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          height: 40,
                          width: 95,
                          child: updateIsLoading == false ?
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  updateIsLoading = true;
                                });
                                var content = await controller.getText();
                                final data = AddLessonRequest(
                                    type: type_selection.toString(),
                                    audioEnabled: false,
                                    lessonTitle: titleController.text,
                                    week: int.parse(weekcontrolelr.text),
                                    moduleSlug: modulecontroller.text,
                                    lessonContents: content);
                                final res = await AddLessonService()
                                    .updateLesson(data, widget.lesson_slug);

                                if (res.success == true) {
                                  setState(() {
                                    updateIsLoading = false;
                                  });
                                  Navigator.of(context).pop();

                                  value.setSlug(widget.module);
                                  value.fetchlessons();
                                  snackThis(
                                      context: context,
                                      color: Colors.green,
                                      duration: 2,
                                      content:
                                          Text("lesson updated successfully"));
                                } else {
                                  setState(() {
                                    updateIsLoading = false;
                                  });
                                  snackThis(
                                      context: context,
                                      color: Colors.red,
                                      duration: 2,
                                      content: Text("Failed to update lesson"));
                                }
                              } catch (e) {
                                setState(() {
                                  updateIsLoading = false;
                                });
                                snackThis(
                                    context: context,
                                    color: Colors.red,
                                    duration: 2,
                                    content: Text(e.toString()));
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
                              "Update",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ) : const Center(child: CircularProgressIndicator(),),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: SizedBox(
                          height: 40,
                          width: 95,
                          child: postIsLoading == false ?
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  postIsLoading = true;
                                });
                                var content = await controller.getText();
                                final data = AddLessonRequest(
                                    type: type_selection.toString(),
                                    audioEnabled: false,
                                    lessonTitle: titleController.text,
                                    week: int.parse(weekcontrolelr.text),
                                    moduleSlug: modulecontroller.text,
                                    lessonContents: content);
                                final res =
                                    await AddLessonService().postlesson(data);

                                if (res.success == true) {
                                  setState(() {
                                    postIsLoading = false;
                                  });
                                  Navigator.of(context).pop();

                                  value.setSlug(widget.module);
                                  value.fetchlessons();
                                  snackThis(
                                      context: context,
                                      color: Colors.green,
                                      duration: 2,
                                      content: Text(res.message.toString()));
                                } else {
                                  setState(() {
                                    postIsLoading = false;
                                  });
                                  snackThis(
                                      context: context,
                                      color: Colors.red,
                                      duration: 2,
                                      content: Text(res.message.toString()));
                                }
                              } catch (e) {
                                setState(() {
                                  postIsLoading = false;
                                });
                                snackThis(
                                    context: context,
                                    color: Colors.red,
                                    duration: 2,
                                    content: Text(e.toString()));
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
                              "Post",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ) : const Center(child: CircularProgressIndicator()),
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        );
      }),
    );
  }
}
