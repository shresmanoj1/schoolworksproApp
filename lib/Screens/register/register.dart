import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/Screens/login/components/login_form.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/components/input_container.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/setpassword_request.dart';
import 'package:schoolworkspro_app/request/usernameverification_request.dart';
import 'package:schoolworkspro_app/response/findallinstitution_response.dart';
import 'package:schoolworkspro_app/services/findinstitution_service.dart';
import 'package:schoolworkspro_app/services/signup_service.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({Key? key}) : super(key: key);

  @override
  _RegisterscreenState createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  Future<Findallinstitutionresponse>? findallinstitution;
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  int current_step = 0;
  List<Institution> inst = [];
  String? _mySelection;
  @override
  void initState() {
    // TODO: implement initState
    findallinstitution = Findallinstitutionservice().getallinstitution();
    getinst();
    super.initState();
  }

  getinst() async {
    final data = await Findallinstitutionservice().getallinstitution();
    for (int i = 0; i < data.institutions!.length; i++) {
      setState(() {
        inst.add(data.institutions![i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          state: current_step == 0 ? StepState.indexed : StepState.complete,
          title: const Text("select instituion"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintText: 'Select your Institution',
                ),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                items: inst.map((pt) {
                  return DropdownMenuItem(
                    value: pt.alias,
                    child: Text(
                      pt.name!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _mySelection = newVal as String?;
                    // print(_mySelection);
                  });
                },
                value: _mySelection,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (current_step < 3 - 1) {
                        current_step = current_step + 1;
                      } else {
                        current_step = 0;
                      }
                    });
                  },
                  child: const Text("Continue"))
            ],
          )),
      Step(
          title: const Text("Verify Email & username "),
          state: current_step > 1 ? StepState.complete : StepState.indexed,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputContainer(
                  child: TextField(
                      cursorColor: kPrimaryColor,
                      controller: email_controller,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.mail,
                            color: kPrimaryColor,
                          ),
                          hintText: "Provide your email",
                          border: InputBorder.none))),
              InputContainer(
                  child: TextField(
                      cursorColor: kPrimaryColor,
                      controller: username_controller,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: "Select a username",
                          border: InputBorder.none))),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final data = await Usernameverificationrequest(
                            email: email_controller.text,
                            institution: "test",
                            username: username_controller.text);
                        final res = await Signupservice().checkusername(data);

                        if (res.success == true) {
                          setState(() {
                            if (current_step < 3 - 1) {
                              current_step = current_step + 1;
                            } else {
                              current_step = 0;
                            }
                          });
                        } else {
                          Fluttertoast.showToast(msg: res.message!);
                        }
                      },
                      child: const Text("Continue")),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          email_controller.clear();
                          username_controller.clear();
                          if (current_step > 0) {
                            current_step = current_step - 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      },
                      child: const Text("Cancel")),
                ],
              )
            ],
          )),
      Step(
          title: const Text("Setup new password "),
          state: current_step > 2 ? StepState.complete : StepState.indexed,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputContainer(
                  child: TextField(
                      cursorColor: kPrimaryColor,
                      controller: password_controller,
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          hintText: "Enter password",
                          border: InputBorder.none))),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final inf = await Setpasswordrequest(
                            username: username_controller.text,
                            email: email_controller.text,
                            password: password_controller.text,
                            institution: _mySelection!);

                        final result = await Signupservice().setpassword(inf);
                        if (result.success == true) {
                          setState(() {
                            current_step = current_step + 1;
                          });
                        } else {
                          Fluttertoast.showToast(msg: result.message!);
                        }
                      },
                      child: const Text("Continue")),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          password_controller.clear();
                          if (current_step > 0) {
                            current_step = current_step - 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      },
                      child: const Text("Cancel")),
                ],
              )
            ],
          )),
      Step(
          title: const Text("Complete Sign Up "),
          state: current_step > 3 ? StepState.complete : StepState.indexed,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign Up Completed"),
              const Text("Your Account Has Been Created"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Sign in new"))
            ],
          )),
    ];
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
            child: Stepper(
          currentStep: current_step,
          type: StepperType.vertical,
          controlsBuilder: (BuildContext context,
              ControlsDetails controls) {
              //     {void Function()? onStepCancel, void Function()? onStepContinue}){
            return const SizedBox(
              height: 1,
            );
          },
          steps: steps,
          // onStepTapped: (step) {
          //   setState(() {
          //     current_step = step;
          //   });
          // },
          // // onStepCancel: null,
          // onStepContinue: () {
          //   setState(() {
          //     if (current_step < steps.length - 1) {
          //       current_step = current_step + 1;
          //     } else {
          //       current_step = 0;
          //     }
          //   });
          // },
          // onStepCancel: () {
          //   setState(() {
          //     if (current_step > 0) {
          //       current_step = current_step - 1;
          //     } else {
          //       current_step = 0;
          //     }
          //   });
          // }
        )));
  }
}
