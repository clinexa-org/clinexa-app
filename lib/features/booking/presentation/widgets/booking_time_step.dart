// features/booking/presentation/widgets/booking_time_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingTimeStep extends StatefulWidget {
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const BookingTimeStep({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<BookingTimeStep> createState() => _BookingTimeStepState();
}

class _BookingTimeStepState extends State<BookingTimeStep> {
  String? _selectedTime;

  final List<String> _morningSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];

  final List<String> _afternoonSlots = [
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildTimeSection('time_morning'.tr(context), _morningSlots),
                SizedBox(height: 24.h),
                _buildTimeSection(
                    'time_afternoon'.tr(context), _afternoonSlots),
              ],
            ),
          ),
        ),
        _buildButtons(),
      ],
    );
  }

  Widget _buildTimeSection(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.interSemiBoldw600F14.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: slots.map((time) => _buildTimeSlot(time)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(String time) {
    final isSelected = _selectedTime == time;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
        });
        widget.onTimeSelected(time);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          time,
          style: AppTextStyles.interMediumw500F14.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          // Back button
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'btn_back'.tr(context),
                  style: AppTextStyles.interSemiBoldw600F16.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Continue button
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: 'btn_continue'.tr(context),
              onPressed: _selectedTime != null ? widget.onContinue : null,
              isDisabled: _selectedTime == null,
            ),
          ),
        ],
      ),
    );
  }
}
