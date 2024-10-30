import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/connecteddevice_response.dart';
import 'package:schoolworkspro_app/services/connecteddevice_service.dart';
import 'package:intl/intl.dart';

class Connecteddevicescreen extends StatefulWidget {
  const Connecteddevicescreen({Key? key}) : super(key: key);

  @override
  _ConnecteddevicescreenState createState() => _ConnecteddevicescreenState();
}

class _ConnecteddevicescreenState extends State<Connecteddevicescreen> {
  Stream<Connecteddeviceresponse>? connected_response;

  @override
  void initState() {
    // TODO: implement initState
    connected_response =
        Connecteddeviceservice().getrefreshdevice(const Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: StreamBuilder<Connecteddeviceresponse>(
        stream: connected_response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.logins!.length,
              itemBuilder: (context, index) {
                var logins = snapshot.data!.logins![index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset("assets/images/connected.png"),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  const Text(
                                    "Device Type: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    logins.device!,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  const Text(
                                    "IP address",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(logins.ipAddress!),
                                ],
                              ),
                              Wrap(
                                children: [
                                  const Text(
                                    "Accessed date: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(logins.loggedInAt!),
                                ],
                              ),
                              Wrap(
                                children: [
                                  const Text(
                                    "Logged out:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 17,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: logins.loggedOut == false
                                        ? Colors.red
                                        : Colors.green,
                                  )
                                ],
                              ),
                              Wrap(
                                children: [
                                  const Text(
                                    "Current login: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: logins.current == false
                                        ? Colors.red
                                        : Colors.green,
                                  )
                                ],
                              ),
                            ],
                          ),
                          // trailing: Text("logout"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: SpinKitDualRing(color: kPrimaryColor));
          }
        },
      ),
    );
  }
}
