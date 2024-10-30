import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/request/journal_request.dart';

import '../../../api/repositories/Journal_repository.dart';
import '../../../api/repositories/lecturer/homework_repository.dart';
import '../../../constants.dart';
import '../../../constants/fonts.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/fetchjournal_response.dart';
import '../../../response/file_upload_response.dart';
import 'my_journal.dart';

class AddJournal extends StatefulWidget {
  final title;
  final intro;
  final content;
  final slug;
  final previewImage;
  const AddJournal({Key? key, this.title, this.intro, this.content, this.slug, this.previewImage})
      : super(key: key);

  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  final title_controller = new TextEditingController();
  final introduction_controller = new TextEditingController();
  HtmlEditorController controller = new HtmlEditorController();

  bool isloading = false;
  @override
  void initState() {

    title_controller.text = widget.title;
    introduction_controller.text = widget.intro;

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
        setState(() {
          isloading = false;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Consumer<CommonViewModel>(
      builder: (context, common, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: logoTheme,
            title: Text(
              widget.title == "" ? "Add Journal" : "Update Journal",
              style: const TextStyle(color: kWhite),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(

                controller: title_controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(

                  hintText: 'Journal Title',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Introduction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.orangeAccent.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Note: This will be the first section that you viewers will see",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(

                controller: introduction_controller,
                keyboardType: TextInputType.text,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Journal Introduction',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Content',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              HtmlEditor(

                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                    // filePath: ,
                    //open link
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
                  customToolbarButtons: [
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
                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    return true;
                  },
                ),
                otherOptions: OtherOptions(height: 300, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4.0)),),
              ),
              widget.title == ""
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: logoTheme),
                      onPressed: () async {
                        try {
                          var content = await controller.getText();
                          final data = Journalrequest(
                              content: content,
                              title: title_controller.text,
                              intro: introduction_controller.text);
                          final res = await JournalRepository().postJournal(data);
                          if (res.success == true) {
                            setState(() {
                              isloading = true;
                            });
                            common.fetchmyJourney();

                            snackThis(
                                context: context,
                                content: Text(res.message.toString()),
                                color: Colors.green);
                            title_controller.clear();
                            introduction_controller.clear();
                            controller.clear();
                            Navigator.of(context).pop();



                            setState(() {
                              isloading = false;
                            });
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            snackThis(
                                context: context,
                                content: Text(res.message.toString()),
                                color: Colors.red);

                            setState(() {
                              isloading = false;
                            });
                          }
                        } on Exception catch (e) {
                          setState(() {
                            isloading = true;
                          });
                          snackThis(
                              context: context,
                              content: Text(e.toString()),
                              color: Colors.red);

                          setState(() {
                            isloading = false;
                          });
                          // TODO
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: p1),
                      ))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: logoTheme),
                      onPressed: () async {
                        try {
                          var content = await controller.getText();
                          final data = Journalrequest(
                              content: content,
                              title: title_controller.text,
                              intro: introduction_controller.text);
                          final res = await JournalRepository()
                              .updateJournal(data, widget.slug);

                          if (res.message != null) {
                            snackThis(
                                context: context,
                                content: Text('Journal updated successfully'),
                                color: Colors.green);
                            common.fetchmyJourney();
                          }

                          title_controller.clear();
                          introduction_controller.clear();
                          controller.clear();
                          Navigator.of(context).pop();
                          // Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (context) => MyJournal()));

                          setState(() {
                            isloading = false;
                          });
                        } catch (e) {
                          // Handle error
                          setState(() {
                            isloading = true;
                          });
                          snackThis(
                              context: context,
                              content: Text(e.toString()),
                              color: Colors.red);
                          setState(() {
                            isloading = false;
                          });
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: p1, fontWeight: FontWeight.w900),
                      )),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        );
      }
    );
  }
}


