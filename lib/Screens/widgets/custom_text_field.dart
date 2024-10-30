import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String hintText;
  final String? Function(String?)? validator;
  bool isRequired, obscureText, readOnly;
  DateTime? firstDate, lastDate;
  bool? icon;
  List<TextInputFormatter>? formatters;
  String? prefixText;
  FocusNode? focusNode;
  bool? requiredField;
  int? maxLength;
  Color? containerColor;
  Function(String)? onChanged;
  TextCapitalization textCapitalization;
  final TextEditingController controller;
  TextInputType keyboardType;
  bool noRightBorderRadius;
  Widget? prefix;
  bool? enabled;
  int? maxline;
  double? height;
  final bool hasBottomSpace;
  final Widget? suffixIcon;
  CustomTextField({
    Key? key,
    this.height = 45,
    this.icon,
    this.title,
    this.maxLength = 1,
    this.hintText = '',
    this.maxline = 1,
    this.onChanged,
    this.requiredField = false,
    this.enabled = true,
    this.formatters,
    this.containerColor = grey_100c,
    this.focusNode,
    this.isRequired = false,
    this.textCapitalization = TextCapitalization.sentences,
    required this.controller,
    this.readOnly = false,
    this.validator,
    this.prefixText = "",
    this.obscureText = false,
    this.noRightBorderRadius = false,
    this.keyboardType = TextInputType.text,
    this.hasBottomSpace = true,
    this.suffixIcon,
    this.prefix,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.title == null
            ? const SizedBox()
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title ?? "",
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
                widget.requiredField == true
                    ? Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(
                    "*",
                    style: GoogleFonts.openSans(
                        fontSize: 16, color: Colors.red),
                  ),
                )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        Container(
          height: widget.height,
            decoration: BoxDecoration(
                color: widget.containerColor,
                borderRadius: BorderRadius.circular(12)),
            child: TextFormField(
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatters,
              maxLines: widget.maxline,
              controller: widget.controller,
              obscureText: widget.obscureText,
              focusNode: widget.focusNode,
              style:
              GoogleFonts.poppins().copyWith(color: grey_600, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: widget.height! * 0.25, horizontal: 10),
                prefixText: widget.prefixText,
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffixIcon,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: grey_400),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: grey_400),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: grey_400),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: grey_400),
                ),
              ),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
