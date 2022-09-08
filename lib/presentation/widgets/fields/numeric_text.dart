import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumericText extends StatelessWidget {
  final String? format;
  final String text;
  const NumericText({
    this.format = "#,###.00",
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedText = NumberFormat(format).format(double.parse(text));
    return Text(formattedText);
  }
}
