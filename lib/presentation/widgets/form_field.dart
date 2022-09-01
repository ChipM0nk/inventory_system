// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

typedef OnChanged = void Function(String values);

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.validator,
      required this.fieldName,
      required this.controller,
      this.onChanged});

  final FormFieldValidator validator;
  final String fieldName;
  final TextEditingController controller;
  OnChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 200,
            child: TextFormField(
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: fieldName,
                border: OutlineInputBorder(),
              ),
              validator: validator,
              controller: controller,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
