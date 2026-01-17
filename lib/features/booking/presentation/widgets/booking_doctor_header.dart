// features/booking/presentation/widgets/booking_doctor_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingDoctorHeader extends StatelessWidget {
  final String doctorName;
  final String clinicName;
  final String specialty;

  const BookingDoctorHeader({
    super.key,
    this.doctorName = 'Dr. Ahmed Hassan',
    this.clinicName = 'Clinexa Clinic',
    this.specialty = 'General Medicine',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Doctor avatar
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent,
                  AppColors.accentLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.user,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'header_booking_with'
                      .tr(context, params: {'name': doctorName}),
                  style: AppTextStyles.interSemiBoldw600F14.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$clinicName • $specialty',
                  style: AppTextStyles.interMediumw500F12.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
