import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/get_logistics_stats_response.dart';
import 'package:schoolworkspro_app/services/get_logisticsstats_service.dart';

class LogisticsScreeenStats extends StatefulWidget {
  final data;
  const LogisticsScreeenStats({Key? key, this.data}) : super(key: key);

  @override
  _LogisticsScreeenStatsState createState() => _LogisticsScreeenStatsState();
}

class _LogisticsScreeenStatsState extends State<LogisticsScreeenStats> {
  Future<GetLogisticsforStatsResponse>? logistics_response;

  @override
  void initState() {
    // TODO: implement initState
    logistics_response =
        LogisiticsStatsService().getLogisticsforStats(widget.data['username']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            "Logistics Request",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<GetLogisticsforStatsResponse>(
            future: logistics_response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("Total Logistics Requests: ${snapshot.data!.totalCount}",style: const TextStyle(color: kPrimaryColor,fontSize: 16),),
                    ),
                    snapshot.data!.logistics!.isEmpty ? Image.asset('assets/images/no_content.PNG') : ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data?.logistics?.length,
                      itemBuilder: (context, index) {
                        var datas = snapshot.data?.logistics?[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Chip(
                                       label: Text(
                                         datas!.status.toString(),
                                         style: TextStyle(
                                           color: datas.status == "Approved"
                                               ? Colors.white
                                               : Colors.black,
                                         ),
                                       ),
                                       backgroundColor: datas.status == "Approved"
                                           ? Colors.green
                                           : Colors.grey.shade200,
                                     ),
                                     Text(
                                       datas.module!.moduleTitle.toString(),
                                       style: const TextStyle(color: Colors.black),
                                     ),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("Project Type: ${datas.projectType}")
                                       ],
                                     ),
                                     Builder(
                                         builder: (context) {
                                           if(datas.createdAt != null) {
                                             DateTime created =
                                             DateTime.parse(datas.createdAt.toString());

                                             created =
                                                 created.add(const Duration(hours: 5, minutes: 45));

                                             var formattedTime =
                                             DateFormat('y MMMM d').format(created);
                                             return Text("Requested At: $formattedTime");
                                           }

                                           return const Text("Requested At: ");
                                         }
                                     ),
                                     Builder(
                                         builder: (context) {
                                           if(datas.returnedDate != null) {
                                             DateTime created =
                                             DateTime.parse(datas.returnedDate.toString());

                                             created =
                                                 created.add(const Duration(hours: 5, minutes: 45));

                                             var formattedTime =
                                             DateFormat('y MMMM d,').format(created);
                                             return Text("Returned At: $formattedTime");
                                           }

                                           return const Text("Returned At: ");
                                         }
                                     ),
                                   ],
                                 ),
                               ),


                                const Padding(
                                  padding:  EdgeInsets.only(left: 10.0),
                                  child: Text("Item Requested",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                ),
                                ListView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: datas.inventoryRequested!.length,
                                  itemBuilder: (context, i) {
                                    var inventoryRequested =
                                        datas.inventoryRequested?[i];
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 2
                                            )

                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(

                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Item name: ${inventoryRequested!.item!.itemName}"),
                                                  Text("Quantity: ${inventoryRequested.quantity}")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                      ],
                                    );
                                  },
                                ),

                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   physics: const ScrollPhysics(),
                                //   itemCount: datas['inventoryRequested'].length,
                                //   itemBuilder: (context,i){
                                //     return Text(datas['inventoryRequested'][i]['quantity'].toString());
                                //   },
                                // )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return VerticalLoader();
              }
            },
          ),
        ));
  }
}
