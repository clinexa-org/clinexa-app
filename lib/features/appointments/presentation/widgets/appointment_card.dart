// features/appointments/presentation/widgets/appointment_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

enum AppointmentStatus { confirmed, pending, cancelled, completed }

class AppointmentCard extends StatelessWidget {
  final String date;
  final String time;
  final String dayOfWeek;
  final String doctorName;
  final String reason;
  final AppointmentStatus status;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReschedule;
  final bool showActions;

  const AppointmentCard({
    super.key,
    required this.date,
    required this.time,
    required this.dayOfWeek,
    required this.doctorName,
    required this.reason,
    required this.status,
    this.onViewDetails,
    this.onReschedule,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with date and status
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$date • $time',
                          style: AppTextStyles.interSemiBoldw600F16.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    _StatusBadge(status: status),
                  ],
                ),

                SizedBox(height: 20.h),

                // Doctor info
                _InfoRow(
                  icon: Iconsax.user,
                  label: doctorName,
                ),

                SizedBox(height: 12.h),

                // Reason
                _InfoRow(
                  icon: Iconsax.note_text,
                  label: reason,
                ),
              ],
            ),
          ),

          // Actions
          if (showActions) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: _buildActions(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (status == AppointmentStatus.pending) {
      return Row(
        children: [
          // Expanded(
          //   child: _ActionButton(
          //     label: 'btn_reschedule'.tr(context),
          //     onTap: onReschedule,
          //     isOutlined: true,
          //   ),
          // ),
          // Container(
          //   width: 1,
          //   height: 48.h,
          //   color: AppColors.border.withOpacity(0.5),
          // ),
          Expanded(
            child: _ActionButton(
              label: 'btn_view'.tr(context),
              onTap: onViewDetails,
              isOutlined: false,
            ),
          ),
        ],
      );
    }

    return _ActionButton(
      label: 'btn_view_details'.tr(context),
      onTap: onViewDetails,
      isOutlined: false,
      fullWidth: true,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case AppointmentStatus.confirmed:
        bgColor = AppColors.success.withOpacity(0.15);
        textColor = AppColors.success;
        label = 'status_confirmed'.tr(context);
        break;
      case AppointmentStatus.pending:
        bgColor = AppColors.accent.withOpacity(0.15);
        textColor = AppColors.accent;
        label = 'status_pending'.tr(context);
        break;
      case AppointmentStatus.cancelled:
        bgColor = AppColors.error.withOpacity(0.15);
        textColor = AppColors.error;
        label = 'status_cancelled'.tr(context);
        break;
      case AppointmentStatus.completed:
        bgColor = AppColors.textMuted.withOpacity(0.15);
        textColor = AppColors.textMuted;
        label = 'status_completed'.tr(context);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.interSemiBoldw600F12.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColors.textMuted,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.interMediumw500F14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isOutlined;
  final bool fullWidth;

  const _ActionButton({
    required this.label,
    this.onTap,
    this.isOutlined = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft:
                fullWidth || isOutlined ? Radius.circular(16.r) : Radius.zero,
            bottomRight:
                fullWidth || !isOutlined ? Radius.circular(16.r) : Radius.zero,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.interSemiBoldw600F14.copyWith(
            color: isOutlined ? AppColors.textMuted : AppColors.accent,
          ),
        ),
      ),
    );
  }
}
