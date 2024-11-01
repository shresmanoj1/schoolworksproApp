import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolworkspro_app/components/rounded_button.dart';
import 'package:schoolworkspro_app/components/rounded_input.dart';
import 'package:schoolworkspro_app/components/rounded_password_input.dart';
import 'package:schoolworkspro_app/response/findallinstitution_response.dart';
import 'package:schoolworkspro_app/services/findinstitution_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  Future<Findallinstitutionresponse>? institution_response;
  TextEditingController username_register = TextEditingController();
  TextEditingController password_register = TextEditingController();
  List projectType = ["individual", "group"];
  @override
  void initState() {
    // TODO: implement initState

    institution_response = Findallinstitutionservice().getallinstitution();
    // getData();
    super.initState();
  }

  // getData() async {
  //   final data = await Findallinstitutionservice().getallinstitution();
  //   for (int j = 0; j < data.institutions!.length; j++) {
  //     setState(() {
  //       institutions!.add(data.institutions![j]);
  //     });
  //   }
  // }

  int current_step = 0;
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: const Text('Select your institution'),
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select a Module',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: projectType.map((item) {
                return DropdownMenuItem(
                    child: Text("institutions![0].name!"),
                    value: "institutions![0].name");
              }).toList(),
              onChanged: (newVal) {
                // setState(() {
                //   _mySelection = newVal as String?;
                //   moduleSlug = newVal;
                // });
              },
              // value: _mySelection,
            ),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: Text('Verify Email & Username'),
        state: StepState.indexed,
        content: Column(
          children: <Widget>[Text("Email address"), Text("Username")],
        ),
        isActive: true,
      ),
      Step(
        title: Text('Setup new password'),
        content: Text('Setup new password'),
        state: StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text('Complete Sign Up'),
        content: Text('Complete Sign Up'),
        state: StepState.indexed,
        isActive: true,
      ),
    ];
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 40),
                  // SvgPicture.asset('assets/images/register.svg'),
                  const SizedBox(height: 40),
                  Stepper(
                      currentStep: current_step,
                      type: StepperType.vertical,
                      steps: steps,
                      onStepTapped: (step) {
                        setState(() {
                          current_step = step;
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (current_step < steps.length - 1) {
                            current_step = current_step + 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if (current_step > 0) {
                            current_step = current_step - 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      }),

                  // const RoundedInput(
                  //   icon: Icons.mail,
                  //   hint: 'Username',
                  // ),
                  // const RoundedInput(
                  //   icon: Icons.face_rounded,
                  //   hint: 'Name',
                  // ),
                  // const RoundedPasswordInput(hint: 'Password'),
                  const SizedBox(height: 10),
                  // RoundedButton(
                  //   title: 'SIGN UP',
                  //   onTap: () {},
                  // ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}