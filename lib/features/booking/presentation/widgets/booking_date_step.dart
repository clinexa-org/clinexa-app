// features/booking/presentation/widgets/booking_date_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

class BookingDateStep extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onContinue;

  const BookingDateStep({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    required this.onContinue,
  });

  @override
  State<BookingDateStep> createState() => _BookingDateStepState();
}

class _BookingDateStepState extends State<BookingDateStep> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentMonth = widget.selectedDate ?? DateTime.now();
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
                _buildCalendar(),
              ],
            ),
          ),
        ),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          // Month Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: Icon(
                  Iconsax.arrow_left_2,
                  color: AppColors.textMuted,
                  size: 20.sp,
                ),
              ),
              Text(
                _getMonthYearString(_currentMonth),
                style: AppTextStyles.interSemiBoldw600F16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.textMuted,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Weekday Headers
          _buildWeekdayHeaders(),
          SizedBox(height: 8.h),
          // Calendar Grid
          _buildCalendarGrid(),
        ],
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
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty cells for days before the start of the month
    for (int i = 0; i < firstWeekday; i++) {
      currentRow.add(_buildDayCell(null, false, false));
    }

    // Add day cells
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
          children: currentRow,
        ));
        currentRow = [];
      }
    }

    // Fill remaining cells
    while (currentRow.length < 7 && currentRow.isNotEmpty) {
      currentRow.add(_buildDayCell(null, false, false));
    }
    if (currentRow.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: currentRow,
      ));
    }

    return Column(
      children: rows
          .map((row) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: row,
              ))
          .toList(),
    );
  }

  Widget _buildDayCell(int? day, bool isSelected, bool isToday,
      {bool isPast = false, DateTime? date}) {
    if (day == null) {
      return SizedBox(width: 36.w, height: 36.w);
    }

    return GestureDetector(
      onTap: isPast
          ? null
          : () {
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
                widget.onDateSelected(date);
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

  Widget _buildContinueButton() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: PrimaryButton(
        text: 'btn_continue'.tr(context),
        onPressed: _selectedDate != null ? widget.onContinue : null,
        isDisabled: _selectedDate == null,
      ),
    );
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
