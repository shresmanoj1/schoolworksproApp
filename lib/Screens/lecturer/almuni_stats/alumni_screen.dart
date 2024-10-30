import 'package:flutter/material.dart';

class AlmuniStatsScreen extends StatefulWidget {
  const AlmuniStatsScreen({Key? key}) : super(key: key);

  @override
  _AlmuniStatsScreenState createState() => _AlmuniStatsScreenState();
}

class _AlmuniStatsScreenState extends State<AlmuniStatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Alumni Stats",style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: [
          const Text("Select batch"),
          // DropdownButtonFormField(
          //   isExpanded: true,
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     filled: true,
          //     hintText: 'Select leave type',
          //   ),
          //   icon: const Icon(Icons
          //       .arrow_drop_down_outlined),
          //   items: inst.map((pt) {
          //     return DropdownMenuItem(
          //       value: pt,
          //       child: Text(
          //         pt,
          //         overflow:
          //         TextOverflow.ellipsis,
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: (newVal) {
          //     setState(() {
          //       _mySelection =
          //       newVal as String?;
          //       // print(_mySelection);
          //     });
          //   },
          //   value: _mySelection,
          // ),
        ],
      ),
    );
  }
}
