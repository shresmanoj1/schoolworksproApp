// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../config/environment.config.dart';
// import '../../../config/preference_utils.dart';
// import '../../../constants/colors.dart';
//
// class AssignmentViewReportWebView extends StatefulWidget {
//   dynamic data;
//   AssignmentViewReportWebView({Key? key, required this.data}) : super(key: key);
//
//   @override
//   _AssignmentViewReportWebViewState createState() => _AssignmentViewReportWebViewState();
// }
//
// class _AssignmentViewReportWebViewState extends State<AssignmentViewReportWebView> {
//   late InAppWebViewController _webViewController;
//   String url = "";
//   double progress = 0;
//   String domain = EnvironmentConfig.url;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     //https://schoolworkspro.com/assignment/user-submission/report/Eric[SEP]Tamang[SEP]erictamang-bktscl[SEP]64632ce03fbbb7cb1d2bfd89
//     print("$domain/assignment/user-submission/report/${widget.data["name"]}[SEP]${widget.data["username"]}[SEP]${widget.data["assignmentId"]}");
//     super.initState();
//   }
//
//   final SharedPreferences localStorage = PreferenceUtils.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     var token = localStorage.getString('token');
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: white,
//         // elevation: 1,
//         centerTitle: false,
//         title: const Text(
//           "Report",
//           style: TextStyle(color: white),
//         ),
//       ),
//       body: Column(children: <Widget>[
//         Container(
//             // padding: const EdgeInsets.all(10.0),
//             child: progress < 1.0
//
//                 ? LinearProgressIndicator(value: progress)
//                 : Container()),
//         Expanded(
//           child: Container(
//             // margin: const EdgeInsets.all(10.0),
//             child: InAppWebView(
//               initialUrlRequest: URLRequest(
//                 url: Uri.parse(
//                   // "http://202.51.95.39:3000/app/assignment/user-submission/report/${widget.data["username"]}/${widget.data["assignmentId"]}"
//                   "https://schoolworkspro.com/assignment/user-submission/report/Eric[SEP]Tamang[SEP]erictamang-bktscl[SEP]64632ce03fbbb7cb1d2bfd89"
//                   //   "$domain/assignment/user-submission/report/${widget.data["name"]}[SEP]${widget.data["username"]}[SEP]${widget.data["assignmentId"]}"
//                 ),
//                 headers: {
//                   'Authorization': 'Bearer $token',
//                 },
//               ),
//               // URLRequest(url: Uri.parse("https://flutter.dev")),
//               initialOptions: InAppWebViewGroupOptions(
//                   crossPlatform: InAppWebViewOptions(
//                     // debuggingEnabled: true,
//                   )),
//               onWebViewCreated:
//                   (InAppWebViewController controller) {
//                 _webViewController = controller;
//               },
//               onProgressChanged: (InAppWebViewController controller,
//                   int progress) {
//                 setState(() {
//                   this.progress = progress / 100;
//                 });
//               },
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }
