import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/driver/Dashboard-driver/studentlist_bus.dart';
import 'package:schoolworkspro_app/Screens/driver/driver_view_model.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/input_container.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/driver/busdetail_response.dart';
import 'package:schoolworkspro_app/response/driver/busstatus_changeresponse.dart';
import 'package:schoolworkspro_app/response/driver/getbus_response.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/driver/getbus_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:schoolworkspro_app/services/updateimage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../helper/app_version.dart';

class DashboardDriver extends StatefulWidget {
  const DashboardDriver({Key? key}) : super(key: key);

  @override
  _DashboardDriverState createState() => _DashboardDriverState();
}

class _DashboardDriverState extends State<DashboardDriver> {
  // late Future<GetBusResponse> bus_response;
  late Stream<GetBusDetailResponse> bus_detail;
  late Future authenticationmodel;
  PickedFile? _imageFile;
  final TextEditingController destination_controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? status;

  late DriverViewModel _provider;

  List items = [
    {"value": "on_way", "name": "On way"},
    {"value": "arrived", "name": "Arrived"},

    {"value": "cancelled", "name": "Cancelled"},
    // {"name": "", "value": ""},
  ];
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<DriverViewModel>(context, listen: false);
      _provider.fetchBusList();
    });
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    super.initState();
  }



  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? picked;

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null)
      setState(() {
        _time = picked!.replacing(hour: picked!.hourOfPeriod);
      });

    print(_time.hour);
    print(_time.minute);
    print(_time.period);
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );

  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
        Update(_imageFile!);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomSheet() {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            const Text(
              "choose photo",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.camera, color: Colors.red),
                  onPressed: () async {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image, color: Colors.green),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Consumer2<DriverViewModel, CommonViewModel>(
        builder: (context, model, common, child) {
      return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: () async {
                    final res = await LoginService().logout();
                    if (res.success == true) {
                      print(res);
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      await sharedPreferences.clear();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    } else {
                      snackThis(
                          context: context,
                          content: Text(res.success.toString()),
                          color: Colors.red,
                          duration: 1,
                          behavior: SnackBarBehavior.floating);
                    }
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    isLoading(common.authenticatedUserDetailApiResponse)
                        ? const Center(child: CupertinoActivityIndicator())
                        : common.authenticatedUserDetail == null
                            ? const Center(
                                child: Text("No Data Found"),
                              )
                            : Row(
                                children: [
                                  Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: common
                                                        .authenticatedUserDetail
                                                        .userImage ==
                                                    null
                                                ? Colors.grey
                                                : Colors.white,
                                            child: _imageFile == null
                                                ? common.authenticatedUserDetail
                                                            .userImage ==
                                                        null
                                                    ? Text(
                                                        common.authenticatedUserDetail
                                                                .firstname![0]
                                                                .toUpperCase() +
                                                            "" +
                                                            common
                                                                .authenticatedUserDetail
                                                                .lastname![0]
                                                                .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : ClipOval(
                                                        child: Image.network(
                                                          api_url2 +
                                                              '/uploads/users/' +
                                                              common
                                                                  .authenticatedUserDetail
                                                                  .userImage!,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                : ClipOval(
                                                    child: Image.file(
                                                      File(_imageFile!.path),
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: ((builder) =>
                                                  bottomSheet()),
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              color: Colors.green,
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ]),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          common.authenticatedUserDetail
                                                      .firstname ==
                                                  null
                                              ? const Text("")
                                              : Text(
                                                  common.authenticatedUserDetail
                                                          .firstname
                                                          .toString() +
                                                      " " +
                                                      common
                                                          .authenticatedUserDetail
                                                          .lastname
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22),
                                                ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.mail_outline,
                                                size: 21,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: common
                                                            .authenticatedUserDetail
                                                            .email ==
                                                        null
                                                    ? Text(" ")
                                                    : Text(
                                                        common
                                                            .authenticatedUserDetail
                                                            .email
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/icons/institution.png",
                                                height: 22,
                                                width: 22,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, top: 3),
                                                child:
                                                    common.authenticatedUserDetail
                                                                .institution ==
                                                            null
                                                        ? Text("")
                                                        : Text(
                                                            common
                                                                .authenticatedUserDetail
                                                                .institution
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        height: 20.0,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading(model.busListApiResponse)
                  ? const Center(child: CupertinoActivityIndicator())
                  : model.busList.buses == null || model.busList.buses!.isEmpty
                      ? const Center(
                          child: Text("No Bus Found"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: model.busList.buses?.length,
                          itemBuilder: (context, index) {
                            var buses = model.busList.buses?[index];
                            bus_detail = BusService().getRefreshBusDetailByID(
                                const Duration(milliseconds: 200),
                                buses?.id ?? "");

                            return InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentListBus(
                                        busName: buses?.busName ?? "N/A",
                                        busNumber: buses?.busNumber ?? "N/A",
                                        id: buses?.id ?? "",
                                      ),
                                    ));
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GFListTile(
                                      color: white,
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bus number: ${buses?.busNumber}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                              "Bus name: ${buses?.busName ?? "N/A"}"),
                                          Text("Bus route: ${buses?.route}"),
                                        ],
                                      ),
                                      avatar: Container(
                                          height: 160,
                                          width: 100,
                                          child: Image.asset(
                                              'assets/images/bus.png')),
                                    ),
                                    StreamBuilder<GetBusDetailResponse>(
                                      stream: bus_detail,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 10,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        children: [
                                                          const Text(
                                                            "Status: ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(snapshot.data
                                                                          ?.bus[
                                                                      "status"] ==
                                                                  "null"
                                                              ? "N/A"
                                                              : snapshot.data
                                                                      ?.bus[
                                                                  "status"]),
                                                        ],
                                                      ),
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        children: [
                                                          const Text(
                                                            "Estimated Time of Arrival: ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(snapshot.data
                                                                      ?.bus[
                                                                  "eta"] ??
                                                              "N/A"),
                                                        ],
                                                      ),
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        children: [
                                                          const Text(
                                                            "Next Stop: ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(snapshot.data?.bus[
                                                                          "next_stop"] ==
                                                                      null ||
                                                                  snapshot.data
                                                                              ?.bus[
                                                                          "next_stop"] ==
                                                                      ""
                                                              ? "N/A"
                                                              : snapshot.data
                                                                      ?.bus[
                                                                  "next_stop"]),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          showModalBottomSheet<
                                                              void>(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          2.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          2.0)),
                                                            ),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext
                                                                            context,
                                                                        setState) =>
                                                                    Padding(
                                                                        padding:
                                                                            MediaQuery.of(context).viewInsets,
                                                                        child: Container(
                                                                            child: Wrap(
                                                                          children: <
                                                                              Widget>[
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  color: Colors.grey.shade300,
                                                                                  height: 5,
                                                                                  width: 100,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const Center(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(top: 10.0),
                                                                                child: Text(
                                                                                  "Change Status",
                                                                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 50,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: DropdownButtonFormField(
                                                                                hint: const Text('Choose Status '),
                                                                                value: status,
                                                                                decoration: const InputDecoration(
                                                                                  border: InputBorder.none,
                                                                                  filled: true,
                                                                                ),
                                                                                icon: const Icon(Icons.arrow_drop_down_outlined),
                                                                                items: items.map((pt) {
                                                                                  return DropdownMenuItem(
                                                                                    value: pt["value"],
                                                                                    child: Text(pt["name"] ?? "N/A"),
                                                                                  );
                                                                                }).toList(),
                                                                                onChanged: (newVal) {
                                                                                  setState(() {
                                                                                    // print(newVal);
                                                                                    status = newVal as String;

                                                                                    // project_type = newVal;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            ListTile(
                                                                              onTap: () {
                                                                                selectTime(context);
                                                                              },
                                                                              trailing: const Icon(Icons.timer),
                                                                              title: const Text('Estimated Time of Arrival'),
                                                                              subtitle: Text(
                                                                                'Selected time: ${_time.format(context)}',
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: kPrimaryColor.withAlpha(50)),
                                                                                child: TextField(
                                                                                    cursorColor: kPrimaryColor,
                                                                                    controller: destination_controller,
                                                                                    decoration: const InputDecoration(
                                                                                        icon: Icon(
                                                                                          Icons.location_on,
                                                                                          color: kPrimaryColor,
                                                                                        ),
                                                                                        hintText: "Next stop",
                                                                                        border: InputBorder.none))),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                                                                                  child: SizedBox(
                                                                                    height: 40,
                                                                                    width: 95,
                                                                                    child: ElevatedButton(
                                                                                      style: ButtonStyle(
                                                                                          backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(18.0),
                                                                                          ))),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const Text("Cancel", style: TextStyle(fontSize: 14, color: Colors.black)),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                                                                                  child: SizedBox(
                                                                                    height: 40,
                                                                                    width: 95,
                                                                                    child: ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        Map<String, dynamic> datas = {
                                                                                          "status": status.toString(),
                                                                                          "eta": "${_time.format(context)}",
                                                                                          "next_stop": destination_controller.text
                                                                                        };
                                                                                        final res = await BusService().changeBusStatus(datas, buses!.id ?? "");

                                                                                        try {
                                                                                          if (res.success == true) {
                                                                                            Alert(
                                                                                              context: context,
                                                                                              style: alertStyle,
                                                                                              type: AlertType.success,
                                                                                              title: "Success",
                                                                                              buttons: [
                                                                                                DialogButton(
                                                                                                  child: const Text(
                                                                                                    "Close",
                                                                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  color: Colors.greenAccent.shade700,
                                                                                                  radius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                              ],
                                                                                            ).show();
                                                                                          } else {
                                                                                            Alert(
                                                                                              context: context,
                                                                                              style: alertStyle,
                                                                                              type: AlertType.error,
                                                                                              title: "Sorry",
                                                                                              buttons: [
                                                                                                DialogButton(
                                                                                                  child: Text(
                                                                                                    "Close",
                                                                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                    // Navigator.pop(context);
                                                                                                  },
                                                                                                  color: Colors.redAccent.shade700,
                                                                                                  radius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                              ],
                                                                                            ).show();
                                                                                          }
                                                                                        } catch (e) {
                                                                                          Alert(
                                                                                            context: context,
                                                                                            style: alertStyle,
                                                                                            type: AlertType.error,
                                                                                            title: "Sorry",
                                                                                            desc: "Could not connect to the server",
                                                                                            buttons: [
                                                                                              DialogButton(
                                                                                                child: Text(
                                                                                                  "Close",
                                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                  // Navigator.pop(context);
                                                                                                },
                                                                                                color: Colors.redAccent.shade700,
                                                                                                radius: BorderRadius.circular(10.0),
                                                                                              ),
                                                                                            ],
                                                                                          ).show();
                                                                                        }
                                                                                      },
                                                                                      style: ButtonStyle(
                                                                                          backgroundColor: MaterialStateProperty.all(Colors.green),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(18.0),
                                                                                          ))),
                                                                                      child: const Text(
                                                                                        "Save",
                                                                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 100,
                                                                            )
                                                                          ],
                                                                        ))),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(Icons
                                                            .edit_rounded)))
                                              ],
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        } else {
                                          return const Center(
                                            child: SpinKitDualRing(
                                              color: kPrimaryColor,
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      );
    });
  }

  Update(PickedFile abc) async {
    final result = await Imageservice().updateImage("users", abc);
    if (result.success == true) {
      Fluttertoast.showToast(msg: "Image updated succesfully");
    } else {
      Fluttertoast.showToast(msg: "Error updating image");
    }
  }
}
