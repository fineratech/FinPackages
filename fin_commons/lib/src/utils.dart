import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Utils {
  static void showErrorToast({
    required BuildContext context,
    required String message,
    String? title,
    bool showTitle = true,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: showTitle ? Text(title ?? "Something went wrong") : null,
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      dragToClose: true,
    );
  }

  static void showSuccessToast({
    required BuildContext context,
    required String message,
    String? title,
    bool showTitle = true,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: showTitle ? Text(title ?? "Success") : null,
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      dragToClose: true,
    );
  }
}
