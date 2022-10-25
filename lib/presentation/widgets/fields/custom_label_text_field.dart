// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnChanged = void Function(String values);

class CustomLabelTextField extends StatelessWidget {
  CustomLabelTextField({
    this.controller,
    this.fontSize = 14,
    this.textInputType,
    this.width = 200,
    this.height = 30,
    this.enabled = true,
    this.inputFormatters,
    this.initialValue,
  });

  final TextEditingController? controller;
  OnChanged? onChanged;
  final double fontSize;
  final TextInputType? textInputType;
  final double? width;
  final double? height;
  final bool enabled;
  final String? initialValue;

  final List<TextInputFormatter>? inputFormatters;

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
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.end,
              enabled: enabled,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              keyboardType: textInputType,
              controller: controller,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              initialValue: initialValue,
              style: getHintTextStyle(context, false, enabled),
            ),
          ),
        ],
      ),
    );
  }
}
