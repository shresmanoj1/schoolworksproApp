import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/password_updaterequest.dart';
import 'package:schoolworkspro_app/services/updatepassword_service.dart';

import '../../../helper/custom_loader.dart';

class Adminchangepasswordscreen extends StatefulWidget {
  const Adminchangepasswordscreen({Key? key}) : super(key: key);

  @override
  _AdminchangepasswordscreenState createState() =>
      _AdminchangepasswordscreenState();
}

class _AdminchangepasswordscreenState extends State<Adminchangepasswordscreen> {
  bool isHiddenPassword = true;
  bool isHiddenPassword2 = true;
  bool isHiddenPassword3 = true;
  bool _isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _currentpassword = new TextEditingController();
  TextEditingController _newpassword = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Update Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
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
