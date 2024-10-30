import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/constants.dart';

class TabButton extends StatelessWidget {
  String? text;
  int? selectedPage;
  int? pageNumber;
  VoidCallback? onPressed;
  TabButton(
      {Key? key, this.text, this.selectedPage, this.pageNumber, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color:
              selectedPage == pageNumber ? kPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(
          vertical: selectedPage == pageNumber ? 12.0 : 0,
          horizontal: selectedPage == pageNumber ? 20.0 : 0,
        ),
        margin: EdgeInsets.symmetric(
          vertical: selectedPage == pageNumber ? 0 : 12.0,
          horizontal: selectedPage == pageNumber ? 0 : 20.0,
        ),
        child: Text(
          text ?? "Tab Button",
          style: TextStyle(
            color: selectedPage == pageNumber ? Colors.white : Colors.black, fontSize: 13
          ),
        ),
      ),
    );
  }
}
