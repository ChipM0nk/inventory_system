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
    this.height = 30.0,
    this.width = 200,
  });

  final String labelText;
  final TextEditingController? controller;
  final BuildContext context;
  Function? onTap;
  bool autofocus;
  T? value;
  final List<DropdownMenuItem<T>> items;
  final double height;
  final double width;

  void Function<T>(T? obj)? onChanged;

  final TextStyle labelTextStyle = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: labelText,
                    constraints:
                        BoxConstraints(maxHeight: height, minHeight: height),
                    contentPadding: const EdgeInsets.all(10),
                    border: const OutlineInputBorder(),
                  ),
                  child: DropdownButton<T>(
                    isDense: true,
                    isExpanded: true,
                    value: value,
                    autofocus: autofocus,
                    onTap: () => onTap,
                    onChanged: onChanged,
                    items: items,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
