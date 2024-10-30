import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';

class RequeststatsBody extends StatefulWidget {
  final data;
  const RequeststatsBody({Key? key,this.data}) : super(key: key);

  @override
  _RequeststatsBodyState createState() => _RequeststatsBodyState();
}

class _RequeststatsBodyState extends State<RequeststatsBody> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StatsCommonViewModel>(context,listen: false).fetchassignedrequest(widget.data['username']);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<StatsCommonViewModel>(
      builder: (context,value,child) {

        return ListView(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        color: Colors.pinkAccent,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Backlog',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(value.backlog.toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        color: Colors.pink,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pending',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                             Text(value.pending.toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        color: Colors.purpleAccent,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'In Progress',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                             Text(value.approved.toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        color: Colors.blue,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Resolved',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            Text(value.resolved.toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        );
      }
    );
  }
}
