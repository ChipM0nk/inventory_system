import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final AsyncSnapshot<Object?>? snapshot;
  final String? message;
  final double fontSize;
  final double height;
  final double width;

  const ErrorMessage({
    this.snapshot,
    this.message,
    this.fontSize = 10,
    this.height = 16,
    this.width = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (snapshot != null && snapshot!.hasError)
        ? SizedBox(
            height: height,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  snapshot!.error.toString(),
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
            width: 200,
          );
  }
}
