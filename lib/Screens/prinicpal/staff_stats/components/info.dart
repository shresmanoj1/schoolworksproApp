import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';

class InfoScreen extends StatefulWidget {
  final data;
  const InfoScreen({Key? key, this.data}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late StatsCommonViewModel _provider;
  List<String> selected_batch = <String>[];
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider.fetchsupportstaffs(widget.data['username']);
      _provider.fetchAllBatch();

      selected_batch = _provider.supportStaff.cast<String>();
      // widget.data['courseSlug'].cast<String>();
    });

    // print(_provider.supportStaff);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsCommonViewModel>(builder: (context, value, child) {
      return ListView(
        children: [
          ListTile(
            leading: SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.data['userImage'] == null
                      ? Colors.grey
                      : Colors.white,
                  child: widget.data['userImage'] == null ||
                          widget.data['userImage'].isEmpty
                      ? Text(
                          widget.data['firstname'][0].toUpperCase() +
                              "" +
                              widget.data['lastname'][0].toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: api_url2 +
                                '/uploads/users/' +
                                widget.data['userImage'],
                            placeholder: (context, url) => Container(
                                child: const Center(
                                    child: CupertinoActivityIndicator())),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data['firstname'].toString() +
                      " " +
                      widget.data['lastname'].toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Chip(
                  backgroundColor: kPrimaryColor,
                  label: Text(
                    widget.data['type'].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Email: " + widget.data['email'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text("Address: " + widget.data['address'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text("Contact: " + widget.data['contact'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Marital Status: " +
                        widget.data['maritalStatus'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Personal PAN: " +
                        widget.data['pan_number'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "PF Number: " + widget.data['pf_number'].toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Bank A/c: " + widget.data['bank_account'].toString()),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Assign as support staff for:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MultiSelectDialogField(
              // validator: ,
              items: value.allbatches
                  .map((e) =>
                      MultiSelectItem(e.batch.toString(), e.batch.toString()))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              initialValue: selected_batch,
              autovalidateMode: AutovalidateMode.always,
              onConfirm: (List<String> values) {
                setState(() {
                  selected_batch = values;
                  print(selected_batch);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> datas = {
                    "username": widget.data['username'],
                    "batches": selected_batch
                  };
                  print(selected_batch);
                  //
                  final res = await StatsRepository().assignbatch(datas);
                  if (res.success == true) {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => super.widget,));
                    Fluttertoast.showToast(msg: res.message.toString());
                  } else {
                    Fluttertoast.showToast(msg: res.message.toString());
                  }
                },
                child: const Text("Assign")),
          )
        ],
      );
    });
  }
}
