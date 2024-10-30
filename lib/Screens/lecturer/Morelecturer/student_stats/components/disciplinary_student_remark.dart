import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/helper/custom_loader.dart';
import '../../../../../api/repositories/disciplinary_repo.dart';
import '../../../../../constants.dart';
import '../../../../../response/common_response.dart';
import '../../../../widgets/snack_bar.dart';

class DisciplinaryStudentRemark extends StatefulWidget {
  final String username;
  final String currentUsername;
  const DisciplinaryStudentRemark({Key? key, required this.username, required this.currentUsername})
      : super(key: key);

  @override
  State<DisciplinaryStudentRemark> createState() =>
      _DisciplinaryStudentRemarkState();
}

class _DisciplinaryStudentRemarkState extends State<DisciplinaryStudentRemark> {
  final TextEditingController _remarksController = TextEditingController();
  String fileName = '';
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disciplinary Act"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Remarks *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _remarksController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Request cant be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Write Something...',
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
              "Attach File (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ))),
                  onPressed: () async {
                    if (_remarksController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please enter remarks',
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    } else {
                      try {
                        customLoadStart();
                        print("ACT:::::");

                        Map<String, dynamic> requestData = {
                          "remarks": _remarksController.text,
                          "username": widget.currentUsername,
                        };

                        print(requestData);

                        Commonresponse res = await DisciplinaryRepo()
                            .disciplinaryStudentRemarkRepo(requestData);
                        if (res.success == true) {
                          _remarksController.clear();
                          customLoadStop();
                          snackThis(
                              duration: 2,
                              behavior: SnackBarBehavior.floating,
                              context: context,
                              color: Colors.green,
                              content: Text(res.message.toString()));
                        } else {
                          customLoadStop();
                          snackThis(
                              duration: 2,
                              behavior: SnackBarBehavior.floating,
                              context: context,
                              color: Colors.red,
                              content: Text(res.message.toString()));
                        }
                      } on Exception catch (e) {
                        customLoadStop();
                        snackThis(
                            duration: 2,
                            behavior: SnackBarBehavior.floating,
                            context: context,
                            color: Colors.red,
                            content: Text(e.toString()));
                      } finally {
                        customLoadStop();
                      }
                    }
                  },
                  child: const Text('Save')),
            )
          ],
        ),
      ),
    );
  }
}
