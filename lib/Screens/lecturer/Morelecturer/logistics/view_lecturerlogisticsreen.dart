import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/viewlogistics_service.dart';

// import '../../../../request/logistics_request.dart';
import '../../../../constants/colors.dart';
import '../../../../response/viewlogistics_response.dart';

class ViewLogisticsLecturerScreen extends StatefulWidget {
  const ViewLogisticsLecturerScreen({Key? key}) : super(key: key);

  @override
  _ViewLogisticsLecturerScreenState createState() =>
      _ViewLogisticsLecturerScreenState();
}

class _ViewLogisticsLecturerScreenState
    extends State<ViewLogisticsLecturerScreen> {
  Future<Viewlogisticsresponse>? _viewLogisticsResponse;
  // Future<Logistic> viewLogisticsResponse;
  List<InventoryRequested> inventoryRequested = [];

  @override
  void initState() {
    _viewLogisticsResponse = Viewlogisticservice().getlogistics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Viewlogisticsresponse>(
        future: _viewLogisticsResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.logistics!.isEmpty ? Column(children: <Widget>[
              Image.asset("assets/images/no_content.PNG"),
              const Text(
                "No data available",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ]):  ListView.builder(
                itemCount: snapshot.data!.logistics!.length,
                itemBuilder: (context, index) {
                  var logistics = snapshot.data!.logistics![index];
                  return  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Module : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                              Expanded(
                                child: Text(
                                    logistics.module!.moduleTitle!
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Status : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                              Text(
                                logistics.status!,
                                style: TextStyle(
                                    color:
                                    logistics.status! == "Approved"
                                        ? Colors.green
                                        : Color(0xff8B8000),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DataTable(
                            horizontalMargin: 0,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                    'Item name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  tooltip: 'Item name'),
                              DataColumn(
                                  label: Text(
                                    'Quantity',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  tooltip: 'Quantity'),
                            ],
                            rows: logistics.inventoryRequested!
                                .map((data) => DataRow(cells: [
                              DataCell(Text(
                                data.item!.itemName!,
                              )),
                              DataCell(Text(
                                data.quantity!,
                              )),
                            ]))
                                .toList(),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        logoTheme),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                        ))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext dialogcontext) {
                                        return AlertDialog(
                                            title: const Text("Feedback"),
                                            content: logistics.feedback!.isEmpty
                                                ? const Text(
                                                "Your request has not been reviewed yet!")
                                                : SizedBox(
                                              height: 200,
                                              width: 200,
                                              child: ListView.builder(
                                                  itemCount: logistics
                                                      .feedback!.length,
                                                  itemBuilder:
                                                      (context, i) {
                                                    return ListTile(
                                                      title: Text(logistics
                                                          .feedback![
                                                      i]
                                                          .firstname! +
                                                          " " +
                                                          logistics
                                                              .feedback![
                                                          i]
                                                              .lastname!),
                                                      subtitle: Text(
                                                          logistics
                                                              .feedback![
                                                          i]
                                                              .feedback!),
                                                    );
                                                  }),
                                            )
                                          // logistics.feedback!.isEmpty
                                          //     ? const Text(
                                          //         "Your request has not been reviewed yet!")
                                          //     : ListView.builder(
                                          //         shrinkWrap: true,
                                          //         scrollDirection:
                                          //             Axis.vertical,
                                          //         itemCount: logistics
                                          //             .feedback!.length,
                                          //         itemBuilder:
                                          //             (context, i) {
                                          // return SizedBox(
                                          //   height: 200,
                                          // child:
                                          // );
                                          // Text(logistics
                                          //     .feedback![
                                          //         i]
                                          //     .feedback!)
                                          // })
                                        );
                                      });
                                },
                                child: const Text("View Feedback")),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
                child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}