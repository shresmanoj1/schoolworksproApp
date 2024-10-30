import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class NumberIncDec extends StatefulWidget {
  final TextEditingController? controller;
  final title;
  final hintText;
  final initialValue;

  NumberIncDec({Key? key, this.controller, this.title, this.hintText, this.initialValue})
      : super(key: key);

  @override
  State<NumberIncDec> createState() => _NumberIncDecState();
}

class _NumberIncDecState extends State<NumberIncDec> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              initialValue: widget.initialValue,
              textAlign: TextAlign.left,
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText ?? "",
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Text(widget.title ?? "")),
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
                // WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
          ),
        ),
        Container(
          height: 38.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                    ),
                  ),
                ),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 18.0,
                  ),
                  onTap: () {
                    if (widget.controller!.text.isEmpty) {
                      int currentValue = 0;
                      setState(() {
                        currentValue++;
                        widget.controller!.text = (currentValue)
                            .toString(); // incrementing value
                      });
                    } else {
                      int currentValue =
                          int.parse(widget.controller!.text);
                      setState(() {
                        currentValue++;
                        widget.controller!.text = (currentValue)
                            .toString(); // incrementing value
                      });
                    }
                  },
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 18.0,
                ),
                onTap: () {
                  if (widget.controller!.text.isEmpty) {
                    int currentValue = 1;
                    setState(() {
                      currentValue--;
                      widget.controller!.text = (currentValue)
                          .toString(); // incrementing value
                    });
                  } else {
                    int currentValue =
                        int.parse(widget.controller!.text);
                    setState(() {
                      if (currentValue > 1) {
                        currentValue--;
                        widget.controller!.text = (currentValue)
                            .toString(); // incrementing value

                      }
                      currentValue--;
                    });
                  }
                },
              )
            ],
          ),
        )
    ]);
  }
}
