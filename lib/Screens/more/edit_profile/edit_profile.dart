import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';

import '../../../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';

import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/constants/fonts.dart';
import 'package:schoolworkspro_app/request/detailupdate_request.dart';
import 'package:schoolworkspro_app/response/user_detail.dart';

import '../../../response/journey_response.dart';
import '../../../response/user_detail.dart';
import '../../../response/user_detail.dart';
import '../../../response/user_detail.dart';
import '../../../response/user_detail.dart';
import '../../../response/user_detail.dart';
import '../../../response/user_detail.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key}) : super(key: key);

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  bool showPassword = false;
  late CommonViewModel _provider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bio = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _province = TextEditingController();
  TextEditingController _school = TextEditingController();
  TextEditingController _college = TextEditingController();
  TextEditingController _background = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _parentsContact = TextEditingController();
  TextEditingController _parentsFirstName = TextEditingController();
  TextEditingController _parentsLastName = TextEditingController();
  TextEditingController _parentsEmail = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     _provider= Provider.of<CommonViewModel>(context, listen: false);
        _provider.getUserDetails().then((value){
          setState(() {
            UserDetail userDetails =
                Provider.of<CommonViewModel>(context, listen: false).UserDetails;
            _bio.text = userDetails.bio ?? "";
            _gender.text = userDetails.gender ?? "";
            _address.text = userDetails.address ?? "";
            _city.text = userDetails.city ?? "";
            _province.text = userDetails.province ?? "";
            _school.text = userDetails.school ?? "";
            _college.text = userDetails.college ?? "";
            _background.text = userDetails.background ?? "";
            _contact.text = userDetails.contact ?? "";
            _parentsContact.text = userDetails.parentsContact ?? "";
            _parentsFirstName.text = userDetails.parentFirstName ?? "";
            _parentsLastName.text = userDetails.parentLastName ?? "";
            _parentsEmail.text = userDetails.parentsEmail ?? "";

          });
        });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: kWhite, fontWeight: FontWeight.w800),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xff004D96)),
      body: SingleChildScrollView(
        child: Consumer<CommonViewModel>(
          builder: (context, common, child) {
            return isLoading(common.UserDetailsApiResponse)
                ? CupertinoActivityIndicator()
            // SpinKitDualRing(color: logoTheme)
                : Form(
                    key: _formKey,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Bio',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(_bio, false, const Icon(Icons.info),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(_gender, false,
                                const Icon(Icons.person), TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Address',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _address,
                                false,
                                const Icon(Icons.location_disabled),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'City',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _city,
                                false,
                                const Icon(Icons.location_history_sharp),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Province/state',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _province,
                                false,
                                const Icon(Icons.location_disabled),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'School',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _school,
                                false,
                                const Icon(Icons.school_sharp),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'College',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _college,
                                false,
                                const Icon(Icons.school_sharp),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Background',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _background,
                                false,
                                const Icon(Icons.school_sharp),
                                TextInputType.name),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Contact Number',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _contact,
                                false,
                                const Icon(Icons.contact_phone),
                                TextInputType.number),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Parents Contact Number',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _parentsContact,
                                false,
                                const Icon(Icons.contact_phone),
                                TextInputType.number),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Parents First Name',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _parentsFirstName,
                                false,
                                const Icon(Icons.contact_phone),
                                TextInputType.text),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Parents Last Name',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _parentsLastName,
                                false,
                                const Icon(Icons.contact_phone),
                                TextInputType.text),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    'Parents Email Address',
                                    style: TextStyle(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: p2),
                                  ),
                                )),
                            buildTextField(
                                _parentsEmail,
                                false,
                                const Icon(Icons.contact_phone),
                                TextInputType.text),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shadowColor:
                                              MaterialStateProperty.all(
                                                  kBlack.withOpacity(1.0)),
                                          backgroundColor:
                                              MaterialStateProperty.all(kWhite),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
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
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 120,
                                    child:
                                        ElevatedButton(
                                            onPressed: () async {
                                              final data =
                                                  MyDetailsUpdateRequest(
                                                      address: _address.text,
                                                      gender: _gender.text,
                                                      background:
                                                          _background.text,
                                                      parentsContact:
                                                          _parentsContact.text,
                                                      contact: _contact.text,
                                                      college: _college.text,
                                                      bio: _bio.text,
                                                      school: _school.text,
                                                      province: _province.text,
                                                      city: _city.text,
                                                      parentFirstName:
                                                          _parentsFirstName
                                                              .text,
                                                      parentLastName:
                                                          _parentsLastName.text,
                                                      parentsEmail:
                                                          _parentsEmail.text);

                                              common.updateUserProfile(context,data);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color(0xff004D96)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
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
                            ),

                            const SizedBox(height: 100,),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
      // SingleChildScrollView(child:
      //     Consumer<CommonViewModel>(builder: (context, common, child) {
      //   return Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: SizedBox(
      //           height: 300.0,
      //           child: Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12.0),
      //               side: BorderSide(
      //                 color: Colors.grey.shade400,
      //                 width: 1.0,
      //               ),
      //             ),
      //             child: Stack(
      //               children: [
      //                 const Padding(
      //                   padding: EdgeInsets.all(8.0),
      //                   child: Text(
      //                     'HSEB Certificate',
      //                     style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 16.0,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //
      //
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 30.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Expanded(
      //
      //                         child: Padding(
      //                           padding: const EdgeInsets.all(10.0),
      //                           child: Image.asset(
      //                             'assets/images/SS.png',
      //                             fit: BoxFit.contain,
      //                           ),
      //                         ),
      //                       ),
      //                       InkWell(
      //                         onTap: () {
      //
      //                         },
      //                         child: Container(
      //                           width: double.infinity,
      //                           decoration: const BoxDecoration(
      //                             borderRadius: BorderRadius.only(
      //                               bottomLeft: Radius.circular(12.0),
      //                               bottomRight: Radius.circular(12.0),
      //                             ),
      //                             color: Color(0xff004D96),
      //                           ),
      //                           padding: EdgeInsets.all(6.0),
      //                           child: const Center(
      //                             child: Text(
      //                               'Upload',
      //                               style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: 16.0,
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //
      //                 // ),
      //               ],
      //             ),
      //           )
      //
      //
      //
      //
      //
      //         ),
      //       )
      //
      //
      //
      //
      //     ],
      //   );
      // }))
    );
  }

  Widget buildTextField(TextEditingController controller,
      bool isPasswordTextField, Icon icons, TextInputType abc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordTextField,
        keyboardType: abc,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          filled: true,
          prefixIcon: icons,
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: const TextStyle(color: kWhite),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required.';
          }
          return null;
        },
      ),
    );
  }

