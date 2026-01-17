// features/prescriptions/presentation/widgets/prescription_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class PrescriptionCard extends StatelessWidget {
  final String prescriptionId;
  final String date;
  final String doctorName;
  final int medicineCount;
  final VoidCallback? onTap;

  const PrescriptionCard({
    super.key,
    required this.prescriptionId,
    required this.date,
    required this.doctorName,
    this.medicineCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(16.w),
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
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Pill Icon with gradient background
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.2),
                    AppColors.accentLight.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Iconsax.receipt_2,
                color: AppColors.accent,
                size: 22.sp,
              ),
            ),

            SizedBox(width: 14.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prescription ID and medicine count
                  Row(
                    children: [
                      Text(
                        '#$prescriptionId',
                        style: AppTextStyles.interSemiBoldw600F16.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (medicineCount > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '$medicineCount ${'label_meds'.tr(context)}',
                            style: AppTextStyles.interMediumw500F10.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Date row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Iconsax.calendar,
                          size: 12.sp,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        date,
                        style: AppTextStyles.interMediumw500F12.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Doctor row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Iconsax.user,
                          size: 12.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          doctorName,
                          style: AppTextStyles.interMediumw500F12.copyWith(
                            color: AppColors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow with subtle background
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
