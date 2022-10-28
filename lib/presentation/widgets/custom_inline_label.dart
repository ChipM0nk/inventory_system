import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomInlineLabel extends StatelessWidget {
  final String label;
  final String? value;
  final double width;
  const CustomInlineLabel(
      {super.key, required this.label, this.value, this.width = 300});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(label)),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                value ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
