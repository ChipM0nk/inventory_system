// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnChanged = void Function(String value);

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    this.validator,
    required this.labelText,
    this.onChanged,
    this.fontSize = 14,
    this.initialValue,
    this.width = 200,
    this.height = 30,
    required this.dateFormat,
  });

  final FormFieldValidator? validator; //TODO Remove later
  final String labelText;

  OnChanged? onChanged;
  final double fontSize;
  final String? initialValue;
  final double? width;
  final double? height;
  final String dateFormat;

  TextStyle getHintTextStyle(context, hint) {
    return TextStyle(
        fontSize: fontSize,
        color: hint ? Colors.grey.shade400 : Colors.black,
        fontWeight: FontWeight.w900);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    late DateTime selectedDate;
    if (initialValue != null) {
      controller.text = initialValue!;
      selectedDate = DateFormat(dateFormat).parse(initialValue!);
    } else {
      selectedDate = DateTime.now();
      String formattedDate = DateFormat(dateFormat).format(selectedDate);
      controller.text = formattedDate;
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        String formattedDate = DateFormat(dateFormat).format(picked);
        controller.text = formattedDate;
        onChanged!(formattedDate);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height,
                width: width,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: labelText,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle: getHintTextStyle(context, true),
                  ),
                  controller: controller,
                  style: getHintTextStyle(context, false),
                  enabled: false,
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
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
