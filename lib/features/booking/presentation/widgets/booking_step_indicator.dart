// features/booking/presentation/widgets/booking_step_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingStepIndicator extends StatelessWidget {
  final int currentStep;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  List<String> _getSteps(BuildContext context) => [
        'select_date'.tr(context).split(' ').last, // "Date"
        'select_time'.tr(context).split(' ').last, // "Time"
        'details'.tr(context),
        'confirmed'.tr(context),
      ];

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: GestureDetector(
              onTap: isCompleted ? () {} : null,
              child: Column(
                children: [
                  Text(
                    steps[index],
                    style: AppTextStyles.interMediumw500F12.copyWith(
                      color: isActive
                          ? AppColors.accent
                          : isCompleted
                              ? AppColors.accent.withOpacity(0.7)
                              : AppColors.textMuted,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: isActive || isCompleted
                          ? AppColors.accent
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
