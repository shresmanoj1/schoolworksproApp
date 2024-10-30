import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/constants/colors.dart';


class CommonButton extends StatelessWidget {
  double? fontSize = 14;
  String? text = "Submit";
  Color? color = black;
  Color? textColor = white;
  Function()? onTap;

  CommonButton(
      {Key? key,
        this.fontSize,
        this.text,
        this.color,
        this.textColor,
        this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                  vertical: 7, horizontal: 5)),
          backgroundColor: MaterialStateProperty.all<Color>(color!),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
          ),
        ),
        onPressed: onTap,
        child: Text(text!,
            style: TextStyle(fontSize: fontSize, color: textColor)));
  }
}
