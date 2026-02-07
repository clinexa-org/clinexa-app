// features/prescriptions/presentation/pages/prescriptions_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../../prescriptions/presentation/cubit/prescriptions_cubit.dart';
import '../../../prescriptions/presentation/cubit/prescriptions_state.dart';
import '../widgets/prescription_card.dart';
import 'prescription_details_page.dart';
import '../../../../app/widgets/shimmer_loading.dart';
import '../../../../app/widgets/empty_state_widget.dart';

class PrescriptionsPage extends StatelessWidget {
  final bool showBackButton;

  const PrescriptionsPage({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'prescriptions'.tr(context),
        centerTitle: true,
        showBackButton: showBackButton,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prescriptions List
            Expanded(
              child: BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
                builder: (context, state) {
                  if (state.status == PrescriptionsStatus.loading) {
                    return _buildShimmer(context);
                  }
                  if (state.status == PrescriptionsStatus.failure) {
                    // Handle new user no profile error as empty state
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
                    return Center(child: Text(state.errorMessage ?? 'Error'));
                  }
                  if (state.prescriptions.isEmpty) {
                    return EmptyStateWidget(
                      title: 'empty_prescriptions_title'.tr(context),
                      message: 'empty_prescriptions_msg'.tr(context),
                      icon: Iconsax.document_text,
                    );
                  }
                  return _buildPrescriptionsList(context, state.prescriptions);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionsList(
      BuildContext context, List<PrescriptionEntity> prescriptions) {
    // Group prescriptions by month
    final groupedPrescriptions = <String, List<PrescriptionEntity>>{};

    for (final prescription in prescriptions) {
      final month = _getMonthFromDate(context, prescription.date);
      groupedPrescriptions.putIfAbsent(month, () => []).add(prescription);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: groupedPrescriptions.length,
      itemBuilder: (context, index) {
        final month = groupedPrescriptions.keys.elementAt(index);
        final monthPrescriptions = groupedPrescriptions[month]!;

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

            // Prescriptions in this month
            ...monthPrescriptions.map((prescription) => PrescriptionCard(
                  prescriptionId: prescription.id,
                  date: prescription.date,
                  doctorName: prescription.doctorName,
                  medicineCount: prescription.medicines.length,
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
                )),

            SizedBox(height: 8.h),
          ],
        );
      },
    );
  }

  String _getMonthFromDate(BuildContext context, String date) {
    try {
      // Only if format allows, otherwise just return header
      // Assuming raw Date String for now or simple format
      return 'RECENT PRESCRIPTIONS';
    } catch (e) {
      return 'RECENT PRESCRIPTIONS';
    }
  }

  Widget _buildShimmer(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                ShimmerLoading(
                  width: 50.w,
                  height: 50.h,
                  borderRadius: 12.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(width: 150.w, height: 18.h),
                      SizedBox(height: 8.h),
                      ShimmerLoading(width: 100.w, height: 14.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
