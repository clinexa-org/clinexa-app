// features/appointments/presentation/pages/appointments_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_tab_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import '../../domain/entities/appointment_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../widgets/reschedule_bottom_sheet.dart';
import '../../../../app/widgets/shimmer_loading.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.status == AppointmentsStatus.loading) {
          return _buildShimmer();
        }

        if (state.status == AppointmentsStatus.failure) {
          // Handle new user no profile error as empty state
          if (state.errorMessage != null &&
              (state.errorMessage!.contains('Profile not found') ||
                  state.errorMessage!.contains('Patient profile not found'))) {
            return _buildEmptyState();
          }
          return Center(child: Text(state.errorMessage ?? 'Unknown error'));
        }

        final allAppointments = state.appointments;
        final upcoming = allAppointments
            .where(
                (apt) => apt.status == 'pending' || apt.status == 'confirmed')
            .toList();
        final past = allAppointments
            .where(
                (apt) => apt.status == 'completed' || apt.status == 'cancelled')
            .toList();

        final appointments = _selectedTabIndex == 0 ? upcoming : past;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Bar
              AppointmentTabBar(
                selectedIndex: _selectedTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),

              SizedBox(height: 24.h),

              // Appointments List
              Expanded(
                child: appointments.isEmpty
                    ? _buildEmptyState()
                    : _buildAppointmentsList(appointments),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsList(List<AppointmentEntity> appointments) {
    // Group appointments by month
    final groupedAppointments = <String, List<AppointmentEntity>>{};

    for (final apt in appointments) {
      final month = _getMonthFromDate(apt.date);
      groupedAppointments.putIfAbsent(month, () => []).add(apt);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: groupedAppointments.length,
      itemBuilder: (context, index) {
        final month = groupedAppointments.keys.elementAt(index);
        final monthAppointments = groupedAppointments[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                month,
                style: AppTextStyles.interSemiBoldw600F12.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Appointments in this month
            ...monthAppointments.map((apt) => AppointmentCard(
                  date: apt.date,
                  time: apt.time,
                  dayOfWeek: _dayOfWeek(apt.date),
                  doctorName: apt.doctorName,
                  reason: apt.reason,
                  status: _mapStatus(apt.status),
                  onViewDetails: () {
                    context.pushNamed(
                      Routes.appointmentDetailsName,
                      extra: apt,
                    );
                  },
                  // onReschedule: () {
                  //   final cubit = context.read<AppointmentsCubit>();
                  //   showModalBottomSheet(
                  //     context: context,
                  //     isScrollControlled: true,
                  //     backgroundColor: Colors.transparent,
                  //     builder: (context) => RescheduleBottomSheet(
                  //       appointmentId: apt.id,
                  //       cubit: cubit,
                  //     ),
                  //   );
                  // },
                )),

            SizedBox(height: 8.h),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64.sp,
            color: AppColors.textMuted.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            _selectedTabIndex == 0
                ? 'empty_upcoming_title'.tr(context)
                : 'empty_past_title'.tr(context),
            style: AppTextStyles.interMediumw500F16.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _selectedTabIndex == 0
                ? 'empty_upcoming_msg'.tr(context)
                : 'empty_past_msg'.tr(context),
            style: AppTextStyles.interMediumw500F14.copyWith(
              color: AppColors.textMuted.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMonthFromDate(String dateStr) {
    // Basic date parsing logic for demo
    // Assuming format YYYY-MM-DD
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (date.month == now.month && date.year == now.year) {
        return 'header_this_month'.tr(context);
      }
      return "${date.month}/${date.year}";
    } catch (e) {
      return 'header_this_month'.tr(context);
    }
  }

  String _dayOfWeek(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      // Simple day of week mapping
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

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(width: 100.w, height: 16.h),
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              height: 160.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLoading(width: 120.w, height: 18.h),
                            SizedBox(height: 8.h),
                            ShimmerLoading(width: 150.w, height: 14.h),
                          ],
                        ),
                        ShimmerLoading(
                            width: 80.w, height: 28.h, borderRadius: 20.r),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        ShimmerLoading(
                            width: 18.w, height: 18.h, shape: BoxShape.circle),
                        SizedBox(width: 10.w),
                        ShimmerLoading(width: 140.w, height: 16.h),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        ShimmerLoading(
                            width: 18.w, height: 18.h, shape: BoxShape.circle),
                        SizedBox(width: 10.w),
                        ShimmerLoading(width: 180.w, height: 16.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
