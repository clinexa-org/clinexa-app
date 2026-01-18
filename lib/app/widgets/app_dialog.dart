// app/widgets/app_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Dialog type determines styling and icon
enum AppDialogType {
  confirm,
  success,
  error,
  warning,
  info,
}

/// A custom dialog widget that follows the app's design system.
/// Use the static methods for easy access:
/// - AppDialog.show() - General purpose
/// - AppDialog.confirm() - Confirmation with cancel/confirm buttons
/// - AppDialog.success() - Success message
/// - AppDialog.error() - Error message
/// - AppDialog.warning() - Warning message
class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final AppDialogType type;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showIcon;
  final bool barrierDismissible;
  final IconData? customIcon;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.type = AppDialogType.info,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showIcon = true,
    this.barrierDismissible = true,
    this.customIcon,
  });

  // ============== Static Helper Methods ==============

  /// Show a general dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    AppDialogType type = AppDialogType.info,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showIcon = true,
    bool barrierDismissible = true,
    IconData? customIcon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        content: content,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showIcon: showIcon,
        barrierDismissible: barrierDismissible,
        customIcon: customIcon,
      ),
    );
  }

  /// Show a confirmation dialog with confirm/cancel buttons
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      content: content,
      type: isDanger ? AppDialogType.warning : AppDialogType.confirm,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      showIcon: true,
      barrierDismissible: false,
    );
  }

  /// Show a success dialog
  static Future<bool?> success({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: AppDialogType.success,
      confirmText: confirmText,
      onConfirm: onConfirm,
      showIcon: true,
    );
  }

  /// Show an error dialog
  static Future<bool?> error({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: AppDialogType.error,
      confirmText: confirmText,
      onConfirm: onConfirm,
      showIcon: true,
    );
  }

  /// Show a warning dialog
  static Future<bool?> warning({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: AppDialogType.warning,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      showIcon: true,
    );
  }

  /// Show an info dialog
  static Future<bool?> info({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: AppDialogType.info,
      confirmText: confirmText,
      onConfirm: onConfirm,
      showIcon: true,
    );
  }

  // ============== Build Methods ==============

  Color get _typeColor {
    switch (type) {
      case AppDialogType.confirm:
        return AppColors.primary;
      case AppDialogType.success:
        return AppColors.success;
      case AppDialogType.error:
        return AppColors.error;
      case AppDialogType.warning:
        return AppColors.warning;
      case AppDialogType.info:
        return AppColors.accent;
    }
  }

  Color get _iconBackgroundColor {
    switch (type) {
      case AppDialogType.confirm:
        return AppColors.primary.withOpacity(0.15);
      case AppDialogType.success:
        return AppColors.success.withOpacity(0.15);
      case AppDialogType.error:
        return AppColors.error.withOpacity(0.15);
      case AppDialogType.warning:
        return AppColors.warning.withOpacity(0.15);
      case AppDialogType.info:
        return AppColors.accent.withOpacity(0.15);
    }
  }

  IconData get _typeIcon {
    if (customIcon != null) return customIcon!;
    switch (type) {
      case AppDialogType.confirm:
        return Iconsax.message_question;
      case AppDialogType.success:
        return Iconsax.tick_circle;
      case AppDialogType.error:
        return Iconsax.close_circle;
      case AppDialogType.warning:
        return Iconsax.warning_2;
      case AppDialogType.info:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Icon
            if (showIcon) ...[
              SizedBox(height: 24.h),
              _buildIcon(),
            ],

            // Title
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: Text(
                title,
                style: AppTextStyles.interSemiBoldw600F18.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Message or Custom Content
            if (message != null || content != null)
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                child: content ??
                    Text(
                      message!,
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
              ),

            // Action Buttons
            SizedBox(height: 24.h),
            _buildActions(context),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: _iconBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _typeIcon,
        size: 32.sp,
        color: _typeColor,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final hasCancel = cancelText != null;
    final hasConfirm = confirmText != null;

    if (!hasCancel && !hasConfirm) {
      // Default OK button
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: _buildConfirmButton(context, 'OK'),
      );
    }

    if (hasCancel && hasConfirm) {
      // Two buttons side by side
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: _buildCancelButton(context),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildConfirmButton(context, confirmText!),
            ),
          ],
        ),
      );
    }

    // Single button
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: hasConfirm
          ? _buildConfirmButton(context, confirmText!)
          : _buildCancelButton(context),
    );
  }

  Widget _buildConfirmButton(BuildContext context, String text) {
    final isDestructive =
        type == AppDialogType.error || type == AppDialogType.warning;

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, true);
          onConfirm?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.interSemiBoldw600F14.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, false);
          onCancel?.call();
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.border),
          ),
        ),
        child: Text(
          cancelText ?? 'Cancel',
          style: AppTextStyles.interMediumw500F14.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
