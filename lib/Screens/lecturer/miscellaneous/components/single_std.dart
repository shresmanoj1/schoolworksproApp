import 'package:flutter/material.dart';

import '../../../../components/misc_edit_text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/text_style.dart';

class SingleSTD extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? course;
  final String? batch;
  final TextEditingController presentController;
  final TextEditingController absentController;
  final List<String>? selectedVariable;
  final Map<String?, String?> studentDropdownValues;
  final List<String> grades;
  final Function(String?, String?) onDropdownChanged;

  const SingleSTD({
    Key? key,
    this.firstName,
    this.lastName,
    this.userName,
    this.course,
    this.batch,
    required this.presentController,
    required this.absentController,
    this.selectedVariable,
    required this.studentDropdownValues,
    required this.grades,
    required this.onDropdownChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$firstName $lastName"),
                    Text("$userName"),
                  ],
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$course"),
                    Text("$batch"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MiscEditTextField(
                      hintText: "Present Days",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: presentController,
                      hasBottomSpace: true,
                    ),
                    MiscEditTextField(
                      hintText: "Absent Days",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: absentController,
                      hasBottomSpace: true,
                    ),
                    if (selectedVariable != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var item in selectedVariable!)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<String>(
                                key: Key(userName.toString()),
                                decoration: InputDecoration(
                                  labelText: item,
                                  labelStyle: p13.copyWith(color: grey_600),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: grey_600),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: grey_600),
                                  ),
                                ),
                                value: studentDropdownValues[item],
                                onChanged: (newValue) {
                                  onDropdownChanged(item, newValue);
                                },
                                items: grades.map((grade) {
                                  return DropdownMenuItem(
                                    value: grade,
                                    child: Text(grade),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
