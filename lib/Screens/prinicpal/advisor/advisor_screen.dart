import 'package:flutter/material.dart';

class AdvisorScreen extends StatefulWidget {
  const AdvisorScreen({Key? key}) : super(key: key);

  @override
  _AdvisorScreenState createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black38),
        title: const Text(
          "Admissions",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [

        ],
      ),
    );
  }
}
