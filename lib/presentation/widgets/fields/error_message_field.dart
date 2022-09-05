import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final AsyncSnapshot<Object?> snapshot;
  final double fontSize;
  final double height;

  const ErrorMessage({
    required this.snapshot,
    this.fontSize = 10,
    this.height = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return snapshot.hasError
        ? SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                      fontSize: fontSize,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFFF0000),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ))
        : const SizedBox(
            height: 16,
          );
  }
}
