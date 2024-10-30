import 'package:flutter/material.dart';

import '../../../constants/text_style.dart';

class LowerBar extends StatelessWidget {
  Function()? onTap;
  Color borderColor;
  String label;
  LowerBar({Key? key,this.onTap,required this.label,required this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
          decoration: BoxDecoration(

              border: Border(
                  bottom: BorderSide(color: borderColor,width: 4)
              )
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label,style: p13,),
          ))),
    );
  }
}

