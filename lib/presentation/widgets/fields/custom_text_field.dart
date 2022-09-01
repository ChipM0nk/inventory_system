import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    required this.context,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
    this.initialValue,
    this.obscureText = false,
    this.autofocus = false,
    this.readonly = false,
    this.onChanged,
  });

  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final BuildContext context;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  Function? onTap;
  Function? onEditingComplete;
  TextInputAction? textInputAction;
  String? initialValue;
  bool obscureText;
  bool autofocus;
  bool readonly;

  String Function(String text)? onChanged;

  final TextStyle labelTextStyle = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  TextStyle getHintTextStyle(context, hint) {
    return TextStyle(
        fontSize: 18,
        color: hint ? Colors.grey.shade400 : Colors.black,
        fontWeight: FontWeight.w900);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: labelTextStyle,
          ),
          const SizedBox(
            height: 19,
          ),
          TextFormField(
            autofocus: autofocus,
            onEditingComplete: () => onEditingComplete,
            textInputAction: textInputAction,
            onTap: () => onTap,
            obscureText: obscureText,
            onChanged: onChanged,
            maxLength: 20,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            cursorColor: Colors.black,
            readOnly: readonly,
            initialValue: initialValue,
            style: getHintTextStyle(context, false),
            decoration: InputDecoration(
                errorStyle: const TextStyle(fontStyle: FontStyle.italic),
                isDense: true,
                counterText: "",
                contentPadding: const EdgeInsets.only(bottom: 8),
                hintStyle: getHintTextStyle(context, true),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                hintText: hintText),
          ),
        ],
      ),
    );
  }
}
