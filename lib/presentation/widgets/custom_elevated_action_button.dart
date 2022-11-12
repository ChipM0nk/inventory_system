import 'package:flutter/material.dart';

class CustomElevatedActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final Text text;
  final Icon icon;
  final Color? color;
  const CustomElevatedActionButton(
      {super.key,
      this.onPressed,
      required this.text,
      required this.icon,
      this.color,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(16.0),
        backgroundColor: color ?? const Color(0xFF08B578),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      icon: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : icon,
      label: text,
    );
  }
}
