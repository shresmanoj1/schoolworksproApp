import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/dashboard/dashboardadminscreen.dart';
import 'package:schoolworkspro_app/Screens/admin/navigation/navigation_admin.dart';
import 'package:schoolworkspro_app/Screens/dashboard/pager_view.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/navigation/pagerview_lecturer.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/dashboard/prinicipal_dashboard.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/navigation/navigation.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/auth_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/input_container.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../../flavor_config_provider.dart';
import '../../lecturer/navigation/navigation_lecturer.dart';
import '../../navigation/navigation.dart';
import '../../privacy_policy/privacy_policy_screen.dart';
// import 'package:local_auth/local_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  bool _isobsecure = true;
  bool isloading = false;
  String authorized = " not authorized";
  bool _canCheckBiometric = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthViewModel, CommonViewModel, LecturerCommonViewModel>(
        builder: (context, auth, common, lecturer, child) {
      double viewInset = MediaQuery.of(context).viewInsets.bottom;
      final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
      final config = flavorConfigProvider.config;
      return AnimatedOpacity(
        opacity: widget.isLogin ? 1.0 : 0.0,
        duration: widget.animationDuration * 4,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            // width: widget.size.width,
            // height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "${config.imageLocation}",
                      height: 100,
                    ),
                  ),

                  // const Text(
                  //   '"First BI Integrated School Solution"',
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16),
                  // ),

                  Image.asset("assets/images/login-freepix4.png"),
                  const SizedBox(height: 30),
                  InputContainer(
                      child: TextField(
                          cursorColor: kPrimaryColor,
                          controller: usernameController,
                          focusNode: _usernameFocusNode,
                          decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "Username",
                              border: InputBorder.none))),
                  InputContainer(
                      child: TextField(
                          cursorColor: kPrimaryColor,
                          focusNode: _passwordFocusNode,
                          controller: passwordController,
                          obscureText: _isobsecure,
                          decoration: InputDecoration(
                              icon: const Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              suffixIcon: IconButton(
                                color: kPrimaryColor,
                                icon: Icon(
                                  _isobsecure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isobsecure = !_isobsecure;
                                  });
                                },
                              ),
                              hintText: "Password",
                              border: InputBorder.none))),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              "By clicking Signing In, you are agreeing to SchoolWorksPro's ",
                          style: TextStyle(color: Colors.black38, fontSize: 12),
                        ),
                        TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(
                                  "https://schoolworkspro.com/policies")),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 40),

                  const SizedBox(height: 10),

                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: common.isLoading == true
                        ? null
                        : () async {
                      _usernameFocusNode.unfocus();
                      _passwordFocusNode.unfocus();
                      common.setLoading(true);
                      auth.setUsername(usernameController.text);
                      auth.setPassword(passwordController.text);

                      auth.login(config.institution.toString()).then((value) {
                        if (!isError(auth.loginApiResponse)) {
                          common.getAuthenticatedUser().then((_) {
                            try {
                              if (common.privateFlag == true) {
                                setState(() {
                                  isloading = false;
                                });
                                common.setLoading(true);
                                usernameController.clear();
                                passwordController.clear();
                                Navigator.pushNamed(
                                    context, "/updatepasswordscreen",
                                    arguments: true);
                                common.setLoading(false);
                              } else {
                                if (auth.user.droleName == "STUDENT") {
                                  common.setLoading(true);
                                  Navigator.pop(context);
                                  common.setNavigationIndex(0);
                                  snackThis(
                                    context: context,
                                    content: const Text("Login Success"),
                                    color: Colors.green,
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const Navigation(
                                            currentIndex: 0),
                                      ));
                                  common.setLoading(false);
                                } else if (auth.user.droleName ==
                                    "PARENT") {
                                  common.setLoading(true);
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushNamed('/childrenscreen');

                                  snackThis(
                                    context: context,
                                    content: const Text("Login Success"),
                                    color: Colors.green,
                                  );
                                  common.setLoading(false);
                                } else if (auth.user.type == "Lecturer" ||
                                    auth.user.type == "Head Lecturer") {
                                  common.setLoading(true);
                                  lecturer.setNavigationIndex(0);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const NavigationLecturer(),
                                      ));
                                  snackThis(
                                    context: context,
                                    content: const Text(
                                        "Lecturer login success"),
                                    color: Colors.green,
                                  );

                                  common.setLoading(false);
                                } else if (auth.user.type == "Driver") {
                                  common.setLoading(true);
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushNamed('/navigation-driver');

                                  snackThis(
                                    context: context,
                                    content: Text("Login Success"),
                                    color: Colors.green,
                                  );
                                  common.setLoading(false);
                                } else if (auth.user.institution ==
                                    "digitech") {
                                  common.setLoading(true);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationAdmin(),
                                      ));

                                  snackThis(
                                    context: context,
                                    content: Text("Login Success"),
                                    color: Colors.green,
                                  );
                                  common.setLoading(false);
                                } else if (auth.user.domains != null &&
                                    auth.user.domains!
                                        .contains("Admin")) {
                                  common.setLoading(true);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationPrincipal(),
                                      ));

                                  snackThis(
                                    context: context,
                                    content: Text("Login Success"),
                                    color: Colors.green,
                                  );
                                  common.setLoading(false);
                                }
                              }
                            } catch (e) {
                              print("CATCH " + e.toString());
                              snackThis(
                                context: context,
                                content: Text(e.toString()),
                                color: Colors.red.shade700,
                              );
                              common.setLoading(false);
                            }
                          });
                        } else {
                          snackThis(
                            context: context,
                            content: Text(auth.message.toString()),
                            color: Colors.red.shade700,
                          );
                          common.setLoading(false);
                        }
                      }).catchError((e) {
                        snackThis(
                          context: context,
                          content: Text(e.toString()),
                          color: Colors.red.shade700,
                        );
                        common.setLoading(false);
                      });
                    },
                    child: Container(
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kPrimaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: common.isLoading
                          ? const SizedBox(
                              height: 27,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: white,
                              ),
                            )
                          : const Text(
                              "LOGIN",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/forgetpassword',
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Text(
                          "Forget password?",
                          style: TextStyle(color: kPrimaryColor, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void handleLoginSuccess(
    AuthViewModel auth,
    CommonViewModel common,
    LecturerCommonViewModel lecturer,
  ) {
    try {
      if (common.privateFlag) {
        navigateToUpdatePassword(common);
      } else {
        navigateToRoleSpecificScreen(auth, common, lecturer);
      }
      snackThis(
        context: context,
        content: const Text("Login Success"),
        color: Colors.green,
      );
    } catch (e) {
      print("CATCH " + e.toString());
      snackThis(
        context: context,
        content: Text(e.toString()),
        color: Colors.red.shade700,
      );
    }
  }

  void navigateToUpdatePassword(CommonViewModel common) {
    common.setLoading(true);
    usernameController.clear();
    passwordController.clear();
    Navigator.pushNamed(context, "/updatepasswordscreen", arguments: true);
    common.setLoading(false);
  }

  void navigateToRoleSpecificScreen(AuthViewModel auth, CommonViewModel common,
      LecturerCommonViewModel lecturer) {

    switch (auth.user.droleName ?? auth.user.type) {
      case "STUDENT":
        navigateToStudentScreen(common);
        break;
      case "PARENT":
        navigateToParentScreen(common);
        break;
      case "Lecturer":
        navigateToLecturerScreen(common, lecturer);
        break;
      case "Head Lecturer":
        navigateToLecturerScreen(common, lecturer);
        break;
      case "Driver":
        navigateToDriverScreen(common);
        break;
      default:
        if (auth.user.institution == "digitech") {
          navigateToAdminScreen(common);
        } else if (auth.user.domains?.contains("Admin") == true) {
          navigateToPrincipalScreen(common);
        } else {
          throw Exception("Unknown role");
        }
    }
  }

  void navigateToStudentScreen(CommonViewModel common) {
    common.setLoading(true);
    common.setNavigationIndex(0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const Navigation(currentIndex: 0)),
    );
    common.setLoading(false);
  }

  void navigateToParentScreen(CommonViewModel common) {
    common.setLoading(true);
    Navigator.of(context).pushReplacementNamed('/childrenscreen');
    common.setLoading(false);
  }

  void navigateToLecturerScreen(
      CommonViewModel common, LecturerCommonViewModel lecturer) {
    common.setLoading(true);
    lecturer.setNavigationIndex(0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationLecturer()),
    );
    common.setLoading(false);
  }

  void navigateToDriverScreen(CommonViewModel common) {
    common.setLoading(true);
    Navigator.of(context).pushReplacementNamed('/navigation-driver');
    common.setLoading(false);
  }

  void navigateToAdminScreen(CommonViewModel common) {
    common.setLoading(true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationAdmin()),
    );
    common.setLoading(false);
  }

  void navigateToPrincipalScreen(CommonViewModel common) {
    common.setLoading(true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationPrincipal()),
    );
    common.setLoading(false);
  }

  _launchURL(String abc) async {
    String url = abc;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
