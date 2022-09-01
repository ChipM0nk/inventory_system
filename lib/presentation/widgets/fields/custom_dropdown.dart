import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomDropdown<T> extends StatelessWidget {
  CustomDropdown({
    super.key,
    required this.labelText,
    this.controller,
    required this.context,
    this.autofocus = false,
    this.onChanged,
    this.value,
    required this.items,
  });

  final String labelText;
  final TextEditingController? controller;
  final BuildContext context;
  Function? onTap;
  bool autofocus;
  T? value;
  final List<DropdownMenuItem<T>> items;

  void Function<T>(T? obj)? onChanged;

  final TextStyle labelTextStyle = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: labelTextStyle,
            ),
            DropdownButton<T>(
              isExpanded: true,
              value: value,
              autofocus: autofocus,
              onTap: () => onTap,
              onChanged: onChanged,
              items: items,
            ),
          ],
        ),
      ),
    );
  }
}
