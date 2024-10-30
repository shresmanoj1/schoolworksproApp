import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/password_updaterequest.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/updateimage_service.dart';
import 'package:schoolworkspro_app/services/updatepassword_service.dart';


class AdminEditScreen extends StatefulWidget {
  const AdminEditScreen({Key? key}) : super(key: key);

  @override
  _AdminEditScreenState createState() => _AdminEditScreenState();
}

class _AdminEditScreenState extends State<AdminEditScreen> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isHiddenPassword = true;
  bool isHiddenPassword2 = true;
  bool isHiddenPassword3 = true;
  bool _isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _currentpassword = new TextEditingController();
  TextEditingController _newpassword = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();

  late Authenticateduserservice _auth;

  @override
  void initState() {
    // TODO: implement initState

    _auth =
        Provider.of<Authenticateduserservice>(context, listen: false);
    _auth.getAuthentication(context);
    super.initState();
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

  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
        Update(_imageFile!);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Update(PickedFile abc) async {
    final result = await Imageservice().updateImage("users", abc);
    if (result.success == true) {
      Fluttertoast.showToast(msg: "Image updated succesfully");
    } else {
      Fluttertoast.showToast(msg: "Error updating image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ChangeNotifierProvider<Authenticateduserservice>(
              create: (context) => Authenticateduserservice(),
              child: Consumer<Authenticateduserservice>(
                  builder: (context, provider, child) {
                // provider.getAuthentication(context);
                if (provider.data?.user == null) {
                  provider.getAuthentication(context);
                  return const Center(
                      child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ));
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(children: [
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
                                            provider.data!.user!.firstname![0]
                                                    .toUpperCase() +
                                                "" +
                                                provider
                                                    .data!.user!.lastname![0]
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              api_url2 +
                                                  '/uploads/users/' +
                                                  provider
                                                      .data!.user!.userImage!,
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
                            right: 20,
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
                    ),
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15),
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
                                  Expanded(
                                    flex: 1,
                                    child: const Icon(
                                      Icons.mail_outline,
                                      size: 21,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 15),
                                      child: provider.data!.user!.email == null
                                          ? Text(" ")
                                          : Text(
                                              provider.data!.user!.email
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                    ),
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
                                    child: provider.data!.user!.institution ==
                                            null
                                        ? Text("")
                                        : Text(
                                            provider.data!.user!.institution
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  height: 2.0,
                                  width: double.infinity,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              })),
          SizedBox(height: 15,),


          Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Current Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      validator: currentPasswordValidator(),
                      controller: _currentpassword,
                      obscureText: isHiddenPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.lock, color: kPrimaryColor),
                        hintText: 'Enter your current password',
                        filled: true,
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,

                          child: isHiddenPassword == true
                              ? const Icon(
                            Icons.visibility,
                          )
                              : const Icon(
                            Icons.visibility_off,
                          ),
                          // Icons.visibility,
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'New Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _newpassword,
                      validator: currentPasswordValidator(),
                      obscureText: isHiddenPassword2,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView2,
                          child: isHiddenPassword2 == true
                              ? const Icon(
                            Icons.visibility,
                          )
                              : const Icon(
                            Icons.visibility_off,
                          ),
                          // Icons.visibility,
                        ),
                        hintText: 'Enter your new password',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _confirmpassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isHiddenPassword3,
                      validator: currentPasswordValidator(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView3,
                          child: isHiddenPassword3 == true
                              ? const Icon(
                            Icons.visibility,
                          )
                              : const Icon(
                            Icons.visibility_off,
                          ),
                          // Icons.visibility,
                        ),
                        hintText: 'Confirm new password',
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                              if (!formKey.currentState!.validate()) {
                                setState(() {
                                  autovalidateMode =
                                      AutovalidateMode.onUserInteraction;
                                });
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                final data = PasswordUpdateRequest(
                                    currPassword: _currentpassword.text,
                                    newPassword: _newpassword.text);
                                final result = await Updatepasswordservice()
                                    .updatePassword(data);

                                if (_newpassword.text ==
                                    _currentpassword.text) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                      'old and new password cannot be same');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else if (_newpassword.text ==
                                    _confirmpassword.text) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (result.success == true) {
                                    _currentpassword.clear();
                                    _newpassword.clear();
                                    _confirmpassword.clear();
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    Fluttertoast.showToast(
                                        msg: result.message.toString());

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    _isLoading = false;
                                    Fluttertoast.showToast(
                                        msg: result.message.toString());
                                  }
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                      "passwords did't match, please check and try again");
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
                              "Update",
                              style:
                              TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }


  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      isHiddenPassword2 = !isHiddenPassword2;
    });
  }

  MultiValidator currentPasswordValidator() {
    return MultiValidator([
      MinLengthValidator(8,
          errorText: 'password must be at least 8 digits long'),
      RequiredValidator(errorText: 'Field cannot be empty'),
    ]);
  }

  void _togglePasswordView3() {
    setState(() {
      isHiddenPassword3 = !isHiddenPassword3;
    });
  }
}
