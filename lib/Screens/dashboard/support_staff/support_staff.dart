import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/response/supportstaff_response.dart';

import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../services/admin/ticket_service.dart';

class Supportstaff extends StatefulWidget {
  const Supportstaff({Key? key}) : super(key: key);

  @override
  _SupportstaffState createState() => _SupportstaffState();
}

class _SupportstaffState extends State<Supportstaff> {
  Future<SupportstaffResponse>? support_staff;

  late CommonViewModel _provider;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: logoTheme,
        title: const Text("Support Staff",
            style: TextStyle(color: white, fontWeight: FontWeight.w800)),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: white, //change your color here
        ),
      ),
      body: Consumer<CommonViewModel>(
        builder: (context, snapshot, child) {
          return isLoading(snapshot.supportStaffApiResponse)
              ? const VerticalLoader()
              : snapshot.supportStaff.staffs!.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/support.png",
                            height: 200,
                            width: 200,
                          ),
                          const Text(
                            "No support staff Assigned",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.supportStaff.staffs?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var datas = snapshot.supportStaff.staffs?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              //bottom border
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    datas['firstname'] +
                                        " " +
                                        datas['lastname'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 3)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                logoTheme),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                        ),
                                      ),
                                      onPressed: () async {
                                        try {
                                          final res = await AdminTicketService()
                                              .addticketwithoutimage(
                                                  "Require assistance",
                                                  "Student support",
                                                  "High",
                                                  "Student support",
                                                  datas['username'],
                                                  DateTime.now());

                                          if (res.success == true) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            snackThis(
                                                context: context,
                                                color: Colors.green,
                                                content: Text(
                                                    res.message.toString()));
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            snackThis(
                                                context: context,
                                                color: Colors.red,
                                                content: Text(
                                                    res.message.toString()));

                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        } on Exception catch (e) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          snackThis(
                                              context: context,
                                              color: Colors.red,
                                              content: Text(e.toString()));

                                          setState(() {
                                            _isLoading = false;
                                          });
                                          // TODO
                                        }
                                      },
                                      child: const Text(
                                          "Create a Support Ticket")),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
        },
      ),
    );
  }
}
