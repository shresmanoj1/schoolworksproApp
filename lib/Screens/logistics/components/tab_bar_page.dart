import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';

class TabBarPage extends StatelessWidget {
  Color textColor;
  Color containerColor;
  String label;
  Function()? onTap;
  TabBarPage({Key? key,required this.textColor,required this.containerColor,required this.label,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: containerColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6))
        ),
        height: 60,
        width: 120,
        child: Center(child: Text(label,style: p14.copyWith(color: textColor,fontWeight:  FontWeight.w500,),)),
      ),
    );
  }
}
