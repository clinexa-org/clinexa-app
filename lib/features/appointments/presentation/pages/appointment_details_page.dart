// features/appointments/presentation/pages/appointment_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_dialog.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/toast_helper.dart';
import '../widgets/appointment_card.dart';
import '../widgets/reschedule_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsPage({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'appointment_details_title'.tr(context),
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            _buildStatusSection(context),

            SizedBox(height: 32.h),

            // Date & Time Section
            _buildInfoCard(
              title: 'label_date_time'.tr(context),
              icon: Iconsax.calendar,
              children: [
                _InfoItem(
                    label: 'label_date'.tr(context), value: appointment.date),
                _InfoItem(
                    label: 'label_day'.tr(context),
                    value: _dayOfWeek(appointment.date)),
                _InfoItem(
                    label: 'label_time'.tr(context), value: appointment.time),
              ],
            ),

            SizedBox(height: 20.h),

            // Doctor Section
            _buildInfoCard(
              title: 'label_doctor'.tr(context),
              icon: Iconsax.user,
              children: [
                _InfoItem(
                    label: 'label_name'.tr(context),
                    value: appointment.doctorName),
                _InfoItem(
                    label: 'label_specialty'.tr(context),
                    value: appointment.doctorSpecialty),
              ],
            ),

            SizedBox(height: 20.h),

            // Appointment Details Section
            _buildInfoCard(
              title: 'section_appointment_details'.tr(context),
              icon: Iconsax.note_text,
              children: [
                _InfoItem(
                    label: 'label_reason'.tr(context),
                    value: appointment.reason),
                _InfoItem(
                    label: 'label_type'.tr(context),
                    value: 'type_in_person'.tr(context)),
                _InfoItem(
                    label: 'label_duration'.tr(context),
                    value: 'duration_30_min'.tr(context)),
              ],
            ),

            SizedBox(height: 20.h),

            // Location Section
            _buildInfoCard(
              title: 'label_location'.tr(context),
              icon: Iconsax.location,
              children: [
                _InfoItem(
                    label: 'label_clinic'.tr(context),
                    value: appointment.clinicName),
                _InfoItem(
                    label: 'label_address'.tr(context),
                    value: appointment.clinicAddress),
              ],
            ),

            SizedBox(height: 32.h),

            // Action Buttons
            if (_mapStatus(appointment.status) == AppointmentStatus.pending ||
                _mapStatus(appointment.status) ==
                    AppointmentStatus.confirmed) ...[
              _buildActionButtons(context),
            ],
          ],
        ),
      ),
    );
  }

  String _dayOfWeek(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return days[date.weekday - 1];
    } catch (e) {
      return '';
    }
  }

  AppointmentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.pending;
    }
  }

  Widget _buildStatusSection(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    final status = _mapStatus(appointment.status);

    switch (status) {
      case AppointmentStatus.confirmed:
        bgColor = AppColors.success.withOpacity(0.15);
        textColor = AppColors.success;
        label = 'status_confirmed'.tr(context);
        icon = Iconsax.tick_circle;
        break;
      case AppointmentStatus.pending:
        bgColor = AppColors.accent.withOpacity(0.15);
        textColor = AppColors.accent;
        label = 'status_pending_confirmation'.tr(context);
        icon = Iconsax.clock;
        break;
      case AppointmentStatus.cancelled:
        bgColor = AppColors.error.withOpacity(0.15);
        textColor = AppColors.error;
        label = 'status_cancelled'.tr(context);
        icon = Iconsax.close_circle;
        break;
      case AppointmentStatus.completed:
        bgColor = AppColors.textMuted.withOpacity(0.15);
        textColor = AppColors.textMuted;
        label = 'status_completed'.tr(context);
        icon = Iconsax.tick_circle;
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTextStyles.interSemiBoldw600F16.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                title,
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Reschedule Button
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: OutlinedButton(
            onPressed: () {
              final cubit = context.read<AppointmentsCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => RescheduleBottomSheet(
                  appointmentId: appointment.id,
                  cubit: cubit,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.accent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.calendar_edit,
                    color: AppColors.accent, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'btn_reschedule'.tr(context),
                  style: AppTextStyles.interSemiBoldw600F16.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Cancel Button
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: TextButton(
            onPressed: () {
              _showCancelDialog(context);
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'btn_cancel_appointment'.tr(context),
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    AppDialog.confirm(
      context: context,
      title: 'dialog_cancel_appointment_title'.tr(context),
      message: 'dialog_cancel_appointment_msg'.tr(context),
      confirmText: 'btn_confirm_cancel'.tr(context),
      cancelText: 'btn_keep_it'.tr(context),
      isDanger: true,
      autoCloseOnConfirm: false,
      onConfirmAsync: () async {
        final cubit = context.read<AppointmentsCubit>();
        cubit.cancelAppointment(id: appointment.id);

        // Wait for result
        final state = await cubit.stream.firstWhere((state) =>
            state.status == AppointmentsStatus.success ||
            state.status == AppointmentsStatus.failure);

        if (!context.mounted) return;

        // Close dialog first
        Navigator.pop(context);

        if (state.status == AppointmentsStatus.success) {
          Navigator.pop(context); // Close details page
          ToastHelper.showSuccess(
            context: context,
            message: 'msg_appointment_cancelled'.tr(context),
          );
        } else if (state.status == AppointmentsStatus.failure) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'msg_cancel_error'.tr(context),
          );
        }
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
