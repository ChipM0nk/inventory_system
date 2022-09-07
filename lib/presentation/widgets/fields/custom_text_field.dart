// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:edar_app/constants/text_field_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnChanged = void Function(String values);

class CustomTextField extends StatelessWidget {
  CustomTextField({
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
    this.enabled = true,
    this.inputFormatters,
    this.focusNode,
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
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  TextStyle getHintTextStyle(context, hint, enabled) {
    return TextStyle(
        fontSize: fontSize,
        color: hint && enabled
            ? Colors.grey.shade400
            : !hint && !enabled
                ? Colors.blue
                : Colors.black,
        fontWeight: FontWeight.w900);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          enabled: enabled,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            hintText: hintText,
            contentPadding: const EdgeInsets.all(10),
            hintStyle: getHintTextStyle(context, true, enabled),
          ),
          keyboardType: textInputType,
          initialValue: initialValue,
          validator: validator,
          minLines: minLines,
          maxLines: minLines ?? (minLines! + 1),
          controller: controller,
          onChanged: onChanged,
          style: getHintTextStyle(context, false, enabled),
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}
