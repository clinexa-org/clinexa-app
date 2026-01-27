// features/booking/presentation/widgets/booking_time_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import '../../../../core/utils/date_extensions.dart';

class BookingTimeStep extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const BookingTimeStep({
    super.key,
    required this.selectedDate,
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

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
    _fetchSlots();
  }

  @override
  void didUpdateWidget(covariant BookingTimeStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _fetchSlots();
    }
  }

  void _fetchSlots() {
    if (widget.selectedDate != null) {
      final dateStr =
          "${widget.selectedDate!.year}-${widget.selectedDate!.month.toString().padLeft(2, '0')}-${widget.selectedDate!.day.toString().padLeft(2, '0')}";
      context.read<AppointmentsCubit>().getSlots(date: dateStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.slotsStatus == SlotsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.slotsStatus == SlotsStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Error loading slots'),
                TextButton(
                  onPressed: _fetchSlots,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        final morningSlots = state.slots.where((slot) {
          final hour = slot.time.toCairoTime.hour;
          return hour < 12;
        }).toList();

        final afternoonSlots = state.slots.where((slot) {
          final hour = slot.time.toCairoTime.hour;
          return hour >= 12;
        }).toList();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    if (morningSlots.isNotEmpty)
                      _buildTimeSection(
                          'time_morning'.tr(context), morningSlots),
                    SizedBox(height: 24.h),
                    if (afternoonSlots.isNotEmpty)
                      _buildTimeSection(
                          'time_afternoon'.tr(context), afternoonSlots),
                    if (morningSlots.isEmpty && afternoonSlots.isEmpty)
                      if (morningSlots.isEmpty && afternoonSlots.isEmpty) ...[
                        SizedBox(height: 60.h),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 48.r,
                                color: AppColors.textMuted.withOpacity(0.5),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "clinic_closed".tr(context),
                                style:
                                    AppTextStyles.interMediumw500F16.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
            _buildButtons(),
          ],
        );
      },
    );
  }

  Widget _buildTimeSection(String title, List<dynamic> slots) {
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
          children: slots.map((slot) => _buildTimeSlot(slot)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(dynamic slot) {
    // Extract time string for display and comparison
    // Assuming slot.time is DateTime. We need to format it or use a separate formatter.
    // Since the original code used strings like "09:00 AM", we should probably format the DateTime.
    // But wait, the API returns full ISO string.
    // The previous implementation used exact string match.
    // I shall format the time to "hh:mm a" for display and usage as value?
    // The request says: "Expect List<Map<String, dynamic>>" and use `slot.status`.

    // Actually the parent expects a String for `onTimeSelected`.
    // I should convert the DateTime to String format that the backend expects for creation?
    // The backend `createAppointment` takes `time` as String.
    // `booking_flow_page.dart` formats it: `_formatTimeTo24H`.
    // If I return "09:00 AM", `booking_flow_page` handles it.
    // So I should format `slot.time` to "hh:mm a" (12-hour format).

    final time = TimeOfDay.fromDateTime(slot.time.toCairoTime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = "$hour:$minute $period"; // e.g. "09:00 AM"

    final isSelected = _selectedTime == timeStr;
    final isBooked = slot.isBooked;

    return AbsorbPointer(
      absorbing: isBooked,
      child: GestureDetector(
        onTap: isBooked
            ? null
            : () {
                setState(() {
                  _selectedTime = timeStr;
                });
                widget.onTimeSelected(timeStr);
              },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isBooked
                ? Colors.grey.shade300
                : isSelected
                    ? AppColors.accent
                    : AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isBooked
                  ? Colors.transparent
                  : isSelected
                      ? AppColors.accent
                      : AppColors.border,
            ),
          ),
          child: Text(
            timeStr,
            style: AppTextStyles.interMediumw500F14.copyWith(
              color: isBooked
                  ? AppColors.textMuted
                  : isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
              decoration: isBooked ? TextDecoration.lineThrough : null,
            ),
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
