import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolworkspro_app/constants.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'FAQs',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.purple.shade100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Help?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'If you have any question regarding Schoolworkspro',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'please contact us at 9851164192, 9841934262',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email us at info@digiworkspro.com',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
              // child: const Text("""Help?
              //     If you have any question regarding Schoolworkspro, please contact us at 9851164192,
              //     9841934262 or"""),
            ),
          ),
          Column(
            children: const [
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'What is Schoolworkspro?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "'Schoolworkspro’ is a complete School/ College Management and Digital Learning Platform which helps to automate daily processes and activities, for better communication and information sharing within school, collect data and analyze it, present it in a dashboard for better decision making.",
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Does Schoolworkspro has E-Learning?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Yes, Schoolworkspro is a complete system which has School management, School automation and E-learning.',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'How to contact our support?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'For any help you can contact our support at 9801224271, 9860143094.',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'How long does it take to get Schoolworkspro operational in my school?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      '10 days of contracted date.',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'How to contact us for sales?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'You can contact our sales at 9841024120, 9801224528, 9851164192',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Is Schoolworkspro available in mobile phones?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Schoolworkspro comes with mobile phones both in Android and IOS.',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Does Schoolworkspro have a desktop app?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'No, Schoolworkspro doesn’t have a desktop app. But can be accessed using a web browser (https://www.schoolworkspro.com/ )',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                maintainState: true,
                textColor: Colors.black,
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Does Schoolworkspro have accounting and finance software?',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Yes, Schoolworkspro has a complete accounting software.)',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}
