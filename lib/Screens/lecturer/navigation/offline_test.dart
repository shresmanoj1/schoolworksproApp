import 'package:flutter/material.dart';

class OfflineTest extends StatefulWidget {
  const OfflineTest({Key? key}) : super(key: key);

  @override
  _OfflineTestState createState() => _OfflineTestState();
}

class _OfflineTestState extends State<OfflineTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Container(
        child: Center(child: Text("hi, i am new dashboard"),),
      ),
    );
  }
}
