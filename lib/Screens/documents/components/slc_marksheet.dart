// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/services/document_service.dart';
//
// import '../../../constants/colors.dart';
//
// class Slcmarksheet extends StatefulWidget {
//   const Slcmarksheet({Key? key}) : super(key: key);
//
//   @override
//   _SlcmarksheetState createState() => _SlcmarksheetState();
// }
//
// class _SlcmarksheetState extends State<Slcmarksheet> {
//   var alertStyle = AlertStyle(
//     animationType: AnimationType.fromTop,
//     isCloseButton: false,
//     isOverlayTapDismiss: false,
//     descStyle: const TextStyle(fontWeight: FontWeight.bold),
//     animationDuration: const Duration(milliseconds: 400),
//     alertBorder: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(50.0),
//       side: const BorderSide(
//         color: Colors.grey,
//       ),
//     ),
//     titleStyle: const TextStyle(
//       color: Color.fromRGBO(91, 55, 185, 1.0),
//     ),
//   );
//   PickedFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   Future<void> _pickImage(ImageSource source) async {
//     var selected =
//         await ImagePicker().pickImage(source: source, imageQuality: 10);
//
//     setState(() {
//       if (selected != null) {
//         _imageFile = PickedFile(selected.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Widget bottomSheet() {
//     return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//       height: 100.0,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             "choose photo",
//             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextButton.icon(
//                 icon: const Icon(Icons.camera, color: Colors.red),
//                 onPressed: () async {
//                   _pickImage(ImageSource.camera);
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 label: const Text("Camera"),
//               ),
//               TextButton.icon(
//                 icon: const Icon(Icons.image, color: Colors.green),
//                 onPressed: () {
//                   _pickImage(ImageSource.gallery);
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 label: const Text("Gallery"),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0.0,
//           title: const Text(
//             "SEE/SLC marksheet",
//             style: TextStyle(color: white),
//           ),
//           // iconTheme: const IconThemeData(
//           //   color: Colors.black, //change your color here
//           // ),
//           // backgroundColor: Colors.white
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     "Upload your SEE/SLC marksheet",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         showModalBottomSheet(
//                           context: context,
//                           builder: ((builder) => bottomSheet()),
//                         );
//                       },
//                       child: const Text(
//                         "Browse",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                             decoration: TextDecoration.underline),
//                       ),
//                     ))
//               ],
//             ),
//             _imageFile == null
//                 ? const SizedBox(
//                     height: 1,
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Stack(
//                       children: <Widget>[
//                         Image.file(
//                           File(_imageFile!.path),
//                           height: 100,
//                           width: 100,
//                         ),
//                         Positioned(
//                           top: -8,
//                           right: -2,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _imageFile = null;
//                               });
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.clear,
//                                 color: Colors.red,
//                                 size: 28.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_imageFile == null) {
//                     Alert(
//                         title: "Warning",
//                         style: alertStyle,
//                         content: const Text(
//                             "You need to select image for hseb character certificate to upload"),
//                         context: context,
//                         type: AlertType.info,
//                         buttons: [
//                           DialogButton(
//                             onPressed: () async {
//                               Navigator.pop(context);
//                             },
//                             color: kPrimaryColor,
//                             radius: BorderRadius.circular(10.0),
//                             child: const Text(
//                               "ok",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                             ),
//                           ),
//                         ]).show();
//                   }
//                   final result = await DocumentService()
//                       .addDocuments("docs", "SEE/SLC Marksheet", _imageFile!);
//                   if (result.success == true) {
//                     final snackBar = SnackBar(
//                       content: Text(result.message!),
//                       backgroundColor: (Colors.black),
//                       action: SnackBarAction(
//                         label: 'dismiss',
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                         },
//                       ),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     setState(() {
//                       _imageFile = null;
//                     });
//                     Navigator.pop(context);
//                   } else {
//                     final snackBar = SnackBar(
//                       content: Text(result.message!),
//                       backgroundColor: (Colors.black),
//                       action: SnackBarAction(
//                         label: 'dismiss',
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                         },
//                       ),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   }
//                 },
//                 child: const Text("Upload"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
