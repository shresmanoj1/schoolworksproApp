import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics_view_model.dart';
import 'package:schoolworkspro_app/response/viewinventoryrequest_response.dart';
import 'package:intl/intl.dart';
import '../../components/shimmer.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';

class Viewinventoryrequest extends StatefulWidget {
  const Viewinventoryrequest({Key? key}) : super(key: key);

  @override
  _ViewinventoryrequestState createState() => _ViewinventoryrequestState();
}

class _ViewinventoryrequestState extends State<Viewinventoryrequest> {
  // Future<Viewinventoryrequestresponse>? _viewInventoryRequestResponse;
  late LogisticsViewModel _provider;

  @override
  void initState() {
    // _viewInventoryRequestResponse =
    //     ViewInventoryRequestService().getMyInventoryRequest();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<LogisticsViewModel>(context, listen: false);
      _provider.fetchInventory();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LogisticsViewModel>(

        builder: (context, snapshot, child) {

          return isLoading(snapshot.requestInventoryApiResponse)
              ? const VerticalLoader()
              : snapshot.requestInventory.inventoryReq == null ||
                      snapshot.requestInventory.inventoryReq!.isEmpty
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
                      itemCount: snapshot.requestInventory.inventoryReq!.length,
                      itemBuilder: (context, index) {
                        var inventory =
                            snapshot.requestInventory.inventoryReq![index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const Text("Module : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0)),
                                  Expanded(
                                    child: Text(inventory.module!.moduleTitle.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17.0)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  const Text("Status : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0)),
                                  Text(
                                    inventory.status!,
                                    style: TextStyle(
                                        color: inventory.status! == "Approved"
                                            ? Colors.green
                                            : Color(0xff8B8000),
                                        fontSize: 17),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10,),
                              const Text("Project Type : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),

                              inventory.projectType == "individual"
                                  ? ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(inventory.projectType!, style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                      fontSize: 17.0)))
                                  : ExpansionTile(
                                initiallyExpanded: false,
                                childrenPadding: EdgeInsets.zero,
                                tilePadding: EdgeInsets.zero,

                                title: Text(inventory.projectType!, style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                                children: inventory.studentList!
                                    .map((studentName) {
                                  return Text(studentName);
                                }).toList(),
                              ),
                              // const SizedBox(height: 10,),

                              DataTable(
                                horizontalMargin: 0,
                                columns: const [
                                  DataColumn(
                                      label: Text(
                                        'Item name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                      tooltip: 'Item name'),
                                ],
                                rows: inventory.inventoryRequested!
                                    .map((data) => DataRow(cells: [
                                  DataCell(Text(
                                    data,
                                  )),
                                ]))
                                    .toList(),
                              ),

                              const SizedBox(height: 10,),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(logoTheme),
                                        shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0),
                                            ))),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogcontext) {
                                            return AlertDialog(
                                                title: const Text("Feedback"),
                                                content: inventory
                                                    .feedback!.isEmpty
                                                    ? const Text(
                                                    "Your request has not been reviewed yet!")
                                                    : SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child:
                                                  ListView.builder(
                                                      itemCount: inventory
                                                          .feedback!
                                                          .length,
                                                      itemBuilder:
                                                          (context,
                                                          i) {
                                                        return ListTile(
                                                          title: Text(inventory
                                                              .feedback![
                                                          i]
                                                              .firstname! +
                                                              " " +
                                                              inventory
                                                                  .feedback![i]
                                                                  .lastname!),
                                                          subtitle: Text(inventory
                                                              .feedback![
                                                          i]
                                                              .feedback!),
                                                        );
                                                      }),
                                                ));
                                          });
                                    },
                                    child: const Text("View Feedback")),
                              )

                            ],
                          ),
                        );
                      });
        },
      ),
    );
  }
}
