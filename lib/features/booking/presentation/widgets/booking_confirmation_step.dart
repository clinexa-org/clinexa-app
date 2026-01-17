// features/booking/presentation/widgets/booking_confirmation_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingConfirmationStep extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final String doctorName;
  final String specialty;
  final String clinicName;
  final String clinicAddress;
  final VoidCallback onBackToHome;

  const BookingConfirmationStep({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    this.doctorName = 'Dr. Ahmed Hassan',
    this.specialty = 'General Medicine',
    this.clinicName = 'Clinexa Clinic',
    this.clinicAddress = 'Building 4, Medical District',
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                // Success checkmark
                _buildSuccessIcon(),
                SizedBox(height: 24.h),
                // Title
                Text(
                  'title_booking_confirmed'.tr(context),
                  style: AppTextStyles.interBoldw700F24.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'msg_booking_confirmed'.tr(context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.interMediumw500F14.copyWith(
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                // Appointment details card
                _buildDetailsCard(context),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        // Fixed bottom button
        Container(
          padding: EdgeInsets.all(24.w),
          child: _buildBackToHomeButton(context),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success,
            AppColors.success.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 40.sp,
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final dayOfWeek = _getDayOfWeek(context, selectedDate);
    final formattedDate = _formatDate(context, selectedDate);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date & Time
          _buildDetailRow(
            icon: Iconsax.calendar,
            iconColor: AppColors.accent,
            title: '$formattedDate • $selectedTime',
            subtitle: dayOfWeek,
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.border.withOpacity(0.5)),
          SizedBox(height: 16.h),
          // Doctor
          _buildDetailRow(
            icon: Iconsax.user,
            iconColor: AppColors.accent,
            title: doctorName,
            subtitle: specialty,
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.border.withOpacity(0.5)),
          SizedBox(height: 16.h),
          // Location
          _buildDetailRow(
            icon: Iconsax.location,
            iconColor: AppColors.accent,
            title: clinicName,
            subtitle: clinicAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.interMediumw500F12.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackToHomeButton(BuildContext context) {
    return PrimaryButton(
      text: 'btn_back_to_home'.tr(context),
      onPressed: onBackToHome,
    );
  }

  String _getDayOfWeek(BuildContext context, DateTime date) {
    final days = [
      'day_monday',
      'day_tuesday',
      'day_wednesday',
      'day_thursday',
      'day_friday',
      'day_saturday',
      'day_sunday'
    ];
    return days[date.weekday - 1].tr(context);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final months = [
      'month_short_jan',
      'month_short_feb',
      'month_short_mar',
      'month_short_apr',
      'month_short_may',
      'month_short_jun',
      'month_short_jul',
      'month_short_aug',
      'month_short_sep',
      'month_short_oct',
      'month_short_nov',
      'month_short_dec'
    ];
    return '${months[date.month - 1].tr(context)} ${date.day}, ${date.year}';
  }
}
