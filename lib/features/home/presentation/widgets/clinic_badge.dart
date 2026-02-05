import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';

import '../../../../app/widgets/shimmer_loading.dart';

class ClinicBadge extends StatelessWidget {
  const ClinicBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.status == AppointmentsStatus.loading) {
          return ShimmerLoading(
            width: 150.w,
            height: 32.h,
            borderRadius: 8.r,
          );
        }

        String badgeText = 'clinic_name_full'.tr(context);

        if (state.status == AppointmentsStatus.success) {
          final upcoming = state.appointments
              .where(
                  (apt) => apt.status == 'pending' || apt.status == 'confirmed')
              .toList();

          if (upcoming.isNotEmpty) {
            // Sort by date/time if needed, but assuming list order or API order for now.
            // Usually API returns sorted. If not, we take the first one found.
            final apt = upcoming.first;
            badgeText = '${apt.clinicName} • ${apt.doctorName}';
          }
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.hospital, size: 16.sp, color: AppColors.textMuted),
              SizedBox(width: 8.w),
              Text(
                badgeText,
                style: AppTextStyles.interSemiBoldw600F12.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
