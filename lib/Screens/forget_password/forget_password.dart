import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/components/input_container.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/forgetpassword_response.dart';
import 'package:schoolworkspro_app/services/forgetpassword_service.dart';

import '../../constants/colors.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key? key}) : super(key: key);

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final TextEditingController emailcontroller = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Reset password",
            style: TextStyle(color: white),
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/forgetpassword.jpg"),
            const SizedBox(
              height: 10,
            ),

            Center(
              child: InputContainer(
                  child: TextField(
                      cursorColor: kPrimaryColor,
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: "Provide your email",
                          border: InputBorder.none))),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: emailcontroller,
            //     obscureText: false,
            //     keyboardType: TextInputType.visiblePassword,
            //     decoration: const InputDecoration(
            //       prefixIcon: Icon(
            //         Icons.email,
            //         color: Colors.grey,
            //       ),
            //       filled: true,
            //       hintText: "Provide us your email address",
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.grey)),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.green)),
            //       // border:
            //       //     OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            //       floatingLabelBehavior: FloatingLabelBehavior.always,
            //     ),
            //   ),
            // ),
            isloading == false
                ? Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          onPressed: () async {
                            final data = Forgetpasswordrequest(
                                email: emailcontroller.text);
                            final res = await Forgetpasswordservice()
                                .forgetpassword(data);
                            if (res.success == true) {
                              setState(() {
                                isloading = true;
                              });
                              Fluttertoast.showToast(msg: res.message!);
                            } else {
                              setState(() {
                                isloading = false;
                              });
                              Fluttertoast.showToast(msg: res.message!);
                            }
                            setState(() {
                              isloading = false;
                            });
                          },
                          child: const Text("Submit")),
                    )
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ElevatedButton(

                    //       },
                    //       child: isloading == true
                    //           ? const SpinKitDualRing(color: kPrimaryColor)
                    //           : const Text("submit")),
                    )
                : const SpinKitDualRing(color: kPrimaryColor)
          ],
        ),
      ),
    );
  }
}
