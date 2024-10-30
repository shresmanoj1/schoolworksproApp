import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';

class AssessmentSubmissionCard extends StatelessWidget {
  String? label, value;
  Color? color;
  Color? valueColor;
  int? count;
  Function()? onTap;
  AssessmentSubmissionCard(
      {Key? key,
      this.value,
      this.valueColor,
      this.label,
      this.onTap,
      this.count,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label.toString(),
                      style: p14.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ))),
        Expanded(
            flex: 4,
            child: InkWell(
              onTap: onTap,
              child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: valueColor ?? color,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: value == "widget"
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.add_box,
                                    color: logoTheme,
                                  ),
                                  Text(" Comments (${count.toString()})")
                                ],
                              )
                            : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      value.toString(),
                                      style: p14.copyWith(
                                          decoration: label == "File" || label =="Your Submission"
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          decorationColor: logoTheme, decorationThickness: 2,),
                                    ),
                                ),
                                label == "File" || label =="Your Submission" ?
                                Icon(Icons.open_in_new, color: logoTheme,) : Container(),
                              ],
                            ),
                      ))),
            )),
      ],
    );
  }
}
