import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/dashboard/support/faq.dart';
import 'package:schoolworkspro_app/Screens/dashboard/support/terms_and_condition.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const terms_and_condition = """
<ol>
<li> We comply with all relevant laws on Privacy and Data Protection. In general, this means that we will only collect or process personal information for specific and lawful purposes, we won’t collect more than we need for those purposes or keep it for longer than necessary, we’ll do our best to keep it accurate, and we’ll keep it as safe as we can.</li>
<br>
<li> You need to match following requirements before you enroll to any of the courses.</li>
<li> Students are not allowed to share their login information with anyone</li>
<li> If a student tries to login in an account but fails after multiple attempts, then the account gets locked.</li>
<li> Your activities on an Online Course are shared with the course provider for academic research purposes. This includes the comments you make where you may disclose certain personal information about yourself.</li>
<li> Students should be well aware about the plagiarism they might get if they try to cheat or copy from any of their fellow friends for the assignments.</li>
<li> If you disagree with someone ideas you will discuss their ideas, rather than criticize or attack them personally.</li>
<li> You are supportive and constructive when offering feedback to other learners in activities such as Peer Review and discussions.</li>
<li> You are here to learn, not to advertise products or services, and you will not use SchoolWorksPro as a platform for campaigning.</li>
</ol>    

    """;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          title: const Text(
            'Help and Support',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      color: Colors.white,
                      height: 200,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Image.asset(
                              "assets/images/tickets.png",
                              height: 70,
                              width: 70,
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Having Problem?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'You are just a click away from a solution',
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            'We are 24*7 available at your service ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  'mailto:info@digiworkspro.com?body=I have sent this email from Schoolworkspro mobile app..');
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "assets/images/email.png",
                                      height: 40,
                                      width: 40,
                                      color: kPrimaryColor,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Write a mail',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(

                                  // context and builder are
                                  // required properties in this widget
                                  context: context,
                                  builder: (BuildContext context) {
                                    // we set up a container inside which
                                    // we create center column and display text
                                    return Container(
                                      height: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                launch('tel://+9779801224271');
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.phone),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('9801224271'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                launch('tel://+9779860143094');
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.phone),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('9860143094'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "assets/images/telephone.png",
                                      height: 40,
                                      width: 40,
                                      color: kPrimaryColor,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Make a Call',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FAQ(),
                                  ));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "assets/images/help.png",
                                      height: 40,
                                      width: 40,
                                      color: kPrimaryColor,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Help Yourself',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                '/ticketscreen',
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "assets/images/tickets.png",
                                      height: 40,
                                      width: 40,
                                      color: kPrimaryColor,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'My Tickets',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Termsandcondition(
                                            data: terms_and_condition),
                                  ));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "assets/images/contact.png",
                                      height: 40,
                                      width: 40,
                                      color: kPrimaryColor,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'T & C',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  'https://www.youtube.com/watch?v=jjSYhv7fGcI');
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child: Image.asset(
                                    "assets/images/youtube.png",
                                    height: 40,
                                    width: 40,
                                    color: kPrimaryColor,
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Videos',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  // ListTile(
                  //   leading: Image.asset(
                  //     "assets/icons/viber.png",
                  //     height: 30,
                  //     width: 30,
                  //   ),
                  //   title: Text('Viber'),
                  // ),
                  // ListTile(
                  //   leading: Image.asset(
                  //     "assets/icons/phone.png",
                  //     height: 30,
                  //     width: 30,
                  //   ),
                  //   title: Text('phone'),
                  // ),
                  // ListTile(
                  //   leading: Image.asset(
                  //     "assets/icons/messenger.png",
                  //     height: 30,
                  //     width: 30,
                  //   ),
                  //   title: Text('messenger'),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
