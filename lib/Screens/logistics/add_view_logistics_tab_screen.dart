import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/logistics/logistics.dart';
import 'package:schoolworkspro_app/Screens/logistics/view_logistics.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../constants/text_style.dart';
import 'components/lower_tab_bar.dart';
import 'logistics_view_model.dart';

class AddViewLogisticsTabScreen extends StatefulWidget {
  const AddViewLogisticsTabScreen({Key? key}) : super(key: key);

  @override
  State<AddViewLogisticsTabScreen> createState() => _AddViewLogisticsTabScreenState();
}

class _AddViewLogisticsTabScreenState extends State<AddViewLogisticsTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LogisticsViewModel>(
      builder: (context, value, child) {
       return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: black),
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
                        onTap: (){
                          value.itemLogisticTabTapped(0);
                        },
                        label: "Add Logistics",
                        borderColor: value.logisticTabBarIndex == 0 ? logoTheme : Colors.transparent,
                      ),

                      LowerBar(
                        onTap: (){
                          value.itemLogisticTabTapped(1);
                        },
                        label: "View Logistics",
                        borderColor: value.logisticTabBarIndex == 1 ? logoTheme : Colors.transparent,
                      ),

                    ],
                  ),
                ),
              )

            ),
          ),
          body: PageView(
            controller: value.logisticTabController,
            onPageChanged: (index){
              value.itemLogisticTabTapped(index);
            },
            children: [
              Logisticscreen(),
              Viewlogistics(),
            ],
          ),
        );
      },
    );
  }
}
