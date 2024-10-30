import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/inventory/inventory_tab_screen.dart';
import 'package:schoolworkspro_app/Screens/inventory/request_inventory.dart';
import 'package:schoolworkspro_app/Screens/logistics/add_view_logistics_tab_screen.dart';
import 'package:schoolworkspro_app/Screens/logistics/view_logistics.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/text_style.dart';
import 'components/tab_bar_page.dart';
import 'logistics_view_model.dart';

class LogisticsTabScreen extends StatefulWidget {
  const LogisticsTabScreen({Key? key}) : super(key: key);

  @override
  State<LogisticsTabScreen> createState() => _LogisticsTabScreenState();
}

class _LogisticsTabScreenState extends State<LogisticsTabScreen>
    with SingleTickerProviderStateMixin {
  late StatsCommonViewModel _provider;
  late RequestViewModel _provider2;
  late LogisticsViewModel _logisticsViewModel;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _logisticsViewModel =
          Provider.of<LogisticsViewModel>(context, listen: false);
_logisticsViewModel.itemLogisticTabTapped(0);
_logisticsViewModel.itemInventoryTabTapped(0);
_logisticsViewModel.itemTapped(0);
    });

    super.initState();
  }

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
  //     _provider2 = Provider.of<RequestViewModel>(context, listen: false);
  //     _provider.fetchCertificateNames();
  //     _provider2.fetchparentRequest();
  //     _provider2.fetchRequestLetter();
  //     _provider2.fetchMyTicket();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogisticsViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
              actions: [
                (viewModel.logisticMainIndex == 0 &&
                        viewModel.logisticTabBarIndex == 1)
                    ? PopupMenuButton<String>(
                        onSelected: (value) {},
                        itemBuilder: (BuildContext context) {
                          return ["All", "Returned", "Approved", "Pending"]
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              onTap: () {
                                viewModel.updatePopUpValue(choice);

                              },
                              child: Text(choice),
                            );
                          }).toList();
                        },
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.filter_alt,
                            color: white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
              centerTitle: false,
              title: const Text("Logistics",
                  style: TextStyle(color: white, fontWeight: FontWeight.w800)),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: white, //change your color here
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: SizedBox(
                  height: 40,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TabBarPage(
                            label: "Logistics",
                            containerColor: viewModel.logisticMainIndex == 0
                                ? white
                                : Colors.transparent,
                            textColor: viewModel.logisticMainIndex == 0
                                ? const Color(0xff004D96)
                                : white,
                            onTap: () {
                              viewModel.itemTapped(0);
                              viewModel.itemInventoryTabTapped(0);
                              viewModel.itemLogisticTabTapped(0);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TabBarPage(
                            label: "Inventory",
                            containerColor: viewModel.logisticMainIndex == 1
                                ? white
                                : Colors.transparent,
                            textColor: viewModel.logisticMainIndex == 1
                                ? const Color(0xff004D96)
                                : white,
                            onTap: () {
                              viewModel.itemTapped(1);
                            },
                          ),
                        ],
                      )),
                ),
              ),
              backgroundColor: logoTheme),
          body: PageView(
              controller: viewModel.logisticMainController,
              onPageChanged: (index) {
                viewModel.setMainIndex(index);
              },
              children: const [
                AddViewLogisticsTabScreen(),
                InventoryTabScreen(),
              ]));
    });
  }
}
