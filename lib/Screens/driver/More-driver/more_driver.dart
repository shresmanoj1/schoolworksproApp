import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/updateimage_service.dart';

import '../../../constants.dart';

class MoreDriver extends StatefulWidget {
  const MoreDriver({Key? key}) : super(key: key);

  @override
  _MoreDriverState createState() => _MoreDriverState();
}

class _MoreDriverState extends State<MoreDriver> {
  late Future authenticationmodel;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    // getAuthenticateduser();
    // checkversion();
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
        Update(_imageFile!);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              height: 8,
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

    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChangeNotifierProvider<Authenticateduserservice>(
                  create: (context) => Authenticateduserservice(),
                  child: Consumer<Authenticateduserservice>(
                      builder: (context, provider, child) {
                    provider.getAuthentication(context);
                    if (provider.data!.user == null) {
                      provider.getAuthentication(context);
                      return const Center(
                          child: SpinKitDualRing(
                        color: kPrimaryColor,
                      ));
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        provider.data!.user!.userImage == null
                                            ? Colors.grey
                                            : Colors.white,
                                    child: _imageFile == null
                                        ? provider.data!.user!.userImage == null
                                            ? Text(
                                                provider.data!.user!
                                                        .firstname![0]
                                                        .toUpperCase() +
                                                    "" +
                                                    provider.data!.user!
                                                        .lastname![0]
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : ClipOval(
                                                child: Image.network(
                                                  api_url2 +
                                                      '/uploads/users/' +
                                                      provider.data!.user!
                                                          .userImage!,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                        : ClipOval(
                                            child: Image.file(
                                              File(_imageFile!.path),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheet()),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ]),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  provider.data!.user!.firstname == null
                                      ? const Text("")
                                      : Text(
                                          provider.data!.user!.firstname
                                                  .toString() +
                                              " " +
                                              provider.data!.user!.lastname
                                                  .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.mail_outline,
                                        size: 21,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child:
                                            provider.data!.user!.email == null
                                                ? Text(" ")
                                                : Text(
                                                    provider.data!.user!.email
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/institution.png",
                                        height: 22,
                                        width: 22,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 3),
                                        child: provider
                                                    .data!.user!.institution ==
                                                null
                                            ? Text("")
                                            : Text(
                                                provider.data!.user!.institution
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                      height: 2.0,
                                      width: MediaQuery.of(context).size.width -
                                          175,
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }

  Update(PickedFile abc) async {
    final result = await Imageservice().updateImage("users", abc);
    if (result.success == true) {
      Fluttertoast.showToast(msg: "Image updated succesfully");
    } else {
      Fluttertoast.showToast(msg: "Error updating image");
    }
  }
}
