import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/moredetailupdate_request.dart';
import 'package:schoolworkspro_app/response/user_detail.dart';
import 'package:schoolworkspro_app/services/updatepassword_service.dart';

import '../../../common_view_model.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../helper/custom_loader.dart';

class Updatedetailscreen extends StatefulWidget {
  const Updatedetailscreen({Key? key}) : super(key: key);

  @override
  _UpdatedetailscreenState createState() => _UpdatedetailscreenState();
}

class _UpdatedetailscreenState extends State<Updatedetailscreen> {
  late CommonViewModel _provider;

  TextEditingController _contact = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController pfController = TextEditingController();

  String? maritalStatus;

  PickedFile? _imageFile;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  MultiValidator address() {
    return MultiValidator([
      RequiredValidator(errorText: 'Field cannot be empty'),
    ]);
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return "";
  }

  MultiValidator phoneNumberValidator() {
    return MultiValidator([
      RequiredValidator(errorText: 'Field cannot be empty'),
      MinLengthValidator(10,
          errorText: 'phone number must be at least 10 digits long'),
      MaxLengthValidator(10,
          errorText: 'phone number must not be more than 10 digits long'),
    ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.getUserDetails().then((_) {
        setState(() {
          UserDetail userDetails =
              Provider.of<CommonViewModel>(context, listen: false).UserDetails;

          _contact.text = userDetails.contact ?? "";
          _address.text = userDetails.address ?? "";
          panController.text = userDetails.panNumber ?? "";
          bankController.text = userDetails.bankAccount ?? "";
          pfController.text = userDetails.pfNumber ?? "";
          maritalStatus = userDetails.maritalStatus ?? "Unmarried";
        });
      });
    });
    super.initState();
  }

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
  Widget build(BuildContext context) {
    if (_isLoading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Update details",
          style: TextStyle(color: white),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    controller: _contact,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                              .hasMatch(value) ||
                          value.length > 10 ||
                          value.length < 10) {
                        return "Enter Correct Phone Number";
                      } else {
                        return null;
                      }
                    },
                    decoration: customInputDecoration(
                        hintText: "Enter phone number", icon: Icons.phone)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    controller: _address,
                    validator: address(),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: customInputDecoration(
                        hintText: "Enter address", icon: Icons.lock)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    controller: panController,
                    validator: address(),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: customInputDecoration(
                        hintText: "Permanent Account Number",
                        icon: Icons.confirmation_number)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    controller: bankController,
                    validator: address(),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: customInputDecoration(
                        hintText: "Bank Account Number",
                        icon: Icons.food_bank_rounded)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    controller: pfController,
                    validator: address(),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: customInputDecoration(
                        hintText: "Provident Fund Number", icon: Icons.money)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: customInputDecoration(
                      hintText: "Marital Status", icon: Icons.people),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  items: ["Unmarried", "Married"].map((pt) {
                    return DropdownMenuItem(
                      value: pt,
                      child: Text(
                        pt,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      maritalStatus = newVal as String?;
                    });
                  },
                  value: maritalStatus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet(context)));
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text('Signature'),
                            ),
                          ),
                        ),
                      ),
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
                  ],
                ),
              ),
              _isLoading == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all(
                                      kBlack.withOpacity(1.0)),
                                  backgroundColor:
                                      MaterialStateProperty.all(kWhite),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",
                                  style: TextStyle(
                                      fontSize: p1,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  setState(() {
                                    autovalidateMode =
                                        AutovalidateMode.onUserInteraction;
                                  });
                                } else {
                                  // if (_imageFile == null) {
                                  //   Fluttertoast.showToast(
                                  //       msg: "Please upload signature",
                                  //       backgroundColor: Colors.red,
                                  //       textColor: Colors.white,
                                  //       fontSize: 16,
                                  //       gravity: ToastGravity.TOP);
                                  // }
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  final data = MoredetailUpdateRequest(
                                      contact: _contact.text,
                                      address: _address.text,
                                      bank_account: bankController.text,
                                      pf_number: pfController.text,
                                      maritalStatus: maritalStatus,
                                      pan_number: panController.text,
                                      signature: _imageFile?.path.toString());

                                  final result = await Updatepasswordservice()
                                      .updateDetails(data);

                                  if (result.success == true) {
                                    _contact.clear();
                                    _address.clear();
                                    Fluttertoast.showToast(
                                        msg: 'Details updated successfully');
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: 'Error updating detail');
                                  }
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xff004D96)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ))),
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    fontSize: p1,
                                    color: kWhite,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(
      {required String hintText, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: kPrimaryColor,
      ),
      hintText: hintText,
      filled: true,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // labelText: 'Address'
    );
  }
}
