import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/document_service.dart';

import '../../../constants/colors.dart';

class Slccertificate extends StatefulWidget {
  final String identifier;
  const Slccertificate({Key? key, required this.identifier}) : super(key: key);

  @override
  _SlccertificateState createState() => _SlccertificateState();
}

class _SlccertificateState extends State<Slccertificate> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
        print("IMAGE SELECTED:::");
      } else {
        print('No image selected.');
      }
    });
  }

  Widget bottomSheet() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "choose photo",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colors.red),
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.identifier.toString(),
          style: const TextStyle(color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'File',
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        color: grey_200,
                        borderRadius: BorderRadius.circular(10)),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          // color: logoTheme2,
                          size: 40,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Upload PNG,JPG, PDF',
                            style: TextStyle(
                              color: grey_400,
                            )),
                      ],
                    ),
                  )),
            ),
            _imageFile != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Row(
                              children: [
                                _imageFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              FileImage(File(_imageFile!.path)),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                              },
                                              child: Text("Remove",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.red.shade500)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_imageFile == null) {
                    snackThis(
                        context: context,
                        content: Text(
                            "You need to select image for ${widget.identifier.toString()} to upload"),
                        color: Colors.red,
                        duration: 1,
                        behavior: SnackBarBehavior.floating);
                  }

                  String docIdentifier = "";

                  if (widget.identifier == "School Character Certificate") {
                    docIdentifier = "school_character_certificate";
                  } else if (widget.identifier == "SEE/SLC Marksheet") {
                    docIdentifier = "see_slc_marksheet";
                  } else if (widget.identifier ==
                      "HSEB Character Certificate") {
                    docIdentifier = "HSEB Character Certificate";
                  } else if (widget.identifier == "HSEB Transcript") {
                    docIdentifier = "HSEB Transcript";
                  } else if (widget.identifier == "Undergraduate Certificate") {
                    docIdentifier = "Undergraduate Certificate";
                  } else if (widget.identifier == "Undergraduate Transcript") {
                    docIdentifier = "Undergraduate Transcript";
                  } else if (widget.identifier == "Medical History") {
                    docIdentifier = "Medical History";
                  } else if (widget.identifier == "Citizenship") {
                    docIdentifier = "Citizenship";
                  }

                  print("IMAGE SELECTED:::${docIdentifier}:::${_imageFile}");

                  final result = await DocumentService().addDocuments(
                      "personal", docIdentifier.toString(), _imageFile!);
                  if (result.success == true && context.mounted) {

                    setState(() {
                      _imageFile = null;
                    });
                    snackThis(
                        context: context,
                        content: Text(result.message.toString()),
                        color: Colors.green,
                        duration: 1,
                        behavior: SnackBarBehavior.floating);
                    Navigator.pop(context);
                  } else {
                    snackThis(
                        context: context,
                        content: Text(result.message.toString()),
                        color: Colors.red,
                        duration: 1,
                        behavior: SnackBarBehavior.floating);
                  }
                },
                child: const Text("Upload"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
