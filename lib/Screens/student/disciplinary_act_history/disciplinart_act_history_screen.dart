import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../components/shimmer.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../prinicpal/stats_common_view_model.dart';

class DisciplinaryActHistoryScreen extends StatefulWidget {
  const DisciplinaryActHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DisciplinaryActHistoryScreen> createState() =>
      _DisciplinaryActHistoryScreenState();
}

class _DisciplinaryActHistoryScreenState
    extends State<DisciplinaryActHistoryScreen> {
  late StatsCommonViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
      // _provider.fetchAllAct();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: logoTheme,
        title: const Text("Disciplinary Offence Level",
            style: TextStyle(color: white, fontWeight: FontWeight.w800)),
        elevation: 0.0,
      ),
      body: Consumer<StatsCommonViewModel>(builder: (context, common, child) {
        return isLoading(common.disciplinaryApiResponse)
            ? const VerticalLoader()
            : Container(
                child: common.act == null || common.act.isEmpty
                    ? Image.asset('assets/images/no_content.PNG')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: common.act.length,
                        itemBuilder: (context, i) {
                          var datas = common.act[i];
                          return StickyHeader(
                            header: Container(
                              height: 50.0,
                              color: const Color(0xff001930),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                datas.level ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Types of Misconduct",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  datas.misconduct == null
                                      ? const Text("No Misconducts")
                                      : Builder(builder: (context) {
                                          var misconductSplit = datas.misconduct
                                              .toString()
                                              .split(";");
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: misconductSplit.length,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0, right: 4),
                                                  child: Image.asset(
                                                    "assets/images/hand_Pointing_Right.png",
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  misconductSplit[index]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                  textAlign: TextAlign.start,
                                                ))
                                              ],
                                            ),
                                          );
                                        }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Action",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  datas.action == null
                                      ? const Text("No Actions")
                                      : Builder(builder: (context) {
                                          var actionSplit =
                                              datas.action!.split(";");
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: actionSplit.length,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0, right: 4),
                                                  child: Image.asset(
                                                    "assets/images/hand_Pointing_Right.png",
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  actionSplit[index].toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ))
                                              ],
                                            ),
                                          );
                                        }),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              );
      }),
    );
  }
}
