// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

typedef OnChanged = void Function(String values);

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    this.validator,
    required this.labelText,
    this.controller,
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
  final TextEditingController? controller;
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
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
        ],
      ),
    );
  }
}
