// features/prescriptions/presentation/widgets/medicine_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class MedicineItem extends StatelessWidget {
  final String name;
  final String dosage;
  final String type;

  const MedicineItem({
    super.key,
    required this.name,
    required this.dosage,
    this.type = 'Tablet',
  });

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':
        return Iconsax.health;
      case 'capsule':
        return Iconsax.blend;
      case 'drops':
        return Iconsax.drop;
      case 'syrup':
        return Iconsax.glass;
      case 'injection':
        return Iconsax.add_circle;
      default:
        return Iconsax.health;
    }
  }

  String _getLocalizedType(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'tablet':
        return 'med_type_tablet'.tr(context);
      case 'capsule':
        return 'med_type_capsule'.tr(context);
      case 'drops':
        return 'med_type_drops'.tr(context);
      case 'syrup':
        return 'med_type_syrup'.tr(context);
      case 'injection':
        return 'med_type_injection'.tr(context);
      default:
        return type;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':
        return AppColors.accent;
      case 'capsule':
        return const Color(0xFF10B981); // Green
      case 'drops':
        return const Color(0xFFF59E0B); // Amber
      case 'syrup':
        return const Color(0xFFEC4899); // Pink
      case 'injection':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getColorForType(type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Medicine icon with gradient
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  typeColor.withOpacity(0.2),
                  typeColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: typeColor.withOpacity(0.2),
              ),
            ),
            child: Icon(
              _getIconForType(type),
              color: typeColor,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 14.w),

          // Medicine info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.interSemiBoldw600F14.copyWith(
                          color: AppColors.accent,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Type badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: typeColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        _getLocalizedType(context, type),
                        style: AppTextStyles.interMediumw500F10.copyWith(
                          color: typeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  dosage,
                  style: AppTextStyles.interMediumw500F12.copyWith(
                    color: AppColors.textMuted,
                    height: 1.3,
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
