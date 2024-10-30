import 'package:flutter/material.dart';

alertBoxWidget(
    {required BuildContext context,
    required String title,
    required String content,
    required Function() onTap}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title:  Text(title),
      content:  Text(content),
      actions: <Widget>[
        TextButton(onPressed: onTap, child: const Text("okay")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
      ],
    ),
  );
}
