import 'package:clinexa_mobile/core/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_dialog.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/booking_confirmation_step.dart';
import '../widgets/booking_date_step.dart';
import '../widgets/booking_details_step.dart';

import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_time_step.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';

class BookingFlowPage extends StatefulWidget {
  const BookingFlowPage({super.key});

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Booking data
  DateTime? _selectedDate;
  String? _selectedTime;
  String _selectedReason = 'reason_general';
  String _notes = '';

  List<String> _getStepTitles(BuildContext context) => [
        'select_date'.tr(context),
        'select_time'.tr(context),
        'details'.tr(context),
        'confirmed'.tr(context),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = _getStepTitles(context);

    // Bloc Listener for Appointments
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AppointmentsStatus.success) {
          if (_currentStep == 2) {
            // Dismiss loading if we are at the confirm step
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            ToastHelper.showSuccess(
              context: context,
              message: 'msg_appointment_created'.tr(context),
            );
            _goToNextStep();
          }
        } else if (state.status == AppointmentsStatus.failure) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // Dismiss loading dialog
          }
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'msg_appointment_error'.tr(context),
          );
        } else if (state.status == AppointmentsStatus.loading) {
          AppDialog.loading(context: context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          centerTitle: true,
          title: stepTitles[_currentStep],
          onBackPressed: _currentStep == 3
              ? null // Hide back button on confirmation step
              : _currentStep == 0
                  ? () => Navigator.pop(context)
                  : _goToPreviousStep,
        ),
        body: Column(
          children: [
            // Step Indicator (hide on confirmation)
            if (_currentStep < 3)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: BookingStepIndicator(currentStep: _currentStep),
              ),

            // Step Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 0: Date Selection
                  BookingDateStep(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() => _selectedDate = date);
                    },
                    onContinue: _goToNextStep,
                  ),

                  // Step 1: Time Selection
                  BookingTimeStep(
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) {
                      setState(() => _selectedTime = time);
                    },
                    onContinue: _goToNextStep,
                    onBack: _goToPreviousStep,
                  ),

                  // Step 2: Details
                  Builder(builder: (context) {
                    return BookingDetailsStep(
                      selectedReason: _selectedReason,
                      notes: _notes,
                      onReasonChanged: (reason) =>
                          setState(() => _selectedReason = reason),
                      onNotesChanged: (notes) => setState(() => _notes = notes),
                      onConfirm: () => _confirmBooking(context),
                      onBack: _goToPreviousStep,
                    );
                  }),

                  // Step 3: Confirmation
                  BookingConfirmationStep(
                    selectedDate: _selectedDate ?? DateTime.now(),
                    selectedTime: _selectedTime ?? '10:00 AM',
                    onBackToHome: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _confirmBooking(BuildContext context) {
    if (_selectedDate == null) {
      ToastHelper.showError(
        context: context,
        message: 'Error: No date selected',
      );
      return;
    }
    if (_selectedTime == null) {
      ToastHelper.showError(
        context: context,
        message: 'Error: No time selected',
      );
      return;
    }

    // Format date as YYYY-MM-DD
    final dateStr =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    // Format time as HH:mm
    final timeStr = _formatTimeTo24H(_selectedTime!);

    context.read<AppointmentsCubit>().createAppointment(
          date: dateStr,
          time: timeStr,
          reason:
              _selectedReason.tr(context), // Translate to human-readable string
          notes: _notes, // Pass captured notes
        );
  }

  String _formatTimeTo24H(String time) {
    try {
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      if (isPm && hour != 12)
        hour += 12;
      else if (!isPm && hour == 12) hour = 0;

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return time; // Fallback
    }
  }
}
