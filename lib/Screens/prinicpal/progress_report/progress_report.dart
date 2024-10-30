import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

class ProgressReportScreen extends StatefulWidget {
  const ProgressReportScreen({Key? key}) : super(key: key);

  @override
  _ProgressReportScreenState createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  late PrinicpalCommonViewModel _provider;
  late StatsCommonViewModel _provider2;
  String? selected;
  String? batch;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider2 = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider.fetchallteacher();
      _provider2.fetchAllBatch();
    });

    Fluttertoast.showToast(msg: "Select teacher and sections to view report");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, StatsCommonViewModel>(
        builder: (context, principal, stats, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,

          title: const Text(
            "Progress Report",
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: Text("Select Teacher"),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select teachers',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: principal.allteacher.map((pt) {
                return DropdownMenuItem(
                  value: pt.email,
                  child: Text(
                    "${pt.firstname} ${pt.lastname}",
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected = newVal as String?;
                  // print(_mySelection);
                  batch = null;
                });
              },
              value: selected,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: Text("Select Batch"),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select Batch/Section',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: stats.allbatches.map((pt) {
                return DropdownMenuItem(
                  value: pt.batch,
                  child: Text(
                    pt.batch.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  batch = newVal as String?;
                  // print(_mySelection);
                });

                stats.fetchAllProgressReport(
                    selected.toString(), batch.toString());
              },
              value: batch,
            ),
            isLoading(stats.progressreportApiResponse)
                ? const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: CupertinoActivityIndicator(),
                )
                : stats.allprogress.isEmpty
                    ? Image.asset('assets/images/no_content.PNG')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: stats.allprogress.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text(
                              stats.allprogress[index]['moduleSlug'].toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            children: [
                              ...List.generate(
                                stats.allprogress[index]['weeks'].length,
                                (i) => Card(
                                  child: ListTile(
                                    title: Text("week ${stats.allprogress[index]['weeks'][i]}"),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
          ],
        ),
      );
    });
  }
}
