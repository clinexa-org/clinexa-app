// core/utils/toast_helper.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class ToastHelper {
  ToastHelper._();

  /// Show toast notification
  static void show({
    required BuildContext context,
    required String message,
    required ToastificationType type,
    String? title,
    Duration? duration,
    bool showIcon = true,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case ToastificationType.success:
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        icon = Iconsax.tick_circle;
        break;
      case ToastificationType.error:
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        icon = Iconsax.close_circle;
        break;
      case ToastificationType.warning:
        backgroundColor = AppColors.warning;
        textColor = Colors.white;
        icon = Iconsax.warning_2;
        break;
      case ToastificationType.info:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        icon = Iconsax.info_circle;
        break;
    }

    toastification.dismissAll();
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      title: title != null
          ? Text(
              title,
              style: AppTextStyles.interSemiBoldw600F14.copyWith(
                color: textColor,
              ),
            )
          : null,
      description: Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.interRegularw400F14.copyWith(
          color: textColor,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: duration ?? const Duration(seconds: 5),
      backgroundColor: backgroundColor,
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: false,
      showIcon: showIcon,
      icon: Icon(
        icon,
        color: textColor,
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  /// Convenience method for success toast
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) =>
      show(
        context: context,
        type: ToastificationType.success,
        message: message,
        title: title,
        duration: duration,
      );

  /// Convenience method for error toast
  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) =>
      show(
        context: context,
        type: ToastificationType.error,
        message: message,
        title: title,
        duration: duration,
      );

  /// Convenience method for warning toast
  static void showWarning({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) =>
      show(
        context: context,
        type: ToastificationType.warning,
        message: message,
        title: title,
        duration: duration,
      );

  /// Convenience method for info toast
  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) =>
      show(
        context: context,
        type: ToastificationType.info,
        message: message,
        title: title,
        duration: duration,
      );
}
