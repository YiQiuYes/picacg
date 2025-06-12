import 'package:flutter/material.dart';

class ToastUtil {
  static void showErrorSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  static void showInfoSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  static void showSuccessSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Colors.white,
      backgroundColor: Colors.green,
    );
  }

  static void showSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
    Color? textColor,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
