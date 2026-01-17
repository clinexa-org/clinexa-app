// features/booking/presentation/widgets/booking_details_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingDetailsStep extends StatefulWidget {
  final String? selectedReason;
  final String? notes;
  final ValueChanged<String> onReasonChanged;
  final ValueChanged<String> onNotesChanged;
  final VoidCallback onConfirm;
  final VoidCallback onBack;
  final String doctorName;
  final String clinicName;

  const BookingDetailsStep({
    super.key,
    this.selectedReason,
    this.notes,
    required this.onReasonChanged,
    required this.onNotesChanged,
    required this.onConfirm,
    required this.onBack,
    this.doctorName = 'Dr. Ahmed Hassan',
    this.clinicName = 'Clinexa Clinic',
  });

  @override
  State<BookingDetailsStep> createState() => _BookingDetailsStepState();
}

class _BookingDetailsStepState extends State<BookingDetailsStep> {
  String _selectedReason = 'reason_general';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _reasons = [
    'reason_general',
    'reason_followup',
    'reason_refill',
    'reason_lab',
    'reason_other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedReason != null) {
      _selectedReason = widget.selectedReason!;
    }
    if (widget.notes != null) {
      _notesController.text = widget.notes!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
                // Reason dropdown
                _buildReasonSection(),
                SizedBox(height: 24.h),
                // Notes field
                _buildNotesSection(),
                SizedBox(height: 24.h),
                // Booking info
                _buildBookingInfo(),
              ],
            ),
          ),
        ),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'label_reason_for_visit'.tr(context),
          style: AppTextStyles.interSemiBoldw600F14.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedReason,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              icon: Icon(Iconsax.arrow_down_1,
                  color: AppColors.textMuted, size: 20.sp),
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textPrimary,
              ),
              items: _reasons.map((reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason.tr(context)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedReason = value;
                  });
                  widget.onReasonChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'label_notes_optional'.tr(context),
          style: AppTextStyles.interSemiBoldw600F14.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            style: AppTextStyles.interMediumw500F14.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'hint_notes'.tr(context),
              hintStyle: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
            onChanged: widget.onNotesChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.info_circle,
              color: AppColors.textMuted,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'label_booking_info'.tr(context),
                  style: AppTextStyles.interSemiBoldw600F14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'msg_booking_assignment'.tr(context, params: {
                    'doctorName': widget.doctorName,
                    'clinicName': widget.clinicName
                  }),
                  style: AppTextStyles.interMediumw500F12.copyWith(
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
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
          // Confirm button
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: 'btn_confirm_appointment'.tr(context),
              onPressed: widget.onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
