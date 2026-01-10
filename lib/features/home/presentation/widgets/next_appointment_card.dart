import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Appointment',
          style: AppTextStyles.interSemiBoldw600F16.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D21), // Dark card bg
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Iconsax.health,
                      color: AppColors.textPrimary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dr. Ahmed Hassan',
                              style: AppTextStyles.interBoldw700F16
                                  .copyWith(color: Colors.white),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E7B48), // Green badge
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'CONFIRMED',
                                style: AppTextStyles.interBoldw700F10
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'General Practitioner',
                          style: AppTextStyles.interRegularw400F14.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      size: 16.sp,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Oct 24, 2023',
                      style: AppTextStyles.interSemiBoldw600F12
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(width: 24.w),
                    Icon(
                      Iconsax.clock,
                      size: 16.sp,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '10:30 AM',
                      style: AppTextStyles.interSemiBoldw600F12
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  // Navigate to details
                },
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: AppTextStyles.interSemiBoldw600F14.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
