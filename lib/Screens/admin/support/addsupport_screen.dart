import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/admin/support_request.dart';

import '../../../helper/custom_loader.dart';

class AddSupportScreen extends StatefulWidget {
  const AddSupportScreen({Key? key}) : super(key: key);

  @override
  _AddSupportScreenState createState() => _AddSupportScreenState();
}

class _AddSupportScreenState extends State<AddSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topic_controller = TextEditingController();
  final TextEditingController request_controller = TextEditingController();
  PickedFile? _imageFile;
  bool isloading = false;

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Widget bottomSheet(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text(
          "Request Support",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topic(),
                    const SizedBox(
                      height: 10,
                    ),
                    _request(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Attach File (Optional)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(context)));
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text('Upload Image'),
                              ),
                            ),
                          ),
                        ),
                        // child: const ElevatedButton(
                        //     onPressed: null, child: Text("Choose File"))
                      ),
                    ),
                    _imageFile == null
                        ? const SizedBox(
                            height: 1,
                          )
                        : Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(
                                    _imageFile!.path,
                                  ),
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              Positioned(
                                top: -8,
                                right: -2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: SizedBox(
                            height: 40,
                            width: 95,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_imageFile != null) {
                                    try {
                                      setState(() {
                                        isloading = true;
                                      });
                                      final res = await Supportservice()
                                          .addsupportwithimage(
                                              request_controller.text,
                                              topic_controller.text,
                                              _imageFile!);

                                      if (res.success == true) {

                                        setState(() {
                                          isloading = true;
                                        });
                                        Fluttertoast.showToast(
                                            msg: res.message.toString());
                                        setState(() {
                                          isloading = false;
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        setState(() {
                                          isloading = true;
                                        });
                                        Fluttertoast.showToast(
                                            msg: res.message.toString());
                                        setState(() {
                                          isloading = false;
                                        });
                                      }
                                    } on Exception catch (e) {
                                      setState(() {
                                        isloading = true;
                                      });
                                      Fluttertoast.showToast(msg: e.toString());
                                      setState(() {
                                        isloading = false;
                                      });
                                      // TODO
                                    }
                                  } else if (_imageFile == null) {
                                    try {
                                      setState(() {
                                        isloading = true;
                                      });
                                      final response = await Supportservice()
                                          .addsupportwithoutimage(
                                              request_controller.text,
                                              topic_controller.text);

                                      if (response.success == true) {
                                        setState(() {
                                          isloading = true;
                                        });
                                        Fluttertoast.showToast(
                                            msg: response.message.toString());
                                        setState(() {
                                          isloading = false;
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        setState(() {
                                          isloading = true;
                                        });
                                        Fluttertoast.showToast(
                                            msg: response.message.toString());
                                        setState(() {
                                          isloading = false;
                                        });
                                      }
                                    } on Exception catch (e) {
                                      setState(() {
                                        isloading = true;
                                      });
                                      Fluttertoast.showToast(msg: e.toString());
                                      setState(() {
                                        isloading = false;
                                      });
                                      // TODO
                                    }
                                  }
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _topic() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Topic cannot be empty';
            }
            return null;
          },
          controller: topic_controller,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Provide a topic',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          ),
        ),
      ],
    );
  }

  Widget _request() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Request cannot be empty';
            }
            return null;
          },
          controller: request_controller,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Provide a request',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          ),
        ),
      ],
    );
  }
}
