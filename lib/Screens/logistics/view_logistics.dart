import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/viewlogistics_response.dart';
import 'package:schoolworkspro_app/services/viewlogistics_service.dart';

class Viewlogistics extends StatefulWidget {
  const Viewlogistics({Key? key}) : super(key: key);

  @override
  _ViewlogisticsState createState() => _ViewlogisticsState();
}

class _ViewlogisticsState extends State<Viewlogistics> with SingleTickerProviderStateMixin {
  List<InventoryRequested> inventoryRequested = [];
  late LogisticsViewModel _provider;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<LogisticsViewModel>(context, listen: false);

      _provider.fetchMyLogistics();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogisticsViewModel>(builder: (context, snapshot, child) {
      return Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   automaticallyImplyLeading: false,
          //   backgroundColor: white,
          //   actions: [
          //     PopupMenuButton<String>(
          //       onSelected: (value) {},
          //       itemBuilder: (BuildContext context) {
          //         return ["All", "Returned", "Approved", "Pending"].map((String choice) {
          //           return PopupMenuItem<String>(
          //             value: choice,
          //             onTap: () {
          //               if (choice == "All") {
          //                 setState(() {
          //                   _listForDisplay = _list;
          //                 });
          //               } else {
          //                 setState(() {
          //                   _listForDisplay = _list
          //                       .where((element) => element["status"] == "choice")
          //                       .toList();
          //                 });
          //               }
          //             },
          //             child: Text(choice),
          //           );
          //         }).toList();
          //       },
          //       icon: const Padding(
          //         padding: EdgeInsets.only(right: 20),
          //         child: Icon(
          //           Icons.filter_alt,
          //           color: black,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          body: isLoading(snapshot.requestLogisticsApiResponse)
              ? const VerticalLoader()
              : snapshot.filterData == null ||
                      snapshot.filterData.isEmpty
                  ? Column(
                      children: [
                        Image.asset("assets/images/no_content.PNG"),
                        const Text(
                          "No data available",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: snapshot.filterData.length,
                      itemBuilder: (context, index) {
                        var logistics = snapshot.filterData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Module : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0)),
                                    Expanded(
                                      child: Text(
                                          logistics.module?.moduleTitle ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15.0)),
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
                                            fontSize: 15.0)),
                                    Text(
                                      logistics.status ?? "",
                                      style: TextStyle(
                                          color:
                                              logistics.status == "Approved"
                                                  ? Colors.green
                                                  : Color(0xff8B8000),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text("Project Type : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                                logistics.projectType.toString() ==
                                            "individual" ||
                                        logistics.projectType.toString() ==
                                            "Individual"
                                    ? ListTile(
                                  contentPadding: EdgeInsets.zero,
                                        title: Text(logistics.projectType.toString(),
                                            style: const TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 15.0)))
                                    : Builder(
                                        builder: (context) {
                                          print(logistics.studentList);
                                          return ExpansionTile(
                                            childrenPadding: EdgeInsets.zero,
                                              tilePadding: EdgeInsets.zero,
                                              initiallyExpanded: false,
                                              title: Text(
                                                  logistics.projectType
                                                      .toString(),
                                                  style: const TextStyle(
                                                      // fontWeight:
                                                      //     FontWeight.bold,
                                                      fontSize: 15.0)),
                                              children: [
                                                logistics.studentList ==
                                                        null
                                                    ? const SizedBox()
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...List.generate(
                                                              logistics.studentList!
                                                                  .length,
                                                              (index) => Text(
                                                                  logistics.studentList!
                                                                          [
                                                                          index]
                                                                      .toString()))
                                                        ],
                                                      )
                                              ]);
                                        },
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
                                              fontSize: 15.0),
                                        ),
                                        tooltip: 'Item name'),
                                    DataColumn(
                                        label: Text(
                                          'Quantity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        tooltip: 'Quantity'),
                                  ],
                                  rows: logistics.inventoryRequested!
                                      .map<DataRow>((data) => DataRow(cells: [
                                            DataCell(Text(
                                              data.item?.itemName ?? "",
                                            )),
                                            DataCell(Text(
                                              data.quantity.toString()
                                            )),
                                          ]))
                                      .toList(),
                                ),
                                const SizedBox(
                                  height: 10,
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
                                            builder:
                                                (BuildContext dialogcontext) {
                                              return AlertDialog(
                                                  title: const Text("Feedback"),
                                                  content: logistics.feedback!
                                                          .isEmpty
                                                      ? const Text(
                                                          "Your request has not been reviewed yet!")
                                                      : SizedBox(
                                                          height: 200,
                                                          width: 200,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      logistics.feedback!.length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          i) {
                                                                    return ListTile(
                                                                      // title: Text(logistics.feedback?[i].firstname.toString() +
                                                                      //     " " +
                                                                      //     logistics.feedback![i]
                                                                      //         [
                                                                      //         "lastname"]!),
                                                                      // subtitle: Text(
                                                                      //     logistics.feedback[i]
                                                                      //         [
                                                                      //         "feedback"]!),
                                                                    );
                                                                  }),
                                                        ));
                                            });
                                      },
                                      child: const Text("View Feedback")),
                                )
                              ],
                            ),
                          ),
                        );
                      }));
    });
  }
}
