import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class RecentPrescriptionsList extends StatelessWidget {
  const RecentPrescriptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Prescriptions',
              style: AppTextStyles.interSemiBoldw600F16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.surface.withOpacity(0.5),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: Color(0xFF00ACC1), // Cyan/Teal
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.link_1,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            title: Text(
              'Amoxicillin 500mg',
              style: AppTextStyles.interSemiBoldw600F16.copyWith(
                color: Colors.white,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                'Prescribed on Oct 10',
                style: AppTextStyles.interRegularw400F12.copyWith(
                  // Using 12 usually better for subtitles
                  color: AppColors.textMuted,
                ),
              ),
            ),
            trailing: Icon(
              Iconsax.arrow_right_3,
              size: 16.sp,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
