import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/utils/date_extensions.dart';

class RescheduleBottomSheet extends StatefulWidget {
  final String appointmentId;
  final AppointmentsCubit cubit;

  const RescheduleBottomSheet({
    super.key,
    required this.appointmentId,
    required this.cubit,
  });

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  int _currentStep = 0; // 0: Date, 1: Time
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      bloc: widget.cubit,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AppointmentsStatus.success) {
          ToastHelper.showSuccess(
            context: context,
            message: 'msg_reschedule_success'.tr(context),
          );
          // Pop the bottom sheet
          Navigator.pop(context);
          // Pop the details page
          Navigator.pop(context);
          // Refresh list
          widget.cubit.getMyAppointments();
        } else if (state.status == AppointmentsStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'msg_reschedule_error'.tr(context),
          );
        }
      },
      child: Container(
        height: 0.85.sh,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _currentStep == 0 ? _buildDateStep() : _buildTimeStep(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'btn_reschedule'.tr(context),
                style: AppTextStyles.interBoldw700F18.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _currentStep == 0
                    ? 'select_date'.tr(context)
                    : 'select_time'.tr(context),
                style: AppTextStyles.interMediumw500F14.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Iconsax.close_circle, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStep() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: Icon(Iconsax.arrow_left_2,
                        color: AppColors.textMuted, size: 20.sp),
                  ),
                  Text(
                    _getMonthYearString(_currentMonth),
                    style: AppTextStyles.interSemiBoldw600F16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: Icon(Iconsax.arrow_right_3,
                        color: AppColors.textMuted, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildWeekdayHeaders(),
              SizedBox(height: 8.h),
              _buildCalendarGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeStep() {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      bloc: widget.cubit,
      builder: (context, state) {
        if (state.slotsStatus == SlotsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.slotsStatus == SlotsStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Error loading slots'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (morningSlots.isNotEmpty)
              _buildTimeSection('time_morning'.tr(context), morningSlots),
            SizedBox(height: 24.h),
            if (afternoonSlots.isNotEmpty)
              _buildTimeSection('time_afternoon'.tr(context), afternoonSlots),
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
                      style: AppTextStyles.interMediumw500F16.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    final time = TimeOfDay.fromDateTime(slot.time.toCairoTime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = "$hour:$minute $period";

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

  Widget _buildWeekdayHeaders() {
    final weekdays = [
      'day_sun',
      'day_mon',
      'day_tue',
      'day_wed',
      'day_thu',
      'day_fri',
      'day_sat'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 36.w,
          child: Text(
            day.tr(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.interMediumw500F12.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    List<Widget> rows = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < firstWeekday; i++) {
      currentRow.add(SizedBox(width: 36.w, height: 36.w));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday = date.isAtSameMomentAs(todayDate);
      final isSelected = _selectedDate != null &&
          date.year == _selectedDate!.year &&
          date.month == _selectedDate!.month &&
          date.day == _selectedDate!.day;
      final isPast = date.isBefore(todayDate);

      currentRow.add(
          _buildDayCell(day, isSelected, isToday, isPast: isPast, date: date));

      if (currentRow.length == 7) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: currentRow));
        currentRow = [];
      }
    }

    while (currentRow.length < 7 && currentRow.isNotEmpty) {
      currentRow.add(SizedBox(width: 36.w, height: 36.w));
    }
    if (currentRow.isNotEmpty) {
      rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: currentRow));
    }

    return Column(
      children: rows
          .map((row) =>
              Padding(padding: EdgeInsets.symmetric(vertical: 4.h), child: row))
          .toList(),
    );
  }

  Widget _buildDayCell(int day, bool isSelected, bool isToday,
      {bool isPast = false, DateTime? date}) {
    return GestureDetector(
      onTap: isPast
          ? null
          : () {
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          day.toString(),
          style: AppTextStyles.interMediumw500F14.copyWith(
            color: isPast
                ? AppColors.textMuted.withOpacity(0.4)
                : isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.accent
                        : AppColors.textPrimary,
            fontWeight:
                isSelected || isToday ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      bloc: widget.cubit,
      builder: (context, state) {
        final isLoading = state.status == AppointmentsStatus.loading;
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              if (_currentStep == 1) ...[
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                _currentStep = 0;
                              });
                            },
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
              ],
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: _currentStep == 0
                      ? 'btn_continue'.tr(context)
                      : 'btn_confirm_reschedule'.tr(context),
                  isLoading: isLoading,
                  onPressed: () {
                    if (_currentStep == 0) {
                      if (_selectedDate != null) {
                        final dateStr =
                            "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                        widget.cubit.getSlots(date: dateStr);
                        setState(() {
                          _currentStep = 1;
                        });
                      }
                    } else {
                      _handleReschedule();
                    }
                  },
                  isDisabled: _currentStep == 0
                      ? _selectedDate == null
                      : _selectedTime == null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleReschedule() {
    if (_selectedDate == null || _selectedTime == null) return;

    final dateStr =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    final timeStr = _formatTimeTo24H(_selectedTime!);

    widget.cubit.rescheduleAppointment(
      id: widget.appointmentId,
      date: dateStr,
      time: timeStr,
    );
  }

  String _formatTimeTo24H(String timeStr) {
    // Input format: "09:30 AM" or "02:30 PM"
    final parts = timeStr.split(' ');
    if (parts.length != 2) return timeStr;

    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) return timeStr;

    int hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    final isPM = parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    return "${hour.toString().padLeft(2, '0')}:$minute";
  }

  void _showSuccessDialog() {
    // You can implement a success dialog call here if needed
    // or return a result to the parent
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String _getMonthYearString(DateTime date) {
    return '${_getMonthName(date.month).tr(context)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'month_january',
      'month_february',
      'month_march',
      'month_april',
      'month_may',
      'month_june',
      'month_july',
      'month_august',
      'month_september',
      'month_october',
      'month_november',
      'month_december'
    ];
    return months[month - 1];
  }
}
