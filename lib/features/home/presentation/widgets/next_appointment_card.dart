import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/widgets/shimmer_loading.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.status == AppointmentsStatus.loading) {
          return _buildShimmer(context);
        }

        if (state.status == AppointmentsStatus.failure) {
          return const SizedBox.shrink();
        }

        final upcoming = state.appointments
            .where(
                (apt) => apt.status == 'pending' || apt.status == 'confirmed')
            .toList();

        if (upcoming.isEmpty) {
          return const SizedBox.shrink();
        }

        final appointment = upcoming.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'next_appointment'.tr(context),
              style: AppTextStyles.interSemiBoldw600F16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D21),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Iconsax.health,
                          color: AppColors.textPrimary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appointment.doctorName,
                                  style: AppTextStyles.interBoldw700F16
                                      .copyWith(color: Colors.white),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appointment.status == 'confirmed'
                                        ? const Color(0xFF1E7B48)
                                        : AppColors.warning.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'status_${appointment.status}'.tr(context),
                                    style: AppTextStyles.interBoldw700F10
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              appointment.doctorSpecialty,
                              style: AppTextStyles.interRegularw400F14.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${appointment.date} • ${appointment.time}',
                          style: AppTextStyles.interSemiBoldw600F12
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        Routes.appointmentDetailsName,
                        extra: appointment,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'view_details'.tr(context),
                          style: AppTextStyles.interSemiBoldw600F14.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Iconsax.arrow_right_3,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoading(width: 150.w, height: 20.h),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D21),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(
                    width: 44.w,
                    height: 44.h,
                    borderRadius: 12.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerLoading(width: 120.w, height: 20.h),
                            ShimmerLoading(width: 60.w, height: 20.h),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        ShimmerLoading(width: 100.w, height: 16.h),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ShimmerLoading(
                width: double.infinity,
                height: 44.h,
                borderRadius: 12.r,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  ShimmerLoading(width: 100.w, height: 18.h),
                  SizedBox(width: 4.w),
                  ShimmerLoading(width: 14.w, height: 14.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
