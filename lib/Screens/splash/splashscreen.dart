import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/navigation/navigation_admin.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/navigation/navigation_lecturer.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/navigation/navigation.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/login_request.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flavor_config_provider.dart';
import '../../response/login_response.dart';
import '../navigation/navigation.dart';

class Splashscreen extends StatefulWidget {
  static const String routeName = "/";

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // bool connected = false;
  late User _user;
  late LecturerCommonViewModel lecturerCommonViewModel;
  late CommonViewModel commonViewModel;
  late FlavorConfigProvider flavorConfigProvider;

  final SharedPreferences localStorage = PreferenceUtils.instance;

  @override
  void initState() {
    super.initState();
    getData();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lecturerCommonViewModel =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      flavorConfigProvider = Provider.of<FlavorConfigProvider>(context, listen: false);
      _checkLogin(flavorConfigProvider.config.institution.toString());
    });
  }

  getData() {
    if (localStorage.getString('token') != null) {
      try {
        _user = User.fromJson(jsonDecode(localStorage.getString("_auth_")!));
      } catch (e) {}
    }
  }

  // Future<void> _checkLogin() async {
  //   Timer(const Duration(seconds: 2), () async {
  //     if (localStorage.getString('token') != null &&
  //         localStorage.getBool('privateFlag') != null &&
  //         localStorage.getBool('privateFlag') == false) {
  //       await internetCheck().then((value) async {
  //         if (value) {
  //           String? username = localStorage.getString('username');
  //           String? password = localStorage.getString('password');
  //           final request = LoginRequest(
  //               username: username.toString(), password: password.toString());
  //
  //           try {
  //             final result = await LoginService()
  //                 .login(request, username.toString(), password.toString());
  //             if (result.success == true) {
  //               print("PRINTING DROLE::${result.user!.droleName!}");
  //               if (result.user!.droleName! == "STUDENT") {
  //                 Navigator.pop(context);
  //                 commonViewModel.setNavigationIndex(0);
  //                 print("logged in using internet");
  //                 // Navigator.of(context).pushNamed('/Pagerview');
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => Navigation(currentIndex: 0),
  //                     ));
  //               } else if (result.user!.droleName! == "PARENT") {
  //                 Navigator.pop(context);
  //                 Navigator.of(context).pushNamed('/childrenscreen');
  //               } else if (result.user!.type == "Driver") {
  //                 Navigator.pop(context);
  //                 Navigator.of(context).pushNamed('/navigation-driver');
  //               } else if (result.user!.institution == "digitech") {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => NavigationAdmin(),
  //                     ));
  //               } else if (localStorage.getBool("changedToAdmin") != null) {
  //                 print("indise:::");
  //                 if (localStorage.getBool("changedToAdmin") == true) {
  //                   if (result.user!.domains != null &&
  //                       result.user!.domains!.contains("Admin")) {
  //                     Navigator.pop(context);
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => NavigationPrincipal(),
  //                         ));
  //                   } else {
  //                     localStorage.clear();
  //                     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             const LoginScreen()));
  //                   }
  //                 }
  //                 else if (localStorage.getBool("changedToAdmin") == false) {
  //                   if (result.user!.type! == "Lecturer" ||
  //                       result.user!.type! == "Head Lecturer") {
  //                     lecturerCommonViewModel.setNavigationIndex(0);
  //                     Navigator.pop(context);
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => NavigationLecturer(),
  //                         ));
  //                   } else {
  //                     localStorage.clear();
  //                     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                         builder: (BuildContext context) =>
  //                             const LoginScreen()));
  //                   }
  //                 }
  //                 else {
  //                   localStorage.clear();
  //                   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                       builder: (BuildContext context) =>
  //                           const LoginScreen()));
  //                 }
  //               } else {
  //                 localStorage.clear();
  //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => const LoginScreen()));
  //               }
  //             } else {
  //               localStorage.clear();
  //               snackThis(
  //                 context: context,
  //                 content: const Text("please check credentials and try again"),
  //                 color: Colors.red.shade700,
  //               );
  //               Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                   builder: (BuildContext context) => const LoginScreen()));
  //             }
  //           } catch (e) {
  //             localStorage.clear();
  //             print("CATCH " + e.toString());
  //             Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                 builder: (BuildContext context) => const LoginScreen()));
  //             snackThis(
  //               context: context,
  //               content: Text(e.toString()),
  //               color: Colors.red.shade700,
  //             );
  //           }
  //         } else {
  //           print('THIS IS ELESE NO INTERNET" ${value}:::::');
  //           try {
  //             if (_user.droleName! == "STUDENT") {
  //               Navigator.pop(context);
  //               print("logged in no internet token");
  //               // Navigator.of(context).pushNamed('/Pagerview');
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const Navigation(currentIndex: 0),
  //                   ));
  //             } else if (_user.droleName! == "PARENT") {
  //               Navigator.pop(context);
  //               Navigator.of(context).pushNamed('/childrenscreen');
  //             } else if (_user.droleName == "DRIVER") {
  //               Navigator.pop(context);
  //               Navigator.of(context).pushNamed('/navigation-driver');
  //             } else if (localStorage.getBool("changedToAdmin") == true) {
  //               if (_user.domains != null && _user.domains!.contains("Admin")) {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => NavigationPrincipal(),
  //                     ));
  //               } else {
  //                 localStorage.clear();
  //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => const LoginScreen()));
  //               }
  //             } else if (localStorage.getBool("changedToAdmin") == false) {
  //               if (_user.type! == "Lecturer" ||
  //                   _user.type! == "Head Lecturer") {
  //                 lecturerCommonViewModel.setNavigationIndex(0);
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => const NavigationLecturer(),
  //                     ));
  //               } else {
  //                 localStorage.clear();
  //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => const LoginScreen()));
  //               }
  //             } else if (_user.institution == "digitech") {
  //               Navigator.pop(context);
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => NavigationAdmin(),
  //                   ));
  //             } else {
  //               localStorage.clear();
  //               Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                   builder: (BuildContext context) => const LoginScreen()));
  //             }
  //           } catch (e) {
  //             localStorage.clear();
  //             print("CATCH " + e.toString());
  //             Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                 builder: (BuildContext context) => const LoginScreen()));
  //             snackThis(
  //               context: context,
  //               content: Text(e.toString()),
  //               color: Colors.red.shade700,
  //             );
  //           }
  //         }
  //       });
  //     } else {
  //       localStorage.clear();
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => const LoginScreen()));
  //     }
  //   });
  // }
  Future<void> _checkLogin(String institution) async {
    print("LOGIN CHECK:::");
  Future<void> _checkLogin() async {
    Timer(const Duration(seconds: 2), () async {
      if (localStorage.getString('token') != null &&
          localStorage.getBool('privateFlag') != null &&
          localStorage.getBool('privateFlag') == false) {
        await internetCheck().then((value) async {
          if (value) {
            String? username = localStorage.getString('username');
            String? password = localStorage.getString('password');
            final request = LoginRequest(
                username: username.toString(), password: password.toString());

            try {
              final result = await LoginService()
                  .login(request, username.toString(), password.toString());
              if (result.success == true) {
                if (result.user!.droleName! == "STUDENT") {
                  Navigator.pop(context);
                  commonViewModel.setNavigationIndex(0);
                  print("logged in using internet");
                  // Navigator.of(context).pushNamed('/Pagerview');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(currentIndex: 0),
                      ));
                } else if (result.user!.droleName! == "PARENT") {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/childrenscreen');
                } else if (result.user!.type == "Driver") {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/navigation-driver');
                } else if (result.user!.institution == "digitech") {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationAdmin(),
                      ));
                } else if (localStorage.getBool("changedToAdmin") != null) {

                  if (localStorage.getBool("changedToAdmin") == true) {
                    if (result.user!.domains != null &&
                        result.user!.domains!.contains("Admin")) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationPrincipal(),
                          ));
                    } else {
                      localStorage.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const LoginScreen()));
                    }
                  }
                  else if (localStorage.getBool("changedToAdmin") == false) {
                    if (result.user!.type! == "Lecturer" ||
                        result.user!.type! == "Head Lecturer") {
                      lecturerCommonViewModel.setNavigationIndex(0);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationLecturer(),
                          ));
                    } else {
                      localStorage.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const LoginScreen()));
                    }
                  }
                  else {
                    localStorage.clear();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const LoginScreen()));
                  }
                } else {
                  localStorage.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()));
                }
              } else {
                localStorage.clear();
                snackThis(
                  context: context,
                  content: const Text("please check credentials and try again"),
                  color: Colors.red.shade700,
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              }
            } catch (e) {
              localStorage.clear();
              print("CATCH " + e.toString());
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen()));
              snackThis(
                context: context,
                content: Text(e.toString()),
                color: Colors.red.shade700,
              );
            }
          } else {
            print('THIS IS ELESE NO INTERNET" ${value}:::::');
            try {
              if (_user.droleName! == "STUDENT") {
                Navigator.pop(context);
                print("logged in no internet token");
                // Navigator.of(context).pushNamed('/Pagerview');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Navigation(currentIndex: 0),
                    ));
              } else if (_user.droleName! == "PARENT") {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/childrenscreen');
              } else if (_user.droleName == "DRIVER") {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/navigation-driver');
              } else if (localStorage.getBool("changedToAdmin") == true) {
                if (_user.domains != null && _user.domains!.contains("Admin")) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPrincipal(),
                      ));
                } else {
                  localStorage.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()));
                }
              } else if (localStorage.getBool("changedToAdmin") == false) {
                if (_user.type! == "Lecturer" ||
                    _user.type! == "Head Lecturer") {
                  lecturerCommonViewModel.setNavigationIndex(0);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavigationLecturer(),
                      ));
                } else {
                  localStorage.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()));
                }
              } else if (_user.institution == "digitech") {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationAdmin(),
                    ));
              } else {
                localStorage.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              }
            } catch (e) {
              localStorage.clear();
              print("CATCH " + e.toString());
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen()));
              snackThis(
                context: context,
                content: Text(e.toString()),
                color: Colors.red.shade700,
              );
            }
          }
        });
      } else {
        localStorage.clear();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()));
      }
    });
  }

  Future<void> _handleLoginWithInternet(String institution) async {
    String? username = localStorage.getString('username');
    String? password = localStorage.getString('password');
    final request = LoginRequest(
        username: username.toString(), password: password.toString());

    try {
      final result = await LoginService().login(request, username!, password!);
      if (result.success == true) {
          await _navigateUser(result.user!);

      } else {
        _handleInvalidCredentials();
      }
    } catch (e) {
      _handleLoginError(e);
    }
  }

  void _handleLoginWithoutInternet(String institution) {
    try {

      if (_user.droleName == "STUDENT") {
        _navigateTo(Navigation(currentIndex: 0));
      } else if (_user.droleName == "PARENT") {
        _navigateToNamed('/childrenscreen');
      } else if (_user.droleName == "DRIVER") {
        _navigateToNamed('/navigation-driver');
      } else if (localStorage.getBool("changedToAdmin") == true &&
          _user.domains != null &&
          _user.domains!.contains("Admin")) {
        _navigateTo(NavigationPrincipal());
      } else if (localStorage.getBool("changedToAdmin") == false &&
          (_user.type == "Lecturer" || _user.type == "Head Lecturer")) {
        lecturerCommonViewModel.setNavigationIndex(0);
        _navigateTo(NavigationLecturer());
      } else if (_user.institution == "digitech") {
        _navigateTo(NavigationAdmin());
      } else {
        _redirectToLogin();
      }
    } catch (e) {
      _handleLoginError(e);
    }
  }

  Future<void> _navigateUser(User user) async {
    Navigator.pop(context);

    if (user.droleName == "STUDENT") {
      _navigateTo(Navigation(currentIndex: 0));
    } else if (user.droleName == "PARENT") {
      _navigateToNamed('/childrenscreen');
    } else if (user.type == "Driver") {
      _navigateToNamed('/navigation-driver');
    } else if (user.institution == "digitech") {
      _navigateTo(NavigationAdmin());
    } else if (localStorage.getBool("changedToAdmin") != null) {
      await _handleAdminUser(user);
    } else {
      _redirectToLogin();
    }
  }

  Future<void> _handleAdminUser(User user) async {
    if (localStorage.getBool("changedToAdmin") == true &&
        user.domains != null &&
        user.domains!.contains("Admin")) {
      _navigateTo(NavigationPrincipal());
    } else if (localStorage.getBool("changedToAdmin") == false &&
        (user.type == "Lecturer" || user.type == "Head Lecturer")) {
      lecturerCommonViewModel.setNavigationIndex(0);
      _navigateTo(NavigationLecturer());
    } else {
      localStorage.clear();
      _redirectToLogin();
    }
  }

  void _navigateTo(Widget page) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }

  void _navigateToNamed(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _redirectToLogin() {
    localStorage.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen()));
  }

  void _handleInvalidCredentials() {
    localStorage.clear();
    snackThis(
      context: context,
      content: const Text("please check credentials and try again"),
      color: Colors.red.shade700,
    );
    _redirectToLogin();
  }

  void _handleLoginError(Object e) {
    localStorage.clear();
    print("CATCH " + e.toString());
    snackThis(
      context: context,
      content: Text(e.toString()),
      color: Colors.red.shade700,
    );
    _redirectToLogin();
  }

  bool _isAuthorizedInstitution(String? institution,String flavorInstitution) {

    // final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    // final config = flavorConfigProvider.config;
    return institution == flavorInstitution; // Replace with your authorized institution check
  }

  void _showUnauthorizedAccess() {
    snackThis(
      context: context,
      content: const Text("Unauthorized access"),
      color: Colors.red.shade700,
    );
    _redirectToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    final config = flavorConfigProvider.config;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "${config.imageLocation}",
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: CupertinoActivityIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                          child: const Text(
                        'powered by',
                        style: TextStyle(color: Colors.grey),
                      )),
                      Container(
                        height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage("assets/images/logo.png"))),
                      ),
                    ],
                  )),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 60.0),
            //     child: RichText(
            //       textAlign: TextAlign.center,
            //       text: const TextSpan(
            //         text: 'from \n',
            //         style: TextStyle(
            //           color: Colors.black26,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 15,
            //         ),
            //         children: [
            //
            //           TextSpan(
            //             text: 'DIGI TECHNOLOGY',
            //             style: TextStyle(
            //               decorationStyle: TextDecorationStyle.solid,
            //               color: Colors.black26,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 15,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

// void timer(context) {
//   Timer(
//       const Duration(milliseconds: 2000),
//       () => token != null
//           ? Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (BuildContext context) => const Pagerview(
//                     initialpage: 1,
//                   )))
//           : Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (BuildContext context) => const LoginScreen())));
// }
}
