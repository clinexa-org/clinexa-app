import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../prescriptions/presentation/cubit/prescriptions_cubit.dart';
import '../../../prescriptions/presentation/cubit/prescriptions_state.dart';
import '../../../prescriptions/presentation/pages/prescription_details_page.dart';
import '../../../prescriptions/presentation/pages/prescriptions_page.dart';
import '../../../../app/widgets/shimmer_loading.dart';
import '../../../../app/widgets/empty_state_widget.dart';

class RecentPrescriptionsList extends StatelessWidget {
  const RecentPrescriptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'recent_prescriptions'.tr(context),
              style: AppTextStyles.interSemiBoldw600F16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrescriptionsPage(),
                  ),
                );
              },
              child: Text(
                'see_all'.tr(context),
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
          builder: (context, state) {
            if (state.status == PrescriptionsStatus.loading) {
              return _buildShimmer(context);
            }
            if (state.status == PrescriptionsStatus.failure) {
              // If profile is missing (new user), show empty state instead of error
              // If profile is missing (new user), show empty state instead of error
              if (state.errorMessage != null &&
                  (state.errorMessage!.contains('Profile not found') ||
                      state.errorMessage!
                          .contains('Patient profile not found'))) {
                return EmptyStateWidget(
                  title: 'empty_prescriptions_title'.tr(context),
                  message: 'empty_prescriptions_msg'.tr(context),
                  icon: Iconsax.document_text,
                );
              }
              return EmptyStateWidget(
                title: 'Error',
                message: state.errorMessage ?? 'Unknown',
                icon: Iconsax.warning_2,
                onRetry: () =>
                    context.read<PrescriptionsCubit>().getMyPrescriptions(),
              );
            }

            if (state.prescriptions.isEmpty) {
              return EmptyStateWidget(
                title: 'empty_prescriptions_title'.tr(context),
                message: 'empty_prescriptions_msg'.tr(context),
                icon: Iconsax.document_text,
              );
            }

            // Show only top 3
            final recent = state.prescriptions.take(3).toList();

            return Column(
              children: recent.map((prescription) {
                final medicineName = prescription.medicines.isNotEmpty
                    ? prescription.medicines.first.name
                    : 'Prescription';

                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.surface.withOpacity(0.5),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrescriptionDetailsPage(
                            prescriptionId: prescription.id,
                            date: prescription.date,
                            doctorName: prescription.doctorName,
                            medicines: prescription.medicines
                                .map((e) => {
                                      'name': e.name,
                                      'dosage': e.dosage,
                                      'type': e.type,
                                    })
                                .toList(),
                            notes: prescription.notes,
                          ),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.all(12.w),
                    leading: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00ACC1), // Cyan/Teal
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.link_1,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    title: Text(
                      medicineName,
                      style: AppTextStyles.interSemiBoldw600F16.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        'prescribed_on'
                            .tr(context, params: {'date': prescription.date}),
                        style: AppTextStyles.interRegularw400F12.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Iconsax.arrow_right_3,
                      size: 16.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.surface.withOpacity(0.5),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            leading: ShimmerLoading(
              width: 40.w,
              height: 40.h,
              shape: BoxShape.circle,
            ),
            title: ShimmerLoading(width: 150.w, height: 20.h),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: ShimmerLoading(width: 100.w, height: 16.h),
            ),
            trailing: ShimmerLoading(width: 20.w, height: 20.h),
          ),
        );
      }),
    );
  }
}
