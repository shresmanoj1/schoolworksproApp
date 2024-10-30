import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/constants/text_style.dart';

import '../../../../constants.dart';

class MultiSelectField extends StatelessWidget {
  final List<String?> initialSelectedVariables;
  final List<MultiSelectItem<String?>> items;
  final Function(List<String?>) onConfirm;
  final Function(String? chipTap) onChipTap;

  const MultiSelectField({
    Key? key,
    required this.initialSelectedVariables,
    required this.items,
    required this.onConfirm,
    required this.onChipTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      isDismissible: true,
      initialValue: initialSelectedVariables,
      searchable: true,
      buttonText: Text(
        "Select miscellaneous information",
        style: p14.copyWith(color: grey_600),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: grey_600,
      ),
      searchIcon: const Icon(Icons.search),
      decoration: BoxDecoration(
          color: grey_100, border: Border.all(color: grey_100)),
      items: items,
      listType: MultiSelectListType.CHIP,
      onConfirm: (values) {
        onConfirm(values.cast<String?>());
      },
      chipDisplay: MultiSelectChipDisplay(
        chipColor: kPrimaryColor,
        textStyle: p14.copyWith(color: white),
        onTap: (value) {
          onChipTap(value as String?);
        },
        icon: const Icon(Icons.cancel, color: Colors.white),
        alignment: Alignment.topLeft,
      ),
    );
  }
}
