import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/inventory/request_inventory.dart';
import 'package:schoolworkspro_app/Screens/inventory/viewinventory_request.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../logistics/components/lower_tab_bar.dart';
import '../logistics/logistics_view_model.dart';

class InventoryTabScreen extends StatefulWidget {
  const InventoryTabScreen({Key? key}) : super(key: key);

  @override
  State<InventoryTabScreen> createState() => _InventoryTabScreenState();
}

class _InventoryTabScreenState extends State<InventoryTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LogisticsViewModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LowerBar(
                      onTap: () {
                        value.itemInventoryTabTapped(0);
                      },
                      label: "Add Inventory",
                      borderColor: value.inventoryTabBarIndex == 0
                          ? logoTheme
                          : Colors.transparent,
                    ),
                    LowerBar(
                      onTap: () {
                        value.itemInventoryTabTapped(1);
                      },
                      label: "View Inventory",
                      borderColor: value.inventoryTabBarIndex == 1
                          ? logoTheme
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: PageView(
          controller: value.inventoryTabController,
          onPageChanged: (index) {
            value.itemLogisticTabTapped(index);
          },
          children: [
            Requestinventory(),
            Viewinventoryrequest(),
          ],
        ),
      );
    });
  }
}
