import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberIncDec extends StatefulWidget {
  final TextEditingController? controller;
  NumberIncDec({Key? key, this.controller}) : super(key: key);

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
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: widget.controller,
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
                        widget.controller!.text =
                            (currentValue).toString(); // incrementing value
                      });
                    } else {
                      int currentValue = int.parse(widget.controller!.text);
                      setState(() {
                        currentValue++;
                        widget.controller!.text =
                            (currentValue).toString(); // incrementing value
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
                    int currentValue = 0;
                    setState(() {
                      currentValue--;
                      widget.controller!.text =
                          (currentValue).toString(); // incrementing value
                    });
                  } else {
                    int currentValue = int.parse(widget.controller!.text);
                    setState(() {
                      currentValue--;
                      widget.controller!.text =
                          (currentValue).toString(); // incrementing value
                    });
                  }

                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
