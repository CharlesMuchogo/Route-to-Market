import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color? color,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white),
            if (icon != null) SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor:
            color ?? Theme.of(context).snackBarTheme.backgroundColor,
      ),
    );
  }
}
