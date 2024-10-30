import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/password_updaterequest.dart';
import 'package:schoolworkspro_app/services/updatedetail_service.dart';
import 'package:schoolworkspro_app/services/updatepassword_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../services/login_service.dart';
import '../../login/login.dart';
import '../../widgets/snack_bar.dart';

class Updatepasswordscreen extends StatefulWidget {
  final bool isLogin;
  const Updatepasswordscreen({Key? key, required this.isLogin})
      : super(key: key);

  @override
  _UpdatepasswordscreenState createState() => _UpdatepasswordscreenState();
}

class _UpdatepasswordscreenState extends State<Updatepasswordscreen> {
  bool isHiddenPassword = true;
  bool isHiddenPassword2 = true;
  bool isHiddenPassword3 = true;
  bool _isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _currentpassword = new TextEditingController();
  TextEditingController _newpassword = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();

  bool isLogOutLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.isLogin == true ? false : true,
        elevation: 0.0,
        title: const Text(
          "Update password",
          style: TextStyle(color: white),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              widget.isLogin == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 7),
                              decoration: BoxDecoration(
                                  color: const Color(0xff3498db),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Weak Password Detected. Change Your Password",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isLogOutLoading = true;
                                });
                                final res = await LoginService().logout();

                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                await sharedPreferences.clear();

                                if (res.success == true) {
                                  setState(() {
                                    isLogOutLoading = false;
                                  });

                                  Navigator.pop(context);

                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //         const LoginScreen()));
                                } else {
                                  setState(() {
                                    isLogOutLoading = false;
                                  });
                                  snackThis(
                                      context: context,
                                      content: Text(res.success.toString()),
                                      color: Colors.red,
                                      duration: 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 7),
                                // #cf407f
                                decoration: BoxDecoration(
                                    color: const Color(0xffcf407f),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: const [
                                    Icon(Icons.logout_outlined,
                                        color: Colors.white),
                                    Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: currentPasswordValidator(),
                  controller: _currentpassword,
                  obscureText: isHiddenPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: kPrimaryColor),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // labelText: 'Current password'
                  ),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // labelText: 'New password'
                  ),
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
                    hintText: 'Confirm your new password',
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // labelText: 'Confirm password'
                  ),
                ),
              ),
              _isLoading == false
                  ? ElevatedButton(
                      // onPressed: null,
                      child: const Text("Update"),
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

                          if (_newpassword.text == _currentpassword.text) {
                            setState(() {
                              _isLoading = true;
                            });
                            Fluttertoast.showToast(
                                msg: 'old and new password cannot be same');
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
                                  msg: 'password changed successfully');

                              if (widget.isLogin == true) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ));
                              }
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();

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
                    )
                  : const SpinKitDualRing(
                      color: kPrimaryColor,
                    )
            ],
          ),
        ),
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
