import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:intl/intl.dart';
import '../../components/shimmer.dart';
import '../../config/api_response_config.dart';
import '../../constants.dart';
import '../../constants/colors.dart';
import '../parents/More_parent/parent_request/view_parentrequest/parentrequestdetail_screen.dart';

class AssignedTicketScreen extends StatefulWidget {
  const AssignedTicketScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AssignedTicketScreen> createState() => _AssignedTicketScreenState();
}

class _AssignedTicketScreenState extends State<AssignedTicketScreen> {
  late RequestViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider2 = Provider.of<RequestViewModel>(context, listen: false);
      _provider2.fetchAssignedToUser();
    });
    super.initState();
  }

  getData() async {
    _provider2.fetchAssignedToUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestViewModel>(builder: (context, requestVM, child) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () => getData(),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              isLoading(requestVM.assignedToUserApiResponse)
                  ? const VerticalLoader()
                  : isError(requestVM.assignedToUserApiResponse)
                      ? Image.asset("assets/images/no_content.PNG")
                      : requestVM.assignedToUser.requests == null ||
                              requestVM.assignedToUser.requests!.isEmpty
                          ? Image.asset("assets/images/no_content.PNG")
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  requestVM.assignedToUser.requests?.length,
                              itemBuilder: (context, index) {
                                var ticket =
                                    requestVM.assignedToUser.requests?[index];

                                DateTime now = DateTime.parse(
                                    ticket?.createdAt.toString() ??
                                        DateTime.now().toString());

                                now = now
                                    .add(const Duration(hours: 5, minutes: 45));

                                var formattedTime =
                                    DateFormat('yMMMMd').format(now);

                                return InkWell(
                                  onTap: () {},
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  ticket?.status == "Resolved"
                                                      ? Colors.green
                                                      : logoTheme),
                                          top: BorderSide(
                                              color:
                                                  ticket?.status == "Resolved"
                                                      ? Colors.green
                                                      : logoTheme),
                                          right: BorderSide(
                                              color:
                                                  ticket?.status == "Resolved"
                                                      ? Colors.green
                                                      : logoTheme),
                                          left: BorderSide(
                                              color:
                                                  ticket?.status == "Resolved"
                                                      ? Colors.green
                                                      : logoTheme,
                                              width: 8),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(ticket?.topic ?? ""),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: ticket?.status ==
                                                                "Resolved"
                                                            ? Colors.green
                                                            : kPrimaryColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5.0))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Text(
                                                          ticket?.status ?? "",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 9,
                                                                  color: Colors
                                                                      .white)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Text(ticket['topic']),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: black,
                                                  ),
                                                  child: Text(
                                                      ticket?.ticketId ?? "",
                                                      style: const TextStyle(
                                                          color: white,
                                                          fontSize: 10)),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.event,
                                                      size: 15,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                    Text(formattedTime),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.timelapse,
                                                      size: 15,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                    Text(
                                                      DateFormat.jm().format(
                                                          ticket?.createdAt ??
                                                              DateTime.now()),
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.thermostat,
                                                      size: 15,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                    Text(
                                                        ticket?.severity ?? ""),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              ticket?.request ?? "",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 9,
                                                              vertical: 5)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          logoTheme),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Parentrequestdetailscreen(
                                                                id: ticket
                                                                        ?.id ??
                                                                    "")),
                                                  );
                                                },
                                                child:  Row(
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                      "Detail",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      size: 15,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
            ],
          ),
        ),
      );
    });
  }
}
