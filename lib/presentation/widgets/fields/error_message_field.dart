import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final AsyncSnapshot<Object?> snapshot;
  final double fontSize;

  const ErrorMessage({required this.snapshot, this.fontSize = 11, super.key});

  @override
  Widget build(BuildContext context) {
    return snapshot.hasError
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
                height: 16,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                )),
          )
        : const SizedBox(
            height: 10,
          );
  }
}
