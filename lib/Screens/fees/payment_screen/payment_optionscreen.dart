import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/Screens/fees/payment_screen/paymentmethoddetail_sreen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/response/paymentmethod_response.dart';
import 'package:schoolworkspro_app/services/fetchusername_service.dart';
import 'package:schoolworkspro_app/services/payfees_service.dart';
import 'package:schoolworkspro_app/services/paymentmethod_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';

class PaymentOptionScreen extends StatefulWidget {
  final institution;
  const PaymentOptionScreen({Key? key, this.institution}) : super(key: key);

  @override
  _PaymentOptionScreenState createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  final amount_controller = TextEditingController();
  final deposited_controller = TextEditingController();
  final remarks_controller = TextEditingController();
  PickedFile? _imageFile;
  User? user;
  bool isloading = false;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No receipt selected.');
      }
    });
  }

  Future<Paymentmethodresponse>? payment_method;

  Widget bottomSheet(BuildContext context) {
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
            height: 20,
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

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    final datas = Institutionrequest(institution: widget.institution);
    payment_method = PaymentMethodService().getpaymentMethod(datas);
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'choose payment option',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder<Paymentmethodresponse>(
              future: payment_method,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.payment!.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              color: Colors.orangeAccent,
                              width: double.infinity,
                              child:const Center(
                                  child: Padding(
                                    padding:  EdgeInsets.all(8.0),
                                    child: Text(
                                "No payment method available.\n Contact administration ",
                                textAlign: TextAlign.center,
                              ),
                                  ))),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemCount: snapshot.data?.payment?.length,
                          itemBuilder: (BuildContext context, int index) {
                            var datas = snapshot.data?.payment?[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Paymentmethoddetailscreen(
                                              data: datas),
                                    ));
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    datas['payment_type'] == "esewa"
                                        ? Image.asset("assets/icons/esewa.png")
                                        : datas['payment_type'] == "fonepay"
                                            ? Image.asset(
                                                "assets/icons/fonepay.png")
                                            : datas['payment_type'] == "khalti"
                                                ? Image.asset(
                                                    "assets/icons/khalti.png")
                                                : datas['payment_type'] ==
                                                        "bank"
                                                    ? Image.asset(
                                                        "assets/icons/banktransfer.png",
                                                        height: 50,
                                                      )
                                                    : Image.asset(
                                                        "assets/icons/fonepay.png")
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const SpinKitDualRing(color: kPrimaryColor);
                }
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: const [
                Text("Amount"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.help,
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: amount_controller,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              decoration: const InputDecoration(
                hintText: 'Enter amount',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: const [
                Text("Deposited by"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.help,
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: deposited_controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Depositor's name",
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: const [
                Text("Remarks"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.help,
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: remarks_controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Write something",
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Attach receipt",
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(context)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text('Upload receipt'),
                    ),
                  ),
                ),
              ),
            ),
            // child: const ElevatedButton(
            //     onPressed: null, child: Text("Choose File"))
          ),
          _imageFile == null
              ? const SizedBox(
                  height: 1,
                )
              : Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(
                        _imageFile!.path,
                      ),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -2,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: SizedBox(
                  height: 40,
                  width: 95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
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
                      final datas =
                          Institutionrequest(institution: widget.institution);
                      final admissionData =
                          await FetchAdmissionusernameservice()
                              .fetchusername(datas);
                      var finance_username =
                          admissionData.admission?.username.toString();

                      var assigned_date = DateTime.now();
                      var fullname =
                          "${user?.firstname}" + " " + "${user?.lastname}";
                      var request = "Amount paid:" +
                          amount_controller.text +
                          "  " +
                          "Deposited by:" +
                          deposited_controller.text +
                          "  " +
                          "Remarks:" +
                          remarks_controller.text;

                      if (_imageFile != null) {
                        try {
                          final res = await PayfeeService()
                              .addfeesticketwithimage(
                                  request,
                                  "Critical",
                                  "fees of $fullname",
                                  "Fees",
                                  _imageFile,
                                  finance_username.toString(),
                                  assigned_date);
                          if (res.success == true) {
                            setState(() {
                              isloading = true;
                              amount_controller.clear();
                              deposited_controller.clear();
                              remarks_controller.clear();
                              _imageFile = null;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());

                            setState(() {
                              isloading = false;
                            });
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          }
                        } on Exception catch (e) {
                          setState(() {
                            isloading = true;
                          });
                          Fluttertoast.showToast(msg: e.toString());
                          setState(() {
                            isloading = false;
                          });
                          // TODO
                        }
                      } else {
                        try {
                          final res = await PayfeeService()
                              .addfeesticketwithoutimage(
                                  request,
                                  "Critical",
                                  "fees of $fullname",
                                  "Fees",
                                  finance_username.toString(),
                                  assigned_date);
                          if (res.success == true) {
                            setState(() {
                              isloading = true;
                              amount_controller.clear();
                              deposited_controller.clear();
                              remarks_controller.clear();
                              // _imageFile = null;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          }
                        } on Exception catch (e) {
                          setState(() {
                            isloading = true;
                          });
                          Fluttertoast.showToast(msg: e.toString());
                          setState(() {
                            isloading = false;
                          });
                          // TODO
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: const Text(
                      "Post",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
