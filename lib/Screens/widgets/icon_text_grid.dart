import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '/constants/text_style.dart';

class IconTextGrid extends StatelessWidget {
  Function() onTap;
  String imageAsset;
  String title;
  IconTextGrid(
      {Key? key,
      required this.onTap,
      required this.imageAsset,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(

              imageAsset ?? "",

              height: 55,

              // height:50,
              width:50,
              fit: BoxFit.contain,

            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                String textSplit;
                // if (title.contains(" ")) {
                //   textSplit = title.replaceAll(" ", "\n");
                // } else {
                //   textSplit = title;
                // }
                if (constraints.maxWidth < 600) {
                  return Text(
                    title ?? "",
                    style: p14,
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Text(
                    title ?? "",
                    style: p14,
                    textAlign: TextAlign.center,
                  );
                }
              },
            )

          ]),
    );
  }
}
