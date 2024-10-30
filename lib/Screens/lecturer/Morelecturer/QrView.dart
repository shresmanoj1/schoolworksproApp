import 'dart:convert';
import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lecturerrequestdetail_screen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({Key? key, onQRViewScreenCreated}) : super(key: key);

  @override
  _QRViewScreenState createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  // QRViewController? controller;
  bool scan = true;

  String qrCodeResult = "Not Yet Scanned";
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // } else if (Platform.isIOS) {
    //   controller!.resumeCamera();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan for attendance',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      // body: Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     QRView(
      //       key: qrKey,
      //       onQRViewCreated: _onQRViewScreenCreated,
      //       overlay: QrScannerOverlayShape(
      //           cutOutSize: MediaQuery.of(context).size.width * 0.8,
      //           borderLength: 20,
      //           borderWidth: 10,
      //           borderRadius: 10,
      //           borderColor: kPrimaryColor),
      //     ),
      //     Positioned(bottom: 100.0, child: buildControlButtons()),
      //     // Positioned(
      //     //   bottom: 100,
      //     //   child: Center(
      //     //     child: Container(
      //     //         padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      //     //         decoration: BoxDecoration(
      //     //             borderRadius: BorderRadius.circular(8), color: Colors.white24), child: const Text('Scan a code')),
      //     //   ),
      //     // ),
      //   ],
      // ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),

            //Button to scan QR code
            ElevatedButton(
              // padding: EdgeInsets.all(15),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                // backgroundColor:
                // MaterialStateProperty.all( Colors.black,),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              onPressed: () async {
                print('i am clicked');
                // BarcodeScanner.scan();    //barcode scanner
                // setState(() {
                //   qrCodeResult = codeSanner;
                // });
              },
              child: Text(
                "Open Scanner",
                style: TextStyle(color: Colors.indigo[900]),
              ),
              //Button having rounded rectangle border
              // shape: RoundedRectangleBorder(
              //   side: BorderSide(color: Colors.indigo),
              //   borderRadius: BorderRadius.circular(20.0),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildControlButtons() => Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white54,
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //       ),
  //       child: Row(
  //           mainAxisSize: MainAxisSize.max,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             IconButton(
  //                 onPressed: () async {
  //                   await controller?.toggleFlash();
  //                   setState(() {});
  //                 },
  //                 icon: FutureBuilder<bool?>(
  //                   future: controller?.getFlashStatus(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       return Icon(
  //                           snapshot.data! ? Icons.flash_on : Icons.flash_off);
  //                     } else if (snapshot.hasError) {
  //                       return Text('${snapshot.error}');
  //                     } else {
  //                       return Icon(Icons.flash_on);
  //                     }
  //                   },
  //                 )),
  //             IconButton(
  //                 onPressed: () async {
  //                   await controller?.flipCamera();
  //                   setState(() {});
  //                 },
  //                 icon: const Icon(Icons.switch_camera)),
  //           ]),
  //     );
  //
  // void _onQRViewScreenCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     if (scan == true) {
  //       if (scanData.code ==
  //           "https://api.schoolworkspro.com/staffAttendance/add") {
  //         hitAttendance();
  //         setState(() {
  //           scan = false;
  //         });
  //       }
  //     }
  //
  //     // if (scanData.code.toString() ==
  //     //     "https://api.schoolworkspro.com/staffAttendance/add") {
  //     //   hitAttendance();
  //     //   ;
  //     // }
  //   });
  // }
  //
  // hitAttendance() async {
  //   try {
  //     final res = await PunchService().punchInOut();
  //     if (res.success == true) {
  //       snackThis(
  //           content: Text(res.message.toString()),
  //           color: Colors.green,
  //           behavior: SnackBarBehavior.fixed,
  //           duration: 2,
  //           context: context);
  //       Navigator.pop(context);
  //     } else {
  //       snackThis(
  //           content: Text(res.message.toString()),
  //           color: Colors.red,
  //           behavior: SnackBarBehavior.fixed,
  //           duration: 2,
  //           context: context);
  //     }
  //   } catch (e) {
  //     snackThis(
  //         content: Text(e.toString()),
  //         color: Colors.red,
  //         behavior: SnackBarBehavior.fixed,
  //         duration: 2,
  //         context: context);
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }
}
