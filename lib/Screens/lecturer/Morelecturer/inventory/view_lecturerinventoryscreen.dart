import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/viewinventoryrequest_response.dart';
import 'package:schoolworkspro_app/services/inventoryrequest_service.dart';

class ViewinventoryrequestLecturer extends StatefulWidget {
  const ViewinventoryrequestLecturer({Key? key}) : super(key: key);

  @override
  _ViewinventoryrequestLecturerState createState() =>
      _ViewinventoryrequestLecturerState();
}

class _ViewinventoryrequestLecturerState
    extends State<ViewinventoryrequestLecturer> {
  Future<Viewinventoryrequestresponse>? _viewInventoryRequestResponse;

  @override
  void initState() {
    // TODO: implement initState
    _viewInventoryRequestResponse =
        ViewInventoryRequestService().getMyInventoryRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "My Inventory request",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: FutureBuilder<Viewinventoryrequestresponse>(
        future: _viewInventoryRequestResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return   snapshot.data!.inventoryReq!.isEmpty ? Column(children: <Widget>[
              Image.asset("assets/images/no_content.PNG"),
              const Text(
                "No data available",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ]): ListView.builder(
                itemCount: snapshot.data!.inventoryReq!.length,
                itemBuilder: (context, index) {
                  var inventory = snapshot.data!.inventoryReq![index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(inventory.module!.moduleTitle!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0)),

                          trailing: Chip(
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            backgroundColor: inventory.status! == "Approved"
                                ? Colors.green
                                : Colors.yellow,
                            label: Text(
                              inventory.status!,
                              style: TextStyle(
                                  color: inventory.status! == "Approved"
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12),
                            ),
                          ),
                          // color: Colors.orange,
                        ),
                        DataTable(
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
                        ButtonBar(
                          children: [
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext dialogcontext) {
                                        return AlertDialog(
                                            title: const Text("Feedback"),
                                            content: inventory.feedback!.isEmpty
                                                ? const Text(
                                                    "Your request has not been reviewed yet!")
                                                : SizedBox(
                                                    height: 200,
                                                    width: 200,
                                                    child: ListView.builder(
                                                        itemCount: inventory
                                                            .feedback!.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return ListTile(
                                                            title: Text(inventory
                                                                    .feedback![
                                                                        i]
                                                                    .firstname! +
                                                                " " +
                                                                inventory
                                                                    .feedback![
                                                                        i]
                                                                    .lastname!),
                                                            subtitle: Text(
                                                                inventory
                                                                    .feedback![
                                                                        i]
                                                                    .feedback!),
                                                          );
                                                        }),
                                                  ));
                                      });
                                },
                                child: const Text(
                                  "view feedback",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
                child: SpinKitDualRing(
              color: kPrimaryColor,
            ));
          }
        },
      ),
    );
  }
}
