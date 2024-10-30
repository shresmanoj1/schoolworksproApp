import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../api/repositories/lecturer/homework_repository.dart';
import '../../components/shimmer.dart';

import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../response/file_upload_response.dart';
import '../../response/login_response.dart';
import '../prinicpal/stats_common_view_model.dart';

class AddRequestLetterScreen extends StatefulWidget {
  const AddRequestLetterScreen({Key? key}) : super(key: key);

  @override
  _AddRequestLetterScreenState createState() => _AddRequestLetterScreenState();
}

class _AddRequestLetterScreenState extends State<AddRequestLetterScreen> {
  late StatsCommonViewModel _provider;

  bool isloading = false;

  String? letterType;
  HtmlEditorController controller = new HtmlEditorController();

  int totalDays = 0;

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
  //     _provider.fetchCertificateNames();
  //   });
  //   super.initState();
  // }

  final _formKey = GlobalKey<FormState>();

  Future uploadFile(PlatformFile file) async {
    if (file != null) {
      // PlatformFile file = result.files.first;
      print(file.name);
      print(file.size);
      print(file.extension);
      print(file.path);

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
      body: SingleChildScrollView(
        child: Consumer<StatsCommonViewModel>(builder: (context, stats, child) {
          return isLoading(stats.certificateNamesApiResponse)
              ? const VerticalLoader()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Select Letter Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          items: stats.certificateNames.map((pt) {
                            return DropdownMenuItem(
                              value: pt.id,
                              child: Text(pt.builderName.toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              letterType = newVal as String?;
                              print("TEST::::$letterType");
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select subject';
                            }
                            return null;
                          },
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Select Subject',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          value: letterType,
                        ),
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
                          otherOptions: OtherOptions(height: 300,decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4.0)),),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: SizedBox(
                              height: 40,
                              width: 95,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(solidRed),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel",
                                    style:
                                        TextStyle(fontSize: 14, color: white)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: SizedBox(
                              height: 40,
                              width: 95,
                              child: ElevatedButton(
                                onPressed: isloading == true
                                    ? () {}
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          var content =
                                              await controller.getText();
                                          final request = jsonEncode({
                                            "certificate": letterType,
                                            "content": content,
                                            "letterType": letterType
                                          });
                                          requestLetter(request);
                                        }
                                      },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(logoTheme),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                child: isloading == true
                                    ? CircularProgressIndicator()
                                    : const Text(
                                        "Request",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  requestLetter(data) async {
    setState(() {
      isloading = true;
    });
    try {
      final result = await StatsRepository().addRequestLetter(data);
      if (result.success == true) {
        setState(() {
          isloading = false;
        });
        snackThis(
            context: context,
            color: Colors.green,
            content: Text(result.message.toString()));
      } else {
        setState(() {
          isloading = false;
          ;
        });
        snackThis(
            context: context,
            color: Colors.green,
            content: Text(result.message.toString()));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }
}
