import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:toastification/toastification.dart';

void successToast(BuildContext context, String title, String description) {
  toastification.show(
    context: context,
    title: Text(
      title,
      style: AppTextStyles.baseText,
    ),
    description: Text(description),
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    alignment: Alignment.topLeft,
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
  );
}

void failToast(BuildContext context, String title, String description) {
  toastification.show(
    context: context,
    title: Text(
      title,
      style: AppTextStyles.baseText,
    ),
    description: Text(description),
    type: ToastificationType.warning,
    style: ToastificationStyle.fillColored,
    alignment: Alignment.topLeft,
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
  );
}
