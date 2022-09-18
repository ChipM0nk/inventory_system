// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnChanged = void Function(String values);
typedef OnFieldSubmitted = void Function(String values);

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.validator,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
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
    this.snapshot,
    this.autofocus = false,
  });

  final FormFieldValidator? validator; //TODO Remove later
  final String labelText;
  final TextEditingController? controller;
  OnChanged? onChanged;
  OnFieldSubmitted? onFieldSubmitted;
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
  final AsyncSnapshot<Object?>? snapshot;
  final bool autofocus;

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
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
              focusNode: focusNode,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              style: getHintTextStyle(context, false, enabled),
              inputFormatters: inputFormatters,
              autofocus: autofocus,
            ),
          ),
          ErrorMessage(snapshot: snapshot)
        ],
      ),
    );
  }
}