// Widget bottomSheet(CommonViewModel model, int value) {
//   return Container(
//     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//     height: 80.0,
//     // width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//     child: Column(
//       children: <Widget>[
//         const Text(
//           "Choose Photo",
//           style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextButton.icon(
//               icon: const Icon(Icons.camera_enhance, color: Colors.red),
//               onPressed: () async {
//                 if (value == 1) {
//                   _pickCitizen(ImageSource.camera, model);
//                 } else if (value == 2) {
//                   _pickPan(ImageSource.camera, model);
//                 } else if (value == 3) {
//                   _pickAcademicCertificate(ImageSource.camera, model);
//                 } else if (value == 4) {
//                   _pickCV(ImageSource.camera, model);
//                 } else if (value == 5) {
//                   _pickRecommendation(ImageSource.camera, model);
//                 }
//
//                 Navigator.of(context, rootNavigator: true).pop();
//               },
//               label: const Text("Camera"),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             TextButton.icon(
//               icon: const Icon(Icons.image, color: Colors.green),
//               onPressed: () {
//                 if (value == 1) {
//                   _pickCitizen(ImageSource.gallery, model);
//                 } else if (value == 2) {
//                   _pickPan(ImageSource.gallery, model);
//                 } else if (value == 3) {
//                   _pickAcademicCertificate(ImageSource.gallery, model);
//                 } else if (value == 4) {
//                   _pickCV(ImageSource.gallery, model);
//                 } else if (value == 5) {
//                   _pickRecommendation(ImageSource.gallery, model);
//                 }
//
//                 Navigator.of(context, rootNavigator: true).pop();
//               },
//               label: const Text("Gallery"),
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }s
}
