// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

typedef OnChanged = void Function(String values);

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    this.validator,
    required this.labelText,
    this.onChanged,
    this.fontSize = 14,
    this.hintText,
    this.initialValue,
    this.textInputType,
    this.minLines = 1,
    this.width = 200,
    this.height = 30,
  });

  final FormFieldValidator? validator; //TODO Remove later
  final String labelText;

  OnChanged? onChanged;
  final double fontSize;
  final String? hintText;
  final String? initialValue;
  final TextInputType? textInputType;
  final int? minLines;
  final double? width;
  final double? height;

  TextStyle getHintTextStyle(context, hint) {
    return TextStyle(
        fontSize: fontSize,
        color: hint ? Colors.grey.shade400 : Colors.black,
        fontWeight: FontWeight.w900);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        controller.text = picked.toIso8601String(); //TODO Change to date only
        onChanged!("test");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            width: width,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
                hintText: hintText,
                contentPadding: const EdgeInsets.all(10),
                hintStyle: getHintTextStyle(context, true),
              ),
              keyboardType: textInputType,
              initialValue: initialValue,
              validator: validator,
              minLines: minLines,
              maxLines: minLines ?? (minLines! + 1),
              controller: controller,
              onChanged: onChanged,
              style: getHintTextStyle(context, false),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => {selectDate(context)},
            icon: const Icon(
              Icons.calendar_month_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
