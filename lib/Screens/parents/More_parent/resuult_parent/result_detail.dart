import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../response/result_response.dart';

class Resultdetail extends StatefulWidget {
  Result? data;
  Resultdetail({Key? key, this.data}) : super(key: key);

  @override
  _ResultdetailState createState() => _ResultdetailState();
}

class _ResultdetailState extends State<Resultdetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Builder(builder: (context) {
                    try {
                      return widget.data!.subject!.isEmpty ||
                              widget.data?.subject == null
                          ? const Text('')
                          : Text(
                              widget.data!.subject.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                    } on Exception catch (e) {
                      return Text('');
                      // TODO
                    }
                  }),
                ),
                Center(
                  child: Builder(builder: (context) {
                    try {
                      return widget.data!.gd!.isEmpty || widget.data?.gd == null
                          ? Text('')
                          : Text(
                              "Grade: " + widget.data!.gd.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                    } on Exception catch (e) {
                      return Text('');
                      // TODO
                    }
                  }),
                ),
                Center(
                  child: Builder(builder: (context) {
                    try {
                      return widget.data!.cr!.isEmpty || widget.data?.cr == null
                          ? Text('')
                          : Text(
                              "Credit: " + widget.data!.cr.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                    } on Exception catch (e) {
                      return Text('');
                      // TODO
                    }
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          try {
                            return widget.data!.ex!.isEmpty ||
                                    widget.data?.ex == null ||
                                    widget.data!.ex.toString().contains('-')
                                ? CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 5.0,
                                    animationDuration: 1200,
                                    animation: true,
                                    center: Center(
                                      child:
                                          Text('ex' + "\n " + widget.data!.ex!),
                                    ),
                                    progressColor: Colors.green,
                                    percent: 0 / 100)
                                : CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 5.0,
                                    animationDuration: 1200,
                                    animation: true,
                                    center: Center(
                                      child: Text('ex' +
                                          "\n " +
                                          widget.data!.ex.toString()),
                                    ),
                                    progressColor: Colors.green,
                                    percent: double.parse(
                                            widget.data!.ex!.split(".")[0]) /
                                        100);
                          } catch (e) {
                            return CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 5.0,
                                animationDuration: 1200,
                                animation: true,
                                center: Center(
                                  child: Text('ex' + "\n " + ""),
                                ),
                                progressColor: Colors.green,
                                percent: 0 / 100);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          try {
                            return widget.data!.cw!.isEmpty ||
                                    widget.data?.cw == null ||
                                    widget.data!.cw!.contains('-')
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 5.0,
                                        animationDuration: 1200,
                                        animation: true,
                                        center: Center(
                                          child: Text(
                                              'cw' + "\n " + widget.data!.cw!),
                                        ),
                                        progressColor: Colors.green,
                                        percent: 0 / 100),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 5.0,
                                        animationDuration: 1200,
                                        animation: true,
                                        center: Center(
                                          child: Text(
                                              'cw' + "\n " + widget.data!.cw!),
                                        ),
                                        progressColor: Colors.green,
                                        percent: double.parse(widget.data!.cw!
                                                .split(".")[0]) /
                                            100),
                                  );
                          } catch (e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CircularPercentIndicator(
                                  radius: 40.0,
                                  lineWidth: 5.0,
                                  animationDuration: 1200,
                                  animation: true,
                                  center: Center(
                                    child: Text('cw' + "\n " + ""),
                                  ),
                                  progressColor: Colors.green,
                                  percent: 0 / 100),
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          try {
                            return widget.data!.mm!.isEmpty ||
                                    widget.data?.mm == null ||
                                    widget.data!.mm!.contains('-')
                                ? CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 5.0,
                                    animationDuration: 1200,
                                    animation: true,
                                    center: Center(
                                      child:
                                          Text('mm' + "\n " + widget.data!.mm!),
                                    ),
                                    progressColor: Colors.green,
                                    percent: 0 / 100)
                                : CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 5.0,
                                    animationDuration: 1200,
                                    animation: true,
                                    center: Center(
                                      child:
                                          Text('mm' + "\n " + widget.data!.mm!),
                                    ),
                                    progressColor: Colors.green,
                                    percent: double.parse(
                                            widget.data!.mm!.split(".")[0]) /
                                        100);
                          } catch (e) {
                            return CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 5.0,
                                animationDuration: 1200,
                                animation: true,
                                center: Center(
                                  child: Text('mm' + "\n " + ""),
                                ),
                                progressColor: Colors.green,
                                percent: 0 / 100);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
