import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  final String userName;
  final String userId;
  final String? phoneNumber;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.userId,
    this.phoneNumber,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Edit Icon Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.edit_2,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'edit'.tr(context),
                        style: AppTextStyles.interRegularw400F12.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.surfaceElevated,
              backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? CachedNetworkImageProvider(imageUrl!) as ImageProvider
                  : null,
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? Icon(
                      Iconsax.user,
                      size: 40.sp,
                      color: AppColors.textSecondary,
                    )
                  : null,
            ),
            SizedBox(height: 12.h),
            Text(
              userName,
              style: AppTextStyles.interSemiBoldw600F18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(height: 4.h),
            SizedBox(height: 4.h),
            Text(
              '• ${'patient_id'.tr(context)}: #${userId.length >= 4 ? userId.substring(0, 4) : userId}',
              style: AppTextStyles.interRegularw400F12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '• ${'phone_number'.tr(context)}: ${phoneNumber ?? "+20 123 456 789"}',
              style: AppTextStyles.interRegularw400F12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
