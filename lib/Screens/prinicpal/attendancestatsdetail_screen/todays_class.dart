import 'package:flutter/material.dart';

class TodaysStudents extends StatefulWidget {
  const TodaysStudents({Key? key}) : super(key: key);

  @override
  _TodaysStudentsState createState() => _TodaysStudentsState();
}

class _TodaysStudentsState extends State<TodaysStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          "Present students",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [Container()],
      ),
    );
  }
}
