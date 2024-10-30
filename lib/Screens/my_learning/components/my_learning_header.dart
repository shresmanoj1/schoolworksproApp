import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class MyLearningHeader extends StatelessWidget {
  const MyLearningHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: CupertinoTextField(

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: grey_400)),
                placeholder: "Search by title",
                onChanged: (value){

                },
                suffix: const Icon(
                  Icons.search,
                  color: grey_600,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 3,
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: grey_400)),
                placeholder: "Sort By",
                suffix: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: grey_600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
