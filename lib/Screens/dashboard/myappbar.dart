// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:schoolworkspro_app/Screens/login/components/login_form.dart';
// import 'package:schoolworkspro_app/Screens/login/login.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyAppBar extends StatelessWidget {
//   const MyAppBar({Key? key}) : super(key: key);
//
//   // final double barHeight = 66.0;
//   // final double appBarHeight = 66.0;
//
//   @override
//   Widget build(BuildContext context) {
//     // final double statusBarHeight = MediaQuery.of(context).padding.top;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Icon(
//             Icons.notifications,
//             color: Colors.black,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: InkWell(
//             onTap: () async {
//               Fluttertoast.showToast(msg: "on development phase");
//             },
//             child: const Icon(
//               Icons.settings,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
